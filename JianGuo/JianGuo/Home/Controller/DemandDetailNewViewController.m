//
//  DemandDetailNewViewController.m
//  JianGuo
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandDetailNewViewController.h"
#import "LCCKConversationViewController.h"

#import "DemandDetailImageCell.h"
#import "DDTitleCell.h"
#import "DDScanCountCell.h"
#import "DDUserInfoCell.h"
#import "CommentCell.h"
#import "CheckBoxButton.h"
#import "CommentInputView.h"

#import "DemandDetailModel.h"
#import "DemandTypeModel.h"
#import "CommentModel.h"

#import "JGHTTPClient+Demand.h"
#import "UIImageView+WebCache.h"
#import "XLPhotoBrowser.h"
#import "DateOrTimeTool.h"
#import "UITextView+placeholder.h"
#import <IQKeyboardManager.h>


@interface DemandDetailNewViewController ()<UITableViewDataSource,UITableViewDelegate,CommentCellDelegate,FinishEditDelegate>
{
    DemandDetailModel *detailModel;
    NSMutableArray *typeNameArr;
    __weak IBOutlet UIImageView *iconView;
    __weak IBOutlet NSLayoutConstraint *timeLimitViewCons;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitL;
@property (weak, nonatomic) IBOutlet UIButton *followB;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *enrollCountL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,weak) UIToolbar *bottomView;
@property (nonatomic,weak) UIButton *signButton;
@property (nonatomic,strong) CommentInputView *commentView;
@property (nonatomic,strong) UITextView *commentTV;



@property (nonatomic,strong) NSMutableArray *imagesArr;
@property (nonatomic,strong) NSMutableArray *commentArr;
@property (nonatomic,strong) NSMutableArray *commentAll;

@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *toUserId;


@end

@implementation DemandDetailNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [NotificationCenter addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    self.navigationController.hidesBarsWhenKeyboardAppears = NO;
    
    [self customBottomView];
    
    [self customCommentKeyboard];
    
    self.commentAll = @[].mutableCopy;
    
    NSArray *demandTypeArr= JGKeyedUnarchiver(JGDemandTypeArr);
    typeNameArr = @[].mutableCopy;
    for (DemandTypeModel *model in demandTypeArr) {
        if (model.type_id.integerValue == 0) {
            continue;
        }
        [typeNameArr addObject:model.type_name];
    }
    
    self.navigationItem.title = @"任务详情";
    
    self.tableView.estimatedRowHeight = 80;
    
    [self requestDetail];
    IMP_BLOCK_SELF(DemandDetailNewViewController);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        __block NSInteger blockPageCount = ((int)block_self.commentArr.count/10) + ((int)(block_self.commentArr.count/10)>=1?1:2) + ((block_self.commentArr.count%10)>0&&block_self.commentArr.count>10?1:0);
        [block_self requestWithCount:[NSString stringWithFormat:@"%ld",(long)blockPageCount]];
    }];
    [self requestWithCount:@"1"];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    //    [self customCommentKeyboard];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [APPLICATION.keyWindow endEditing:YES];
    [self.commentView removeFromSuperview];
    self.commentView = nil;
}

