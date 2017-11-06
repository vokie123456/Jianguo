//
//  JianZhiDetailController.m
//  JianGuo
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JianZhiDetailController.h"
#import "SelectCollectionCell.h"
#import "DetailsCell.h"
#import "DetailHeaderCell.h"
#import "WorkDetailCell.h"
#import "BusinessCell.h"
#import "JGHTTPClient+Home.h"
#import "DetailModel.h"
#import "JianzhiModel.h"
#import <Masonry.h>
#import "LoginNew2ViewController.h"
#import "SignUpView.h"
#import "ShareView.h"
#import "LCChatKit.h"

@interface JianZhiDetailController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,clickMoreBtnDelegate,ClickCallPhoneDelegate>
{
    UIButton *signUpBtn;
    BOOL _isMore;
}
@property (nonatomic,strong) UIImageView *noNetView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DetailModel *detailModel;
@property (nonatomic,strong) UIImageView *collectionView;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UILabel *dateL;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) NSMutableArray *welfareArr;

@end

@implementation JianZhiDetailController

-(NSMutableArray *)welfareArr
{
    if (!_welfareArr) {
        _welfareArr = [NSMutableArray array];
    }
    return _welfareArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.rowHeight = 80;
//        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [NotificationCenter addObserver:self selector:@selector(refreshCellHeight:) name:@"contentSizeChanged" object:nil];
    
    self.title = @"工作详情";
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 自适应单元格高度
    self.tableView.estimatedRowHeight = 150; //先估计一个高度
    
    [self configBottomBar];
    
//    [self setNavigationBar];
  
    [self configNoNetView];

    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    IMP_BLOCK_SELF(JianZhiDetailController);
    [JGHTTPClient lookPartJobsDetailsByJobid:self.jobId merchantId:nil loginId:[JGUser user].login_id alike:@"0" Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject);
        if (responseObject) {
            if ([responseObject[@"code"] integerValue]==200) {

                block_self.detailModel = [DetailModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];

                if (block_self.detailModel.isFavorite.intValue == 1) {
                    block_self.collectionView.image = [UIImage imageNamed:@"icon_yipingjia"];
                };
                if (block_self.detailModel.join_status.intValue == 1) {
                    signUpBtn.backgroundColor = LIGHTGRAYTEXT;
                    [signUpBtn setTitle:@"已报名" forState:UIControlStateNormal];
                    signUpBtn.userInteractionEnabled = NO;
                }
                
                self.welfareArr = [NSMutableArray arrayWithArray:[responseObject[@"data"] objectForKey:@"welfare_name"]];
                
                
                [block_self.tableView reloadData];
                if (!self.detailModel) {
                    self.noNetView.hidden = NO;
                }
                
            }
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!self.detailModel) {
            self.noNetView.hidden = NO;
        }
    }];
}

/**
 *  没加载出数据时的图片
 */
