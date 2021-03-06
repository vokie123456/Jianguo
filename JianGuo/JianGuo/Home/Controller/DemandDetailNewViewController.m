//
//  DemandDetailNewViewController.m
//  JianGuo
//
//  Created by apple on 17/6/12.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandDetailNewViewController.h"
#import "LCCKConversationViewController.h"
#import "LoginNew2ViewController.h"
#import "PostSuccessViewController.h"
#import "DemandListViewController.h"
#import "MineChatViewController.h"

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
#import "SDWebImageManager.h"
#import "XLPhotoBrowser.h"
#import "DateOrTimeTool.h"
#import "ShareView.h"
#import "UITextView+placeholder.h"
#import <IQKeyboardManager.h>
#import "UIColor+Hex.h"


@interface DemandDetailNewViewController ()<UITableViewDataSource,UITableViewDelegate,CommentCellDelegate,FinishEditDelegate,XLPhotoBrowserDelegate,XLPhotoBrowserDatasource>
{
    DemandDetailModel *detailModel;
    NSMutableArray *typeNameArr;
    __weak IBOutlet UIImageView *iconView;
    __weak IBOutlet NSLayoutConstraint *timeLimitViewCons;
    
    BOOL firstImage;
    BOOL secondImage;
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

@property (nonatomic,strong) UIImageView *likeView;


@property (nonatomic,strong) NSMutableArray *imagesArr;
@property (nonatomic,strong) NSMutableArray *commentArr;
@property (nonatomic,strong) NSMutableArray *commentAll;

@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *toUserId;


@end

@implementation DemandDetailNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.hidden = YES;
    
