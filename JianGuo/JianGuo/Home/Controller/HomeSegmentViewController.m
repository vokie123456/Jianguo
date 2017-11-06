//
//  HomeSegmentViewController.m
//  JianGuo
//
//  Created by apple on 17/7/24.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "HomeSegmentViewController.h"
#import "SearchDemandsViewController.h"
#import "DemandListViewController.h"
#import "SkillViewController.h"
#import "PostSkillViewController.h"
#import "PostDemandNewViewController.h"

#import "PostDemandNewViewController.h"
#import "SearchDemandsViewController.h"
#import "DemandDetailNewViewController.h"
#import "WebViewController.h"

#import "SkillsDetailViewController.h"
#import "MySkillDetailViewController.h"
#import "MyBuySkillDetailViewController.h"
#import "DemandDetailNewViewController.h"
#import "SignDemandViewController.h"
#import "JianZhiDetailController.h"
#import "MyWalletNewViewController.h"
#import "RealNameNewViewController.h"
#import "MyPartJobViewController.h"
#import "MySignDetailViewController.h"
#import "MyPostDetailViewController.h"
#import "RemindMsgViewController.h"
#import "BillsViewController.h"
#import "MineChatViewController.h"

#import "JGHTTPClient+Skill.h"
#import "UIButton+AFNetworking.h"

#import "DismissingAnimator.h"
#import "PresentingAnimator.h"
#import "ZJScrollPageView.h"
#import "BHBPopView.h"

@interface Advertisement : NSObject

/** 跳转类型（1网址跳转，2兼职，3任务跳转，4技能跳转） */
@property (nonatomic, assign) NSInteger  skipType;

/** 跳转地址(包含网址，任务id，技能id） */
@property (nonatomic, copy) NSString* skipLocation;

/** 广告标题 */
@property (nonatomic, copy) NSString* title;

/** 广告图片 */
@property (nonatomic, copy) NSString* imageUrl;

/** 广告内容 */
@property (nonatomic, copy) NSString* content;

@end

@implementation Advertisement

@end

static CGFloat buttonWidth = 60;

@interface HomeSegmentViewController () <ZJScrollPageViewDelegate>

/** 标题数组 */
@property (nonatomic,copy) NSArray *titles;

/** 弹出界面 */
@property (nonatomic,strong) UIView *backGroundView;

/** 取消按钮 */
@property (nonatomic,strong) UIButton *cancelB;

/** segmentView */
@property (nonatomic,strong) ZJScrollSegmentView *segmentView;
/** contentView */
@property (nonatomic,strong) ZJContentView *contentView;

@end

@implementation HomeSegmentViewController
{
    UIView *bigView;
    Advertisement *ad;
    __weak IBOutlet UIButton *postB;
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [NotificationCenter addObserver:self selector:@selector(clickNotification:) name:kNotificationClickNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSegmentView];
    
    [self setNavigationBar];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"needGuide"]) {
        
        [self addGuidePictures];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"needGuide"]) {
            
            [self showADView];
            
        }
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self handleRemoteNotifcation];
}

-(void)clickNotification:(NSNotification *)noti//点击通知进入应用
{
    NSDictionary *userInfo = noti.object;
    [self fromNotiToMyjobVC:userInfo];
}

//MARK : - 添加气泡引导图
-(void)addGuidePictures
{
    
    
    imageView1 = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen] .bounds];
    imageView1.image = [UIImage imageNamed:@"jiahao750"];
    imageView1.userInteractionEnabled = YES;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, SCREEN_H*809/1336, SCREEN_W/2, 200);
    [btn1 addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 1000;
    [imageView1 addSubview:btn1];
    [APPLICATION.delegate.window addSubview:imageView1];
    
    imageView2 = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen] .bounds];
    imageView2.image = [UIImage imageNamed:@"jineng750"];
    imageView2.userInteractionEnabled = YES;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(SCREEN_W/2, SCREEN_H*547/1336, SCREEN_W/2, 200);
    [btn2 addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 1001;
    
    [imageView2 addSubview:btn2];
    
    [APPLICATION.delegate.window addSubview:imageView2];
    
    imageView3 = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen] .bounds];
    imageView3.image = [UIImage imageNamed:@"renwu750"];
    imageView3.userInteractionEnabled = YES;
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, SCREEN_H*553/1336, SCREEN_W/2, 200);
    [btn3 addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 1002;
    
    [imageView3 addSubview:btn3];
    
    [APPLICATION.delegate.window addSubview:imageView3];
    
    
}