-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getCommentsListWithDemandId:self.demandId pageNum:count pageSize:nil Success:^(id responseObject) {
       
       [SVProgressHUD dismiss];
       [self.tableView.mj_header endRefreshing];
       [self.tableView.mj_footer endRefreshing];
       JGLog(@"%@",responseObject);
        
        if (count.integerValue>1) {//上拉加载
            
            if ([[CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            
            
            for (CommentModel *model in [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.commentAll addObject:model];
                [self.commentAll addObjectsFromArray:model.childComments];
            }
            
            NSMutableArray *sections = [NSMutableArray array];
            for (CommentModel *model in self.commentAll) {
                [self.commentArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.commentArr.count-1 inSection:2];
                [sections addObject:indexPath];
            }
            
            
            [_tableView insertRowsAtIndexPaths:sections withRowAnimation:UITableViewRowAnimationFade];
            
            //            [self.tableView insertRowsAtIndexPaths:sections withRowAnimation:UITableViewRowAnimationFade];
            //            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView reloadData];
            return;
            
        }else{
            self.commentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for (CommentModel *model in self.commentArr) {
                [self.commentAll addObject:model];
                [self.commentAll addObjectsFromArray:model.childComments];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        if ([CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
            [self showAlertViewWithText:@"没有更多数据" duration:1];
            return ;
        }
        
        
//        self.commentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        for (CommentModel *model in self.commentArr) {
//            [self.commentAll addObject:model];
//            [self.commentAll addObjectsFromArray:model.childComments];
//        }
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];

       
   } failure:^(NSError *error) {
       [SVProgressHUD dismiss];
       [self.tableView.mj_header endRefreshing];
       [self.tableView.mj_footer endRefreshing];
       [self showAlertViewWithText:NETERROETEXT duration:1];
       
    }];
}

-(void)requestDetail
{
    [JGHTTPClient getDemandDetailsWithDemandId:self.demandId userId:nil Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] ==200) {
            detailModel = [DemandDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",detailModel.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
            self.nameL.text = detailModel.nickname.length?detailModel.nickname:@"未填写";
            self.schoolL.text = detailModel.schoolName;
            self.moneyL.text = [[NSString stringWithFormat:@"%.2f",detailModel.money.floatValue] stringByAppendingString:@" 元"];
            self.enrollCountL.text = [NSString stringWithFormat:@"已报名 %@ 人",detailModel.enrollCount];
            self.timeLimitL.text = [DateOrTimeTool getDateStringBytimeStamp:detailModel.limitTime.floatValue];
            
            [self.tableView reloadData];
            if (detailModel.limitTime.integerValue == 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.headerView layoutIfNeeded];
                    timeLimitViewCons.constant = 0;
                    self.headerView.height = 115-44;
                }];
            }
            
        }else if ([responseObject[@"code"] integerValue] == 600){
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section>0?15:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            return UITableViewAutomaticDimension;
        }else if (indexPath.row == detailModel.images.count+1){
            return 44;
        }else{
            return 250;
        }
    }else{
        return UITableViewAutomaticDimension;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return detailModel?detailModel.images.count+2:0;
    }else if (section == 1){
        return 1;
    }else{
        return self.commentAll.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DDTitleCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDTitleCell class]) owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleL.text = detailModel.title;
            cell.contentL.text = detailModel.demandDesc;
            if (detailModel.type.integerValue>1) {
                cell.typeL.text = typeNameArr[detailModel.type.integerValue-1];
            }
            return cell;
        }else if (indexPath.row == detailModel.images.count+1){
            DDScanCountCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDScanCountCell class]) owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.likeL.text = detailModel.likeCount;
            cell.scanL.text = detailModel.viewCount;
            return cell;
        }else{
            DemandDetailImageCell *cell = [DemandDetailImageCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:detailModel.images[indexPath.row-1]] placeholderImage:nil];
            return cell;
        }
    }else if (indexPath.section == 1){
        DDUserInfoCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDUserInfoCell class]) owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:detailModel.headImg] placeholderImage:[UIImage imageNamed:@"myicon"]];
        cell.schoolL.text = detailModel.schoolName;
        cell.contentL.text = [self getPersonInfoStr];
        cell.nameL.text = detailModel.nickname.length?detailModel.nickname:@"未填写";
        cell.statusView.image = [UIImage imageNamed:(detailModel.authStatus.integerValue?@"adopt":@"authentication1")];
        cell.statusL.text = @"暂未通过实名认证!";
        
        return cell;
    }else{
        CommentCell *cell = [CommentCell cellWithTableView:tableView];
        cell.delegate = self;
        CommentModel *model = self.commentAll[indexPath.row];
        
        cell.model = model;
        
        return cell;
    }
}

//获取个人信息字符串
-(NSString *)getPersonInfoStr
{
    NSString *string;
    if (detailModel.birthDate.length>=10) {
        
        string = [NSString stringWithFormat:@"%@年%@%@孩,在兼果发布过%@条任务,完成过%@条任务.",[detailModel.birthDate substringWithRange:NSMakeRange(2, 2)],[DateOrTimeTool getConstellation:detailModel.birthDate],detailModel.sex.integerValue==2?@"男":@"女",detailModel.publishDemandCount,detailModel.completedDemandCount];
    }else{
        string = [NSString stringWithFormat:@"妙龄处女座%@孩,在兼果发布过%@条任务,完成过%@条任务.",detailModel.sex.integerValue==2?@"男":@"女",detailModel.publishDemandCount,detailModel.completedDemandCount];
    }
    return string;
}