    [NotificationCenter addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    self.navigationController.hidesBarsWhenKeyboardAppears = NO;
    
    [self customBottomView];
    
    [self customCommentKeyboard];
    
    [self setNavigationBar];
    
    self.commentAll = @[].mutableCopy;
    
//    NSArray *demandTypeArr= JGKeyedUnarchiver(JGDemandTypeArr);
    typeNameArr = @[@"学习交流",@"跑腿代劳",@"技能服务",@"娱乐生活",@"情感地带",@"易货求购"].mutableCopy;
//    for (DemandTypeModel *model in demandTypeArr) {
//        if (model.type_id.integerValue == 0) {
//            continue;
//        }
//        [typeNameArr addObject:model.type_name];
//    }
    
    self.navigationItem.title = @"任务详情";
    
    self.tableView.estimatedRowHeight = 100;
    
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
    
    if (self.navigationController.viewControllers.lastObject == self) {
        self.commentView.hidden = NO;
    }
    
    
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//
//    [APPLICATION.keyWindow endEditing:YES];
//    [self.commentView removeFromSuperview];
//    self.commentView = nil;
//}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [APPLICATION.keyWindow endEditing:YES];
    if (![self.navigationController.viewControllers containsObject:self]) {
        [self.commentView removeFromSuperview];
        self.commentView = nil;
    }else{
        if (self.navigationController.viewControllers.lastObject == self) {
            self.commentView.hidden = YES;
        }
    }
}

//关注
- (IBAction)followSomeOne:(id)sender {
    
    
    if (USER.tel.length!=11) {
        
        LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    //1==关注 , 0==取消
    [JGHTTPClient followUserWithUserId:detailModel.userId status:@"1" Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showAlertViewWithText:@"关注成功" duration:1];
            [sender setHidden:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


-(void)requestWithCount:(NSString *)count
{
    
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
            
            NSMutableArray *addArr = @[].mutableCopy;
            [self.commentArr addObjectsFromArray:[CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            for (CommentModel *model in [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.commentAll addObject:model];
                [self.commentAll addObjectsFromArray:model.childComments];
                [addArr addObject:model];
                [addArr addObjectsFromArray:model.childComments];
            }
            
//            NSMutableArray *indexPaths = [NSMutableArray array];
//            for (int i=0; i<addArr.count; i++) {
//                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.commentAll.count-addArr.count+i inSection:2];
//                [indexPaths addObject:indexPath];
//            }
            
            [self.tableView reloadData];
//            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            return;
            
        }else{
            self.commentArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.commentAll removeAllObjects];
            for (CommentModel *model in self.commentArr) {
                [self.commentAll addObject:model];
                [self.commentAll addObjectsFromArray:model.childComments];
                for (CommentModel *model_ in model.childComments) {
                    JGLog(@"––––––––––>>>>>>%@",model_.pid);
                }
            }
            
            [self.tableView reloadData];
            return;
        }
        
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
//        if ([CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
//            [self showAlertViewWithText:@"没有更多数据" duration:1];
//            return ;
//        }
        
        
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
    
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getDemandDetailsWithDemandId:self.demandId userId:nil Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] ==200) {
            
            self.tableView.hidden = NO;
            detailModel = [DemandDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",detailModel.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
            self.nameL.text = detailModel.nickname.length?detailModel.nickname:@"未填写";
            self.schoolL.text = detailModel.schoolName;
            if ([detailModel.money containsString:@"."]) {
                self.moneyL.text = [NSString stringWithFormat:@"%.2f元",detailModel.money.floatValue];
            }else{
                self.moneyL.text = [NSString stringWithFormat:@"%@元",detailModel.money];
            }
            self.enrollCountL.text = [NSString stringWithFormat:@"已报名 %@ 人",detailModel.enrollCount];
            self.timeLimitL.text = [DateOrTimeTool getDateStringBytimeStamp:detailModel.limitTime.floatValue];
            
            if (detailModel.isFollow.boolValue) {
                self.followB.hidden = YES;
            }
            if (detailModel.demandStatus.integerValue==1) {
                
                
                if (detailModel.enrollStatus.integerValue!=0) {
                    [self.signButton setTitle:@"已报名" forState:UIControlStateNormal];
                    self.signButton.userInteractionEnabled = NO;
                    [self.signButton setBackgroundColor:LIGHTGRAY1];
                }
                
            }else{
                
                [self.signButton setTitle:@"已完成" forState:UIControlStateNormal];
                self.signButton.userInteractionEnabled = NO;
                [self.signButton setBackgroundColor:LIGHTGRAY1];
            }
            
            self.likeView.image = [UIImage imageNamed:detailModel.isLike.integerValue == 1?@"xin":@"fabulous"];
            
            
            if (detailModel.limitTime.integerValue == 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.headerView layoutIfNeeded];
                    timeLimitViewCons.constant = 0;
                    self.headerView.height = 115-44;
                }];
            }
            [self.tableView reloadData];
            
        }else if ([responseObject[@"code"] integerValue] == 600){
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==2?60:0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
        headerView.backgroundColor = BACKCOLORGRAY;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_W, 45)];
        view.backgroundColor = WHITECOLOR;
        
        UIImageView *commentView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 21, 21)];
        commentView.image = [UIImage imageNamed:@"msessage"];
        
        UILabel *commentCountL = [[UILabel alloc] initWithFrame:CGRectMake(commentView.right+10, 0, 100, 43)];
        commentCountL.textColor = LIGHTGRAYTEXT;
        commentCountL.font = FONT(15);
        commentCountL.text = detailModel.commentCount;
        
        [view addSubview:commentView];
        [view addSubview:commentCountL];
        
        [headerView addSubview:view];
        
        return headerView;
        
    }else
        return nil;
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
            return UITableViewAutomaticDimension;
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
            NSArray *array = @[@"#feb369",@"#70a9fc",@"#8e96e9",@"#c9a269",@"#fa7070",@"#71c268"];
            
            cell.typeL.backgroundColor = [UIColor colorWithHexString:array[detailModel.type.integerValue-1]];
            cell.typeL.text = typeNameArr[detailModel.type.integerValue-1];
            return cell;
        }else if (indexPath.row == detailModel.images.count+1){
            DDScanCountCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDScanCountCell class]) owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.likeL.text = detailModel.likeCount;
            cell.scanL.text = detailModel.viewCount;
            if (detailModel.isLike.boolValue) {
                
            }
            return cell;
        }else{
            DemandDetailImageCell *cell = [DemandDetailImageCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:detailModel.images[indexPath.row-1]] placeholderImage:[UIImage imageNamed:@"placeholderPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                cell.iconViewHeightCons.constant = (SCREEN_W-40)*image.size.height/image.size.width;
                
                NSString *url = [NSString stringWithFormat:@"%@",imageURL];
                
                NSInteger index = [detailModel.images indexOfObject:url];
                
//                if (indexPath.row ==1) {
//                    firstImage = YES;
//                }else if (indexPath.row == 2){
//                    secondImage = YES;
//                }
                
                DemandDetailImageCell *cell_ = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0]];
                
                if (cell_.iconView.height == 240) {
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            
            return cell;
        }
    }else if (indexPath.section == 1){
        DDUserInfoCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DDUserInfoCell class]) owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = detailModel;
        
        
        if (detailModel.isFollow.boolValue) {
            cell.followB.hidden = YES;
        }
        
        
        return cell;
    }else{
        CommentCell *cell = [CommentCell cellWithTableView:tableView];
        cell.delegate = self;
        CommentModel *model = self.commentAll[indexPath.row];
        
        cell.model = model;
        
        return cell;
    }
}


//点击评论cell的头像
-(void)clickIcon:(NSString *)userId
{
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
    mineChatVC.hidesBottomBarWhenPushed = YES;
    mineChatVC.userId = userId;
    [self.navigationController pushViewController:mineChatVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row>0&&indexPath.row<detailModel.images.count+2) {
            
            XLPhotoBrowser *browser = [[XLPhotoBrowser alloc] init];
            browser.tag = 101;
            browser.datasource = self;
            browser.imageCount = detailModel.images.count;
            browser.currentImageIndex = indexPath.row-1;
            [browser show];
            [browser setActionSheetWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" deleteButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        }
    }else if (indexPath.section == 2){
        CommentModel *model = self.commentAll[indexPath.row];
        self.toUserId = model.userId;
        self.pid = model.pid.integerValue==0?model.id:model.pid;
        self.commentTV.placeholder = [NSString stringWithFormat:@"回复:%@",model.nickname];
        [self.commentTV becomeFirstResponder];
    }else if (indexPath.section == 1){
        
        MineChatViewController *userVC = [[MineChatViewController alloc] init];
        userVC.hidesBottomBarWhenPushed = YES;
        userVC.userId = detailModel.userId;
        [self.navigationController pushViewController:userVC animated:YES];
        
    }
    
    
}


- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    if (actionSheetindex==0) {
        [browser saveCurrentShowImage];
    }
}