-(void)clickToRemove:(UIButton *)sender
{
    if (sender.tag == 1000) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"needGuide"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [imageView1 removeFromSuperview];
    }else if (sender.tag == 1001){
        [imageView2 removeFromSuperview];
    }else if (sender.tag == 1002){
        [imageView3 removeFromSuperview];
    }
}


-(void)setNavigationBar
{
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btnLocation setTitle:[CityModel city].cityName forState:UIControlStateNormal];
    [btnLocation setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    btnLocation.titleLabel.font = FONT(14);
    [btnLocation addTarget:self action:@selector(selectCitySChool:) forControlEvents:UIControlEventTouchUpInside];
    btnLocation.frame = CGRectMake(0, 0, 20, 20);
    
    //    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    UIBarButtonItem *bbtLocation = [[UIBarButtonItem alloc] initWithCustomView:btnLocation];
    self.navigationItem.rightBarButtonItems = @[bbtLocation];
}


-(void)selectCitySChool:(UIButton *)btn
{
    SearchDemandsViewController *searchVC = [[SearchDemandsViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)setSegmentView
{
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    // 缩放标题
//    style.scaleTitle = YES;
//    style.titleBigScale = 2;
    // 颜色渐变
    style.normalTitleColor = LIGHTGRAYTEXT;
    style.gradualChangeTitleColor = YES;
    // 设置附加按钮的背景图片
    style.titleFont = [UIFont systemFontOfSize:17];
    style.scrollTitle = NO;
    style.showLine = YES;
    style.selectedTitleColor = GreenColor;
    style.scrollLineColor = GreenColor;
    
    self.titles = @[@"任务",
                    @"技能"
                    ];
    
    IMP_BLOCK_SELF(HomeSegmentViewController);
    self.segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, 100, 40) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
        
        [block_self.contentView setContentOffSet:CGPointMake(SCREEN_W*index, 0) animated:YES];
        
    }];
    
    self.navigationItem.titleView = self.segmentView;
    
    self.contentView = [[ZJContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49) segmentView:self.segmentView parentViewController:self delegate:self];
    [self.view addSubview:self.contentView];
    
    [self.view bringSubviewToFront:postB];
}

#pragma ZJScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //    NSLog(@"%ld---------", index);
    
    
    if (!childVc) {
        if (index == 0) {
            
            DemandListViewController *demandListVC = [[DemandListViewController alloc] init];
            childVc = demandListVC;
        }else if (index == 1){
            
            SkillViewController *demandListVC = [[SkillViewController alloc] init];
            childVc = demandListVC;
        }
        
        childVc.title = self.titles[index];
    }
    
    return childVc;
}
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    PresentingAnimator *animator = [PresentingAnimator new];
    
    animator.scale=1.3;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

#pragma mark 推送相关逻辑
/**
 *  处理远程推送的跳转逻辑
 */
-(void)handleRemoteNotifcation
{
    NSDictionary *userInfo = [USERDEFAULTS objectForKey:@"push"];
    if (userInfo) {
        
        NSDictionary *userInfo = [USERDEFAULTS objectForKey:@"push"];
        if (userInfo) {
            
            NSArray *array = [[userInfo objectForKey:@"aps"] allKeys];
            if ([array containsObject:@"type"]||[[userInfo allKeys] containsObject:@"type"]) {
                
                [self fromNotiToMyjobVC:userInfo];
                
            }else{
                UITabBarController *tabVc = (UITabBarController *)APPLICATION.keyWindow.rootViewController;
                [tabVc setSelectedIndex:3];
                
            }
            
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"push"];
        
    }
}

