//
//  DemandDetailController.m
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandDetailController.h"
#import "MineChatViewController.h"
#import "HomeSegmentViewController.h"
#import "PostSuccessViewController.h"
#import "DemandDetailCell.h"
#import "CommentCell.h"
#import "JGHTTPClient+Demand.h"
#import "DemandModel.h"
#import "CommentModel.h"
#import "ShareView.h"
#import "CheckBoxButton.h"
#import "CommentInputView.h"
#import "UITextView+placeholder.h"
#import <UIImageView+WebCache.h>
#import <IQKeyboardManager.h>
#import "XLPhotoBrowser.h"
#import "LCChatKit.h"
#import "DemandModel.h"

#define HeaderImageHeight 747/3

@interface DemandDetailController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,FinishEditDelegate,UITextFieldDelegate,CommentCellDelegate>
{
    CGFloat currentPostion;
    CGFloat lastPosition;

    __weak IBOutlet NSLayoutConstraint *bottomCons;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) DemandModel *demandModel;
@property (nonatomic,strong) UILabel *countL;
@property (nonatomic,strong) UITextView *commentTV;
@property (nonatomic,strong) CommentInputView *commentView;
@property (nonatomic,strong) UIImageView *demandView;
@property (nonatomic,strong) UIToolbar *bottomView;
@property (nonatomic,strong) UIButton *signButton;

@property (nonatomic,copy) NSString *to_user_id;

@end

@implementation DemandDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"任务详情";
    
    [NotificationCenter addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.tableView.estimatedRowHeight = 110;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
//    [self customNavigationBtn];
    
    [self addInsetScaleImageView];
    
//    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        pageCount = 0;
//        [self requestDemandDetail];
//        [self requestCommentsWithPageCount:@"1"];
//        
//    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
        [self requestCommentsWithPageCount:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];
    
    [self setNavigationBar];//导航栏上的分享按钮
    
    [self requestDemandDetail];
    [self requestCommentsWithPageCount:@"1"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isSelf) {
        bottomCons.constant = 0;
    }else{
        [self customBottomView];
    }
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
//    [IQKeyboardManager sharedManager].enable = YES;
    [APPLICATION.keyWindow endEditing:YES];
    [self.bottomView removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


-(void)setNavigationBar
{
    UIButton *btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"icon_fenxiang"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(shareDemand:) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 20, 20);
    
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
    shareView.demandModel = self.demandModel;
    [shareView show];
}


-(void)requestDemandDetail
{
    
    [JGHTTPClient getDemandDetailsWithDemandId:self.demandId userId:USER.login_id Success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            
            self.demandModel = [DemandModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.demandView sd_setImageWithURL:[NSURL URLWithString:self.demandModel.d_image] placeholderImage:[UIImage imageNamed:@"kobe"]];
            if (self.demandModel.enroll_status.integerValue!=0||self.demandModel.d_status.integerValue!=1) {
                self.signButton.userInteractionEnabled = NO;
                [self.signButton setBackgroundColor:[UIColor lightGrayColor]];
                [self.signButton setTitle:@"交易达成" forState:UIControlStateNormal];
                
            }else if (self.demandModel.d_status.integerValue == 7||self.demandModel.d_status.integerValue == 8){
                
                self.signButton.userInteractionEnabled = NO;
                
                [self.signButton setTitle:@"已下架" forState:UIControlStateNormal];
                
            }
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(void)requestCommentsWithPageCount:(NSString *)count
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
            
            NSMutableArray *sections = [NSMutableArray array];
            for (CommentModel *model in [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:1];
                [sections addObject:indexPath];
            }
            
//            [self.tableView insertRowsAtIndexPaths:sections withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadData];
            return;
            
        }else{
            self.dataArr = [CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//            if (self.dataArr.count == 0) {
//                bgView.hidden = NO;
//            }else{
//                bgView.hidden = YES;
//            }
        }
        
        [self.tableView reloadData];
        if ([CommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
            [self showAlertViewWithText:@"没有更多数据" duration:1];
            return ;
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(void)addInsetScaleImageView
{
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImg)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -HeaderImageHeight, SCREEN_W, HeaderImageHeight)];
    self.demandView = imageView;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"kobe"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    [imageView addGestureRecognizer:tap];

    imageView.tag = 101;
    [self.tableView addSubview:imageView];
    self.tableView.contentInset = UIEdgeInsetsMake(HeaderImageHeight, 0, 0, 0);
//    self.tableView.tableHeaderView = imageView;
}

-(void)showImg
{
    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.demandView.image] currentImageIndex:0];
}