-(void)configNoNetView
{
    CGFloat top;
    if (IS_IPHONE5) {
        top = 120;
    }else if (IS_IPHONE6){
        top = 150;
    }else if (IS_IPHONE6PLUS){
        top = 200;
    }else{
        top = 200;
    }
    self.noNetView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-198*(SCREEN_W/414))/2, top, 198*(SCREEN_W/414), 228*(SCREEN_W/414))];
    self.noNetView.image = [UIImage imageNamed:@"netnull"];
    [self.tableView addSubview:self.noNetView];
    self.noNetView.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //浏览兼职接口
    [JGHTTPClient scanTheJobByjobId:self.jobId loginId:USER.login_id Success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

/**
 *  刷新cell高度
 */
-(void)refreshCellHeight:(NSNotification *)noti
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)setNavigationBar
{
    UIButton *btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"icon_fenxiang"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(ClickFenxiang:) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 20, 20);
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    self.navigationItem.rightBarButtonItem = rightBtn;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1){
        return 242;
    }else if (indexPath.section == 2){
        if (_isMore) {
            return UITableViewAutomaticDimension;
        } else {
            return 150;
        }
    }else if (indexPath.section == 3){
        
        if (self.welfareArr.count) {
            
            CGFloat height = [USERDEFAULTS floatForKey:@"collectionHeight"];
            return height;
        }else
            return 0.1;
        
    }else if (indexPath.section == 4){
        return 85;
    }else{
        return 50;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 3&&self.welfareArr.count == 0){
        return 0.1;
    }else
        return 12;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.detailModel){
        return 1;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DetailHeaderCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailHeaderCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.detailModel;
        self.moneyL = cell.moneyLabel;
        cell.peopleCountL.attributedText = self.sendCount;
        return cell;

    }else if (indexPath.section == 1){
    
        DetailsCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailsCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.detailModel;
        self.addressL = cell.addressLabel;
        self.dateL = cell.workDateLabel;
        
        return cell;

    }else if (indexPath.section == 2){
        
        WorkDetailCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"WorkDetailCell" owner:nil options:nil]lastObject];
        if (_isMore) {
            cell.workRequiredLabel.numberOfLines = 0;
            cell.workContentLabel.numberOfLines = 0;
            [cell.lookMoreBtn setTitle:@"收起" forState:UIControlStateNormal];
            [cell.lookMoreBtn setImage:[UIImage new] forState:UIControlStateNormal];
        } else {
            cell.workRequiredLabel.numberOfLines = 1;
            cell.workContentLabel.numberOfLines = 1;
            [cell.lookMoreBtn setTitle:nil forState:UIControlStateNormal];
            [cell.lookMoreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.detailModel;
        cell.delegate =self;
        return cell;

        
    }else if (indexPath.section == 3){
    
        if (self.welfareArr.count) {
            
            SelectCollectionCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectCollectionCell" owner:nil options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftL.text = @"工作福利:";
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.detailModel.limits_name] ;
            [arr addObjectsFromArray:self.detailModel.label_name];
            [arr addObjectsFromArray:self.detailModel.welfare_name];
            cell.dataArr = arr;
            return cell;

        }else
            return [[UITableViewCell alloc] init];
    }
    else if (indexPath.section == 4){
        
        BusinessCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.detailModel;
        cell.delegate = self;
        return cell;

    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = RGBCOLOR(239, 239, 247);

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
        view.backgroundColor = RGBCOLOR(239, 239, 244);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_W, 20)];
        label.font = FONT(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = LIGHTGRAYTEXT;
        label.text = @"您已经拉到最底部了哦";
        [view addSubview:label];
        [cell.contentView addSubview:view];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 4) {
//        MerChantViewController *merchantVC = [[MerChantViewController alloc] init];
//        merchantVC.model = self.merchantModel;
////        [self.navigationController pushViewController:merchantVC animated:YES];
//    }
}

/**
 *  跳到聊天页面
 */
-(void)goToChatVC:(UIButton *)btn
{
    if (![self checkExistPhoneNum]) {
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
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定咨询此条兼职?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.detailModel.user_id.integerValue == USER.login_id.integerValue) {
            [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
            return ;
        }
        LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:self.detailModel.user_id]];
        
        //    [NotificationCenter postNotificationName:kNotificationSendJobName object:self.detailModel];
//        conversationViewController.model = self.detailModel;
        [self.navigationController pushViewController:conversationViewController animated:YES];
        
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
/**
 *  收藏这条兼职
 */
-(void)collectionThePartJob:(UIButton *)btn
{
    if (![self checkExistPhoneNum]) {
    [self gotoCodeVC];
    return;
    }
//    if(self.detailModel.is_collection.intValue == 1){
//        [self showAlertViewWithText:@"您已经收藏" duration:1];
//        return;
//    };
    IMP_BLOCK_SELF(JianZhiDetailController);
    
    [JGHTTPClient attentionMercntOrColloectionParjobByJobid:self.jobId merchantId:@"0" loginId:USER.login_id Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [block_self showAlertViewWithText:@"收藏成功" duration:1];
            block_self.collectionView.image = [UIImage imageNamed:@"icon_yipingjia"];
        }
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}
/**
 *  我要报名
 */
-(void)clickTosignUp:(UIButton *)btn
{
    
//    PresentViewController *presentVC = [[PresentViewController alloc] init];
//    
//    [self presentViewController:presentVC animated:YES completion:nil];
//    
//    return;
    NSInteger sum = self.detailModel.sum.integerValue;
    if (sum<=10) {
        sum += 5;
        
    }else{
        sum = sum*1.4;
    }
    
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }else if (USER.resume.intValue == 0){
        [self showAlertViewWithText:@"请您先去完善资料" duration:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoProfileVC];
        });
        return;
    }else if (self.detailModel.count.intValue >= sum || self.detailModel.status.intValue!=1){//
        [self showAlertViewWithText:@"该兼职已报满,您可以找更好的兼职哦!" duration:1];
        return;
    }else if ((self.detailModel.limit_sex.integerValue == 0&&USER.gender.integerValue==2)||(self.detailModel.limit_sex.integerValue == 1&&USER.gender.integerValue==1)){//
        [self showAlertViewWithText:@"您的性别不符" duration:1];
        return;
    }
    SignUpView *signUpView = [SignUpView aSignUpView];
    signUpView.model = self.detailModel;
    signUpView.signupBlock = ^(){
        JGSVPROGRESSLOAD(@"正在报名");
        [JGHTTPClient signUpByloginId:USER.login_id jobId:self.jobId Success:^(id responseObject) {
            [SVProgressHUD dismiss];
            JGLog(@"%@",responseObject);
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
            if ([responseObject[@"code"] intValue]==200) {
                [btn setTitle:@"已报名" forState:UIControlStateNormal];
                [btn setBackgroundColor:LIGHTGRAYTEXT];
                btn.userInteractionEnabled = NO;
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self showAlertViewWithText:NETERROETEXT duration:1];
        }];
        
    };
    [signUpView show];
}