-(void)fromNotiToMyjobVC:(NSDictionary *)userInfo
{
    int intType = [userInfo[@"type"] intValue];
    UIViewController *VC;
    switch (intType) {
        case 4:
        case 1:{//报名推送
            
            VC = [[MyPartJobViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 2:
        case 3:{//主页推送,留在主页就行,不用额外操作
            
            
            JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
            
            jzdetailVC.hidesBottomBarWhenPushed = YES;
            
            jzdetailVC.jobId = userInfo[@"job_id"];
            
            [self.navigationController pushViewController:jzdetailVC animated:YES];
            
            break;
            
            break;
        }
        case 5:{//钱包推送
            
            VC = [[MyWalletNewViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 7:
        case 6:{//实名推送
            
            VC = [[RealNameNewViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 8:{//收到了果聊消息 –––> 果聊联系人页面
            
            [self.tabBarController setSelectedIndex:1];
            
            break;
        }
        case 9:{//报名了外露的兼职(主要是发短信的形式) –––>不做处理
            
            break;
        }
        case 10:{//发布的任务收到了新报名(–––>我发布的报名列表)
            
            SignDemandViewController *signVC = [SignDemandViewController new];
            signVC.demandId = userInfo[@"jobid"];
            signVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signVC animated:YES];
            
            break;
        }
            // ***  报名的需求  ***
        case 14://被投诉,收到投诉处理结果(––––>任务详情页面)
        case 13://被雇主投诉(––––>任务详情页面)
        case 16://报名的需求被录用(––––>任务详情页面)
        case 17:{//报名的需求被拒绝(–––>我发布的报名列表)
            MySignDetailViewController *detailVC = [[MySignDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 15:{//任务服务费用到账(–––>钱包明细,收入明细)
            
            BillsViewController *billVC = [[BillsViewController alloc] init];
            billVC.hidesBottomBarWhenPushed = YES;
            billVC.type = @"1";
            billVC.navigationItem.title = @"收入明细";
            [self.navigationController pushViewController:billVC animated:YES];
            break;
        }
            // ***  发布的需求  ***
        case 11://发布的任务未通过审核
        case 12://发布需求,投诉了服务者,收到了投诉处理结果
        case 18:{//发布的需求收到了新评论(–––>也是任务详情页)
            MyPostDetailViewController *detailVC = [[MyPostDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 19:{//收到了评论,去普通的需求详情页
            DemandDetailNewViewController *detailVC = [[DemandDetailNewViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = userInfo[@"jobid"];
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 23:{//自定义推送
            
            RemindMsgViewController *msgVC = [[RemindMsgViewController alloc] init];
            
            msgVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:msgVC animated:YES];
            
            break;
            
        }
        case 24:{//活动推送(H5)
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = userInfo[@"html_url"];
            
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        case 25:{//评价推送(H5)
            
            MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
            mineChatVC.hidesBottomBarWhenPushed = YES;
            mineChatVC.userId = [NSString stringWithFormat:@"%@",USER.login_id];
            [self.navigationController pushViewController:mineChatVC animated:YES];
            break;
        }
        case 30:{//技能详情
            
            SkillsDetailViewController *skillDetailVC = [[SkillsDetailViewController alloc] init];
            skillDetailVC.hidesBottomBarWhenPushed = YES;
            skillDetailVC.skillId = userInfo[@"jobid"];
            [self.navigationController pushViewController:skillDetailVC animated:YES];
            break;
        }
        case 31:{//我发布的技能的详情
            
            MySkillDetailViewController *mySkillVC = [[MySkillDetailViewController alloc] init];
            mySkillVC.hidesBottomBarWhenPushed = YES;
            mySkillVC.orderNo =  userInfo[@"jobid"];
            [self.navigationController pushViewController:mySkillVC animated:YES];
            break;
        }
        case 32:{//我购买的技能的详情
            
            MyBuySkillDetailViewController *myBuySkillVC = [[MyBuySkillDetailViewController alloc] init];
            myBuySkillVC.hidesBottomBarWhenPushed = YES;
            myBuySkillVC.orderNo = userInfo[@"jobid"];
            [self.navigationController pushViewController:myBuySkillVC animated:YES];
            break;
        }
            
            
            
        case 100:{//活动推送(H5)
            
            break;
        }
    }
}


-(void)showADView
{
    
    [JGHTTPClient getAdvertisementSuccess:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                return ;
            }
            
            ad = [Advertisement mj_objectWithKeyValues:responseObject[@"data"]];
            
            bigView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            bigView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            
            UIButton *adButton = [UIButton buttonWithType:UIButtonTypeCustom];
            adButton.center = APPLICATION.keyWindow.center;
            
            [adButton addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *closeB = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeB addTarget:self action:@selector(adViewDismiss) forControlEvents:UIControlEventTouchUpInside];
            closeB.frame = CGRectMake(SCREEN_W/2-10, adButton.bottom-80, 20, 20);
            [closeB setBackgroundImage:[UIImage imageNamed:@"bigcha"] forState:UIControlStateNormal];
            [bigView addSubview:closeB];
            
            [bigView addSubview:adButton];
            
            [APPLICATION.keyWindow addSubview:bigView];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:responseObject[@"data"][@"imageUrl"]]];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            
            __weak UIButton *weakB = adButton;
            [adButton setBackgroundImageForState:UIControlStateNormal withURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholderPic"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                
                CGFloat width = [UIScreen mainScreen].bounds.size.width-120;
                CGFloat height = width*image.size.height/image.size.width;
                CGPoint point = weakB.frame.origin;
                CGSize size = CGSizeMake(width, height);
                
                CGRect frame = {point,size};
                
                [weakB setBackgroundImage:image forState:UIControlStateNormal];
                
                [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    
                    weakB.frame = frame;
                    
                    weakB.center = APPLICATION.keyWindow.center;
                    
                    bigView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                    
                    
                    closeB.frame = CGRectMake(SCREEN_W/2-10, weakB.bottom+20, 20, 20);
                } completion:^(BOOL finished) {
                    
                }];
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)jump
{
    
    [self adViewDismiss];
    if (ad.skipType == 1) {//网址跳转
        
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.url = ad.skipLocation;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else if (ad.skipType == 2){//兼职
        
        JianZhiDetailController *detailVC = [[JianZhiDetailController alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.jobId = ad.skipLocation;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if (ad.skipType == 3){//任务跳转
        
        DemandDetailNewViewController *detailVC = [[DemandDetailNewViewController alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.demandId = ad.skipLocation;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if (ad.skipType == 4){//技能跳转
        
        SkillsDetailViewController *detailVC = [[SkillsDetailViewController alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.skillId = ad.skipLocation;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}

-(void)adViewDismiss
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        bigView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [bigView removeFromSuperview];
    }];
}
- (IBAction)post:(id)sender {
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backGroundView.backgroundColor = [WHITECOLOR colorWithAlphaComponent:0];
    self.backGroundView = backGroundView;
    
    [APPLICATION.delegate.window addSubview:backGroundView];
    
    
    UIButton *cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelB.frame = CGRectMake(SCREEN_W/2-35/2, SCREEN_H-80, 35, 35);
    [cancelB setBackgroundImage:[UIImage imageNamed:@"bexit"] forState:UIControlStateNormal];
    [cancelB addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    cancelB.alpha = 0;
    [backGroundView addSubview:cancelB];
    self.cancelB = cancelB;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        cancelB.alpha = 1;
        backGroundView.backgroundColor = [WHITECOLOR colorWithAlphaComponent:0.9];
        
    }];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/2-buttonWidth/2, SCREEN_H-buttonWidth, buttonWidth, 120)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    
    UIButton *skillB = [UIButton buttonWithType:UIButtonTypeCustom];
    skillB.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    skillB.tag = 100;
    [skillB setBackgroundImage:[UIImage imageNamed:@"fabuxuqiu"] forState:UIControlStateNormal];
    [skillB addTarget:self action:@selector(postSKillOrDemand:) forControlEvents:UIControlEventTouchUpInside];
//    skillB.alpha = 0;
    [leftView addSubview:skillB];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((-80+skillB.width)/2, skillB.bottom+10, 80, 20)];
    label.text = @"发布任务";
    label.textAlignment = NSTextAlignmentCenter;
    [leftView addSubview:label];
    
    [backGroundView addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/2-buttonWidth/2, SCREEN_H-buttonWidth, buttonWidth, 120)];
    rightView.backgroundColor = [UIColor clearColor];
    rightView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    
    UIButton *demandB = [UIButton buttonWithType:UIButtonTypeCustom];
    demandB.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    demandB.tag = 200;
    [demandB setBackgroundImage:[UIImage imageNamed:@"fabujineng"] forState:UIControlStateNormal];
    [demandB addTarget:self action:@selector(postSKillOrDemand:) forControlEvents:UIControlEventTouchUpInside];
    //    skillB.alpha = 0;
    [rightView addSubview:demandB];
    
    UILabel *labelDemand = [[UILabel alloc] initWithFrame:CGRectMake((-80+demandB.width)/2, demandB.bottom+10, 80, 20)];
    labelDemand.text = @"发布技能";
    labelDemand.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:labelDemand];
    
    [backGroundView addSubview:rightView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        leftView.center = CGPointMake(80+leftView.width/2, leftView.center.y-200);
        leftView.transform = CGAffineTransformMakeScale(1, 1);
        
        rightView.center = CGPointMake(SCREEN_W-(80+rightView.width/2), rightView.center.y-200);
        rightView.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
//    UIBezierPath *leftPath = [UIBezierPath bezierPath];
//    [leftPath moveToPoint:skillB.center];
//
//    CGPoint point =CGPointMake(SCREEN_W/2, skillB.center.y-100);
//    [leftPath addLineToPoint:point];
//
//    CGPoint leftPoint =CGPointMake(80, point.y);
//    [leftPath addLineToPoint:leftPoint];
//
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animation.path = leftPath.CGPath;
//    animation.duration = 1;
//    animation.repeatCount = 1;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//
//    [skillB.layer addAnimation:animation forKey:nil];
}

-(void)postSKillOrDemand:(UIButton *)sender
{
    [self cancel:self.cancelB];
    if (sender.tag == 200) {//技能
        
        if (![self checkExistPhoneNum]) {
            [self gotoCodeVC];
            return;
        }
        if (USER.status.intValue == 1){
            [self showAlertViewWithText:@"请您先去实名认证" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                RealNameNewViewController *realNameVC = [[RealNameNewViewController alloc] init];
                realNameVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:realNameVC animated:YES];
            });
            return;
        }
        PostSkillViewController *postSkillVC = [[PostSkillViewController alloc] init];
        postSkillVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postSkillVC animated:YES];
        
    }else if (sender.tag == 100){//需求
        
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
        
        //添加popview
        [BHBPopView showToView:self.view.window andImages:@[@"study-1",@"run",@"technology-1",@"amusement",@"emotion-1",@"shopping"] andTitles:@[@"学习交流",@"跑腿代劳",@"技能服务",@"娱乐生活",@"情感地带",@"易货求购"] andSelectBlock:^(BHBItem *item) {
            
            PostDemandNewViewController *postDemandVC = [[PostDemandNewViewController alloc] init];
            postDemandVC.demandType = [NSString stringWithFormat:@"%ld",item.index.integerValue+1];
            postDemandVC.demandTypeStr = item.title;
            postDemandVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:postDemandVC animated:YES];
            
        }];
        
    }
}

-(void)cancel:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        
        sender.alpha = 0;
        self.backGroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.backGroundView removeFromSuperview];
        
    }];
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationClickNotification object:nil];
}

@end