-(void)customNavigationBtn
{
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(shareDemand:) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 20, 20);
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    self.navigationItem.rightBarButtonItem = rightBtn;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section?self.dataArr.count:5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return UITableViewAutomaticDimension;
        }
         return 44;
    }
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        DemandDetailCell *cell = [DemandDetailCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.leftL.text = @"任务名称";
            cell.rightL.text = self.demandModel.title;
        }else if (indexPath.row == 1) {
            cell.leftL.text = @"任务赏金";
            cell.rightL.textColor = RedColor;
            cell.rightL.text = [NSString stringWithFormat:@"赏金 %@ 元",self.demandModel.money];
        }else if (indexPath.row == 2){
            cell.leftL.text = @"任务描述";
            cell.rightL.text = self.demandModel.d_describe;
        }else if (indexPath.row == 3){
            cell.leftL.text = @"任务地点";
            cell.rightL.text = self.demandModel.area;
        }else if (indexPath.row == 4){
            
            UITableViewCell *headerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, SCREEN_W, 40)];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            imgView.image = [UIImage imageNamed:@"news"];
            imgView.center = CGPointMake(15+imgView.width/2, headerCell.contentView.center.y);
            
            UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+5, 0, 100, 40)];
            countL.font = FONT(12);
            countL.textColor = LIGHTGRAYTEXT;
            countL.text = self.demandModel.comment_count;
            [headerView addSubview:imgView];
            [headerView addSubview:countL];
            self.countL = countL;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29, SCREEN_W, 0.8)];
            lineView.backgroundColor = BACKCOLORGRAY;
            [headerView addSubview:lineView];
            
            [headerCell.contentView addSubview:headerView];
            headerCell.contentView.backgroundColor = BACKCOLORGRAY;
            headerView.backgroundColor = BACKCOLORGRAY;
            
            return headerCell;
            
        }
        return cell;
    }else{
        
        CommentCell *cell = [CommentCell  cellWithTableView:tableView];
        cell.postUserId = self.demandModel.b_user_id;
        cell.model = self.dataArr[indexPath.row];
        cell.delegate = self;
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (USER.login_id.integerValue<1) {
        [self gotoCodeVC];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if (USER.resume.intValue == 0){
        [self showAlertViewWithText:@"请您先去完善资料" duration:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoProfileVC];
        });
        return;
    }
    //点击回复
    if (indexPath.section == 1) {
        
        
        CommentModel *model = self.dataArr[indexPath.row];
        
        
        if (model.user_id.integerValue == USER.login_id.integerValue) {
            [self showAlertViewWithText:@"您不能回复自己的评论" duration:1];
            return;
        }
        
        CommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self customCommentKeyboard];
        
        self.to_user_id = model.user_id;
        self.commentTV.placeholder = [NSString stringWithFormat:@"回复 %@",cell.nameL.text];
        [self.commentTV becomeFirstResponder];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    /*这个方法判断scrollView的滑动方向
    currentPostion = scrollView.contentOffset.y;
    
    
    if(currentPostion > lastPosition){//向上滑
       
        NSLog(@"Scroll Up");
        
    }else{//向下滑
        
        NSLog(@"Scroll Down");
        
    }
    
    lastPosition = currentPostion;
    */

    
    if (point.y < -HeaderImageHeight) {
        self.tableView.contentInset = UIEdgeInsetsMake(HeaderImageHeight, 0, 0, 0);
        CGRect rect = [self.tableView viewWithTag:101].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:101].frame = rect;
    }
    
}