/**
 *  分享
 */
-(void)ClickFenxiang:(UIButton *)btn
{
    ShareView *shareView = [ShareView aShareView];
    shareView.model = self.detailModel;
    shareView.address = self.addressL.text;
    shareView.time = self.dateL.text;
    shareView.money = self.moneyL.text;
    [shareView show];
}

//去掉 UItableview headerview 黏性(sticky)//其实就是改变了悬停的位置而已
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 12; //sectionHeaderHeight
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 50, 0);
//        }
//    }
//}

/**
 *  添加底部的工具条
 */
-(void)configBottomBar
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = WHITECOLOR;
    barView.layer.shadowOpacity = 0.5;
    barView.layer.shadowOffset = CGSizeMake(0, 1);
    barView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(@(50));
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    
    //在线咨询
    UIView *bgViewChat = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W*0.4, 50)];
    [barView addSubview:bgViewChat];
    
    UIImageView *chatView = [[UIImageView alloc] initWithFrame:CGRectMake(bgViewChat.center.x-15, 5, 30, 30)];
    chatView.userInteractionEnabled = YES;
    chatView.image = [UIImage imageNamed:@"icon_liaotian"];
    [bgViewChat addSubview:chatView];
    
    UILabel *labelChat = [[UILabel alloc] initWithFrame:CGRectMake(0, chatView.bottom, bgViewChat.width, 15)];
    labelChat.text = @"在线咨询";
    labelChat.textAlignment = NSTextAlignmentCenter;
    labelChat.font = FONT(12);
    [bgViewChat addSubview:labelChat];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = bgViewChat.bounds;
    [chatBtn addTarget:self action:@selector(goToChatVC:) forControlEvents:UIControlEventTouchUpInside];
    [bgViewChat addSubview:chatBtn];
    
    /*
    //收藏
    UIView *bgViewCol = [[UIView alloc] initWithFrame:CGRectMake(bgViewChat.right, 0, SCREEN_W*0.2, 50)];
    [barView addSubview:bgViewCol];
    
    UIImageView *collectionView = [[UIImageView alloc] initWithFrame:CGRectMake(bgViewChat.center.x-15, 5, 30, 30)];
    collectionView.userInteractionEnabled = YES;
    collectionView.image = [UIImage imageNamed:@"icon_scang"];
    [bgViewCol addSubview:collectionView];
    self.collectionView = collectionView;
    
    UILabel *labelCollectin = [[UILabel alloc] initWithFrame:CGRectMake(0, collectionView.bottom, bgViewCol.width, 15)];
    labelCollectin.text = @"收藏";
    labelCollectin.textAlignment = NSTextAlignmentCenter;
    labelCollectin.font = FONT(12);
    [bgViewCol addSubview:labelCollectin];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = bgViewCol.bounds;
    [collectBtn addTarget:self action:@selector(collectionThePartJob:) forControlEvents:UIControlEventTouchUpInside];
    [bgViewCol addSubview:collectBtn];
    */
    //我要报名
    signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.frame = CGRectMake(bgViewChat.right, 0, SCREEN_W*0.6, 50);
    NSString *titleStr;
    if (self.detailModel.status.intValue == 0) {
        titleStr = @"我要报名";
        [signUpBtn setBackgroundColor:GreenColor];
    }else{
        titleStr = @"已过期";
        signUpBtn.backgroundColor = LIGHTGRAYTEXT;
        signUpBtn.userInteractionEnabled = NO;
    }
    [signUpBtn setTitle:titleStr forState:UIControlStateNormal];
    [signUpBtn addTarget:self action:@selector(clickTosignUp:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:signUpBtn];
}
/**
 *  查看更多
 */
-(void)clickMoreBtn:(UIButton *)btn content:(UILabel *)contentL require:(UILabel *)requireL
{
    _isMore = !_isMore;
    
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)callPhoneNum:(NSString *)phoneNo
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"联系商家" message:phoneNo preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [APPLICATION openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNo]]];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [APPLICATION.keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

/**
 *  去登录
 */
-(void)gotoCodeVC
{
    LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:@"contentSizeChanged" object:nil];
}

@end