-(NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:detailModel.images[index]];
   
}

-(UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"placeholderPic"];
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
        
        CommentModel *model = self.commentAll[indexPath.row];
        
        //TODO: 调用删除评论的接口
        [JGHTTPClient deleteCommentWithCommentId:model.id Success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [self.commentAll removeObject:model];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
            }else{
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
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

    chat.clickBlock = ^(UIButton *sender){
        
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
        if (detailModel.userId.integerValue == USER.login_id.integerValue) {
            [block_self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
            return ;
        }
        
        LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:detailModel.userId]];
        
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
        block_self.commentTV.placeholder = @"请输入文字";
        [block_self.commentTV becomeFirstResponder];
        
        
    };
    [view addSubview:comment];
    CheckBoxButton *like = [[CheckBoxButton alloc] initWithFrame:CGRectMake(comment.right, 0, chat.width, chat.height)];
    
    like.imageV.image = [UIImage imageNamed:detailModel.isLike.integerValue == 1?@"xin":@"fabulous"];
    
    self.likeView = like.imageV;
    
    like.label.text = @"点赞";
    
    __weak CheckBoxButton *_weakLike = like;
    like.clickBlock = ^(UIButton *sender){//点赞
        NSString *status;
        if (detailModel.isLike.integerValue == 1) {
            status = @"0";
        }else{
            status = @"1";
        }
        [JGHTTPClient praiseForDemandWithDemandId:block_self.demandId likeStatus:status Success:^(id responseObject) {
            
            [block_self showAlertViewWithText:responseObject[@"message"] duration:1.f];
            if ([responseObject[@"code"] integerValue] == 200) {
                
                if (status.integerValue == 1) {
                    detailModel.isLike = @"1";
                }else{
                    detailModel.isLike = @"0";
                }
                _weakLike.imageV.image = [UIImage imageNamed:status.integerValue == 1?@"xin":@"fabulous"];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
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
-(void)sign:(UIButton *)sender
{
    if (USER.login_id.integerValue<1) {
        [self gotoCodeVC];
        return;
    }
    
    if (USER.resume.intValue == 0){
        [self showAlertViewWithText:@"请您先去完善资料" duration:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoProfileVC];
        });
        return;
    }
    
    if (detailModel.userId.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能报自己发布的任务!" duration:1];
        return ;
    }
    
    JGSVPROGRESSLOAD(@"正在报名...")
    [JGHTTPClient signDemandWithDemandId:self.demandId userId:nil status:nil
                                  reason:nil Success:^(id responseObject) {
                                      [SVProgressHUD dismiss];
                     
                                      [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
          if ([responseObject[@"code"]integerValue]==200) {

              
              [self.signButton setBackgroundColor:[UIColor lightGrayColor]];
              [self.signButton setTitle:@"已经约了" forState:UIControlStateNormal];
              
              DemandListViewController *vc = (DemandListViewController *)self.navigationController.viewControllers.firstObject;
              [self.navigationController popToRootViewControllerAnimated:YES];
              PostSuccessViewController *postVC = [[PostSuccessViewController alloc] init];
              postVC.labelStr = @"register";
              postVC.transitioningDelegate = vc;//代理必须遵守这个专场协议
              postVC.modalPresentationStyle = UIModalPresentationCustom;
              [self.navigationController.viewControllers.firstObject presentViewController:postVC animated:YES completion:nil];
              
              
          }
          
          
      } failure:^(NSError *error) {
          [SVProgressHUD dismiss];
          [self showAlertViewWithText:NETERROETEXT duration:1];
          
      }];
}

//添加输入框
-(void)customCommentKeyboard
{
    CommentInputView *view = [CommentInputView aReplyCommentView:nil];
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
    JGSVPROGRESSLOAD(@"正在请求...");
    [JGHTTPClient postAcommentWithDemandId:self.demandId content:self.commentTV.text pid:self.pid toUserId:self.toUserId Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 200) {
            [self requestWithCount:@"1"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1.f];
        
    }];
    
    self.commentTV.text = nil;
    self.commentTV.placeholder = @"请输入文字";
}


-(void)setNavigationBar
{
    UIButton *btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"demandshare"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(shareDemand:) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 16, 15);
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
/**
 *  分享
 */
-(void)shareDemand:(UIButton *)btn
{
    [APPLICATION.keyWindow endEditing:YES];
    ShareView *shareView = [ShareView aShareView];
    shareView.demandModel = detailModel;
    [shareView show];
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