-(void)customBottomView
{

    UIToolbar *view = [[UIToolbar alloc] init];
    self.bottomView = view;

    view.frame = CGRectMake(0, SCREEN_H-49, SCREEN_W, 49);
    
    [APPLICATION.keyWindow addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {   //** 用约束总出现问题,不会有CheckBox这一层 **//
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(self.view.mas_bottom);
//        make.height.mas_equalTo(49);
//    }];

    CheckBoxButton *chat = [[CheckBoxButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W*1.5/5, view.height)];
    chat.imageV.image = [UIImage imageNamed:@"chat"];
    chat.label.text = @"果聊";
    chat.clickBlock = ^(UIButton *sender){
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
        if (self.demandModel.b_user_id.integerValue == USER.login_id.integerValue) {
            [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
            return ;
        }
        
        LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.demandModel.b_user_id]];
        
        [self.navigationController pushViewController:conversationViewController animated:YES];
        
    };
    [view addSubview:chat];
    
//    CheckBoxButton *colletion = [[CheckBoxButton alloc] initWithFrame:CGRectMake(chat.right, 0, chat.width, chat.height)];
//    colletion.imageV.image = [UIImage imageNamed:@"demandshare"];
//    colletion.label.text = @"分享";
//    colletion.clickBlock = ^(UIButton *sender){
//        if (USER.login_id.integerValue<1) {
//            [self gotoCodeVC];
//            return;
//        }
//    };
//    [view addSubview:colletion];
    
    CheckBoxButton *comment = [[CheckBoxButton alloc] initWithFrame:CGRectMake(chat.right, 0, chat.width, chat.height)];
    comment.imageV.image = [UIImage imageNamed:@"writecomment"];
    comment.label.text = @"评论";
    comment.clickBlock = ^(UIButton *sender){//评论
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
        [self customCommentKeyboard];
        self.to_user_id = self.demandModel.b_user_id;
        [self.commentTV becomeFirstResponder];
        
    };
    [view addSubview:comment];
    
    
    UIButton *signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signButton setTitle:@"我要报名" forState:UIControlStateNormal];
    [signButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    [signButton setBackgroundColor:GreenColor];
    [view addSubview:signButton];
    self.signButton = signButton;
    [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(comment.mas_trailing);
        make.trailing.equalTo(view.mas_trailing);
        make.height.equalTo(view.mas_height);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
}

-(void)sign:(UIButton *)sender//点击报名
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
    
    if (self.demandModel.b_user_id.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能报自己发布的任务!" duration:1];
        return ;
    }
    
    JGSVPROGRESSLOAD(@"正在报名...")
    [JGHTTPClient signDemandWithDemandId:self.demandId userId:USER.login_id status:@"1"
                                  reason:nil Success:^(id responseObject) {
        [SVProgressHUD dismiss];
                                      
        if ([responseObject[@"code"]integerValue]==200) {
                                          
//            [self showAlertViewWithText:responseObject[@"message"] duration:1];
            
            if (self.callBackBlock) {
                self.callBackBlock();
            }
            
            [self.signButton setBackgroundColor:[UIColor lightGrayColor]];
            [self.signButton setTitle:@"已经约了" forState:UIControlStateNormal];
            
            HomeSegmentViewController *vc = (HomeSegmentViewController *)self.navigationController.viewControllers.firstObject;
            
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


-(void)customCommentKeyboard
{
    CommentInputView *view = [CommentInputView aReplyCommentView:nil];
    view.delegate = self;
    self.commentView = view;
    self.commentTV = view.commentTV;
    [APPLICATION.keyWindow addSubview:view];
    [APPLICATION.keyWindow bringSubviewToFront:view];
    
    
    //    if (self.commentView.commentTV.text.length) {
    //        CGRect rect = [self.commentView.commentTV.text boundingRectWithSize:CGSizeMake(self.commentView.commentTV.size.width,   MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.commentView.commentTV.font} context:nil];
    //        self.commentView.frame = CGRectMake(0, 0, SCREEN_W, rect.size.height+10);
    //    }else{
    //        self.commentView.frame = CGRectMake(0, 0, SCREEN_W, 40);
    //    }
    //
    //    self.commentView.center = CGPointMake(SCREEN_W/2,self.view.bottom+100);
}

-(void)keyboardWillAppear:(NSNotification *)noti
{
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        self.commentView.frame = CGRectMake(0, SCREEN_H-rect.size.height-self.commentView.height, SCREEN_W, self.commentView.height);
    } completion:^(BOOL finished) {

    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    UIViewAnimationOptions option = [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.commentTV.placeholder = nil;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        //        self.commentView.transform = CGAffineTransformIdentity;
        self.commentView.frame = CGRectMake(0, rect.origin.y+rect.size.height, SCREEN_W, self.commentView.height);
    } completion:^(BOOL finished) {
        [self.commentView removeFromSuperview];
        self.commentView = nil;;
    }];
}

-(void)finishEdit//点击完成按钮
{

    if (self.commentTV.text.length==0) {
        [APPLICATION.keyWindow endEditing:YES];
        [self showAlertViewWithText:@"您还没输入内容呢" duration:1];
        return;
    }
    [JGHTTPClient postAcommentWithDemandId:self.demandId content:self.commentView.commentTV.text pid:USER.login_id toUserId:self.to_user_id Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"]integerValue]==200) {
            
            [self requestCommentsWithPageCount:@"1"];
            
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
    [self.commentTV resignFirstResponder];
    self.commentTV.text = nil;
    
}

//点击用户头像
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

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


@end