//点击评论cell的头像
-(void)clickIcon:(NSString *)userId
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row>0&&indexPath.row<detailModel.images.count+2) {
            [XLPhotoBrowser showPhotoBrowserWithImages:detailModel.images currentImageIndex:indexPath.row-1];
        }
    }else if (indexPath.section == 2){
        CommentModel *model = self.commentAll[indexPath.row];
        self.toUserId = model.userId;
        self.pid = model.pid.integerValue==0?model.id:model.pid;
        self.commentTV.placeholder = [NSString stringWithFormat:@"回复:%@",model.nickname];
        [self.commentTV becomeFirstResponder];
    }
    
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==2) {
        CommentModel *model = self.commentAll[indexPath.row];
        if (model.canDelete.boolValue) {
            return UITableViewCellEditingStyleDelete;
        }
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        //TODO: 调用删除评论的接口
        CommentModel *model = self.commentAll[indexPath.row];
        [self.commentAll removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}

//自定义底部工具条
-(void)customBottomView
{
    
    UIToolbar *view = [[UIToolbar alloc] init];
    self.bottomView = view;
    
    view.frame = CGRectMake(0, SCREEN_H-49, SCREEN_W, 49);
    
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {   //** 用约束总出现问题,不会有CheckBox这一层 **//
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(49);
    }];
     CheckBoxButton *chat = [[CheckBoxButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W*1/5, view.height)];
    chat.imageV.image = [UIImage imageNamed:@"chat"];
    chat.label.text = @"果聊";
    
    IMP_BLOCK_SELF(DemandDetailNewViewController);
    __weak CheckBoxButton *clockChat = chat;
    __weak DemandDetailModel *model = detailModel;
    clockChat.clickBlock = ^(UIButton *sender){
        if (USER.login_id.integerValue<1) {
            [block_self gotoCodeVC];
            return;
        }
        if (USER.resume.intValue == 0){
            [block_self showAlertViewWithText:@"请您先去完善资料" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [block_self gotoProfileVC];
            });
            return;
        }
        if (model.userId.integerValue == USER.login_id.integerValue) {
            [block_self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
            return ;
        }
        
        LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:model.userId]];
        
        [block_self.navigationController pushViewController:conversationViewController animated:YES];
    
    };
    [view addSubview:chat];

    
    CheckBoxButton *comment = [[CheckBoxButton alloc] initWithFrame:CGRectMake(chat.right, 0, chat.width, chat.height)];
    comment.imageV.image = [UIImage imageNamed:@"writecomment"];
    comment.label.text = @"评论";
    comment.clickBlock = ^(UIButton *sender){//评论
        if (USER.login_id.integerValue<1) {
            [block_self gotoCodeVC];
            return;
        }
        if (USER.resume.intValue == 0){
            [block_self showAlertViewWithText:@"请您先去完善资料" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [block_self gotoProfileVC];
            });
            return;
        }
        block_self.toUserId = @"0";
        block_self.pid = @"0";
        [block_self.commentTV becomeFirstResponder];
        
        
    };
    [view addSubview:comment];
    CheckBoxButton *like = [[CheckBoxButton alloc] initWithFrame:CGRectMake(comment.right, 0, chat.width, chat.height)];
    like.imageV.image = [UIImage imageNamed:@"fabulous"];
    like.label.text = @"点赞";
    like.clickBlock = ^(UIButton *sender){//点赞
        
    };
    [view addSubview:like];
    
    
    UIButton *signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signButton setTitle:@"我要报名" forState:UIControlStateNormal];
    [signButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    [signButton setBackgroundColor:GreenColor];
    [view addSubview:signButton];
    self.signButton = signButton;
    [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(like.mas_trailing);
        make.trailing.equalTo(view.mas_trailing);
        make.height.equalTo(view.mas_height);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
}

//评论
-(void)commentDemand
{
    
}
//添加输入框
-(void)customCommentKeyboard
{
    CommentInputView *view = [CommentInputView aReplyCommentView:nil];
//    view.frame = CGRectMake(0, APPLICATION.keyWindow.frame.origin.y+APPLICATION.keyWindow.frame.size.height, SCREEN_W, self.commentView.height);
    view.delegate = self;
    self.commentView = view;
    self.commentTV = view.commentTV;
    view.commentTV.placeholder = @"请输入文字";
    [APPLICATION.keyWindow addSubview:view];
    [APPLICATION.keyWindow bringSubviewToFront:view];
    JGLog(@"%@",APPLICATION.keyWindow);
    view.frame = CGRectMake(0, APPLICATION.keyWindow.frame.size.height, SCREEN_W, self.commentView.height);
    
    
}
//点击发送按钮
-(void)finishEdit
{
    [self.commentTV resignFirstResponder];
    [JGHTTPClient postAcommentWithDemandId:detailModel.self.demandId content:self.commentTV.text pid:self.pid toUserId:self.toUserId Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"] integerValue] == 200) {
            [self requestWithCount:@"1"];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    self.commentTV.text = nil;
    self.commentTV.placeholder = @"请输入文字";
}


-(void)keyboardWillAppear:(NSNotification *)noti
{
    self.tableView.userInteractionEnabled = NO;
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        
        self.commentView.frame = CGRectMake(0, SCREEN_H-rect.size.height-self.commentView.height, SCREEN_W, self.commentView.height);
        
    } completion:^(BOOL finished) {
        [IQKeyboardManager sharedManager].enable = YES;
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    self.tableView.userInteractionEnabled = YES;
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    [UIView animateWithDuration:duration delay:0 options:option animations:^{
            //        self.commentView.transform = CGAffineTransformIdentity;
            self.commentView.frame = CGRectMake(0, rect.origin.y+rect.size.height, SCREEN_W, self.commentView.height);
    } completion:^(BOOL finished) {
        [IQKeyboardManager sharedManager].enable = NO;
    }];
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}



@end
