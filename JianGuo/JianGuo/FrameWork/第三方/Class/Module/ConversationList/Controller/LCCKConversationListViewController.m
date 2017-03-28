//
//  LCCKConversationListViewController.m
//  LeanCloudChatKit-iOS
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/2/22.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "LCCKConversationListViewController.h"
#import "LCCKConstants.h"
#import "LCCKSessionService.h"
#import "LCCKConversationService.h"
#import "LCCKConversationListViewModel.h"
#import "LoginNew2ViewController.h"

#if __has_include(<MJRefresh/MJRefresh.h>)
    #import <MJRefresh/MJRefresh.h>
#else
    #import "MJRefresh.h"
#endif

@interface LCCKConversationListViewController ()
{
    UIView *bgView;
}

@property (nonatomic, strong) NSMutableArray *conversations;
@property (nonatomic, copy) LCCKConversationListViewModel *conversationListViewModel;
@property (nonatomic,strong) UIButton *loginBtn;

@end

@implementation LCCKConversationListViewController

#pragma mark -
#pragma mark - UIViewController Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NotificationCenter addObserver:self selector:@selector(login) name:kNotificationOpenClientSuccessed object:nil];
    [NotificationCenter addObserver:self selector:@selector(logout) name:kNotificationCloseClientSuccessed object:nil];
    
    BOOL clientStatusOpened = [LCCKSessionService sharedInstance].client.status == AVIMClientStatusOpened;
    //NSAssert([LCCKSessionService sharedInstance].client.status == AVIMClientStatusOpened, @"client not opened");
    if (!clientStatusOpened) {
        [[LCCKSessionService sharedInstance] reconnectForViewController:self callback:nil];
        UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        alertView.backgroundColor = RedColor;
        alertView.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
        [self.view addSubview:alertView];
    }
    self.navigationItem.title = @"消息";
    self.tableView.delegate = self.conversationListViewModel;
    self.tableView.dataSource = self.conversationListViewModel;
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个 block
            [weakSelf.conversationListViewModel refresh];
            // 设置颜色
        }];
        header.stateLabel.textColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"TableView-PullRefresh-TextColor"];
        header.lastUpdatedTimeLabel.textColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"TableView-PullRefresh-TextColor"];
        header.backgroundColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"TableView-PullRefresh-BackgroundColor"];
        header;
    });
    self.tableView.backgroundColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"TableView-BackgroundColor"];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    !self.viewDidLoadBlock ?: self.viewDidLoadBlock(self);
    
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, 80, 40);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.center = CGPointMake(SCREEN_W/2, SCREEN_H/2-50);
    [loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:GreenColor];
    [loginBtn addTarget:self action:@selector(gotoLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [self.view bringSubviewToFront:loginBtn];
    
//    [self showANopartJobView];
}

-(void)logout
{
    
    [self.tableView.mj_header beginRefreshing];
    
    BOOL clientStatusOpened = [LCCKSessionService sharedInstance].client.status == AVIMClientStatusOpened;
    //NSAssert([LCCKSessionService sharedInstance].client.status == AVIMClientStatusOpened, @"client not opened");
    
    if (!clientStatusOpened) {
        
        self.loginBtn.hidden = NO;
        
    }else{
        
        self.loginBtn.hidden = YES;
        if (self.conversations.count == 0) {//显示无聊天数据视图
            
            bgView.hidden = NO;
            
        }else{//隐藏无聊天数据视图
            
            bgView.hidden = YES;
            
        }
        
    }
}

-(void)login
{
    [self.tableView.mj_header beginRefreshing];
    
    BOOL clientStatusOpened = [LCCKSessionService sharedInstance].client.status == AVIMClientStatusOpened;
    //NSAssert([LCCKSessionService sharedInstance].client.status == AVIMClientStatusOpened, @"client not opened");
    
    if (!clientStatusOpened) {
        
        self.loginBtn.hidden = NO;
        
    }else{
        
        self.loginBtn.hidden = YES;
        if (self.conversations.count == 0) {//显示无聊天数据视图
            
            bgView.hidden = NO;
            
        }else{//隐藏无聊天数据视图
            
            bgView.hidden = YES;
            
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    !self.viewWillAppearBlock ?: self.viewWillAppearBlock(self, animated);
    JGLog(@"viewWillAppear –––> %@",_conversations);
    JGLog(@"viewWillAppear –––> %@",self.conversationListViewModel.dataArray);
    BOOL clientStatusOpened = [LCCKSessionService sharedInstance].client.status == AVIMClientStatusOpened;
    //NSAssert([LCCKSessionService sharedInstance].client.status == AVIMClientStatusOpened, @"client not opened");
    
    if (!clientStatusOpened) {
        
        self.loginBtn.hidden = NO;
        
    }else{
        
        self.loginBtn.hidden = YES;
        if (self.conversationListViewModel.dataArray.count == 0) {//显示无聊天数据视图
            
            bgView.hidden = NO;
            
        }else{//隐藏无聊天数据视图
            
            bgView.hidden = YES;
            
        }
        
    }
}


/**
 *  显示无数据图片
 */
-(void)showANopartJobView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_W, 250)];
    bgView.center = CGPointMake(SCREEN_W/2, self.tableView.height/2);
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.center.x-60, 0, 120, 100)];
    imgView.image = [UIImage imageNamed:@"defaultpicture"];
    [bgView addSubview:imgView];
    
    UILabel *labelMiddle = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+5, SCREEN_W, 25)];
    labelMiddle.text = @"还没有任何聊天数据哦!";
    labelMiddle.font = FONT(16);
    labelMiddle.textColor = LIGHTGRAYTEXT;
    labelMiddle.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:labelMiddle];
    
    [self.view addSubview:bgView];
    bgView.hidden = YES;
}

-(void)gotoLoginVC
{
    LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    !self.viewDidAppearBlock ?: self.viewDidAppearBlock(self, animated);
    JGLog(@"viewDidAppear –––> %@",_conversations);
    JGLog(@"viewDidAppear –––> %@",self.conversationListViewModel.dataArray);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    !self.viewWillDisappearBlock ?: self.viewWillDisappearBlock(self, animated);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    !self.viewDidDisappearBlock ?: self.viewDidDisappearBlock(self, animated);
}

- (void)dealloc {
    !self.viewControllerWillDeallocBlock ?: self.viewControllerWillDeallocBlock(self);
    [NotificationCenter removeObserver:self name:kNotificationOpenClientSuccessed object:nil];
    [NotificationCenter removeObserver:self name:kNotificationCloseClientSuccessed object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    !self.didReceiveMemoryWarningBlock ?: self.didReceiveMemoryWarningBlock(self);
}

#pragma mark -
#pragma mark - LazyLoad Method

/**
 *  lazy load conversations
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)conversations
{
    if (_conversations == nil) {
        _conversations = [[NSMutableArray alloc] init];
    }
    return _conversations;
}

/**
 *  lazy load conversationListViewModel
 *
 *  @return LCCKconversationListViewModel
 */
- (LCCKConversationListViewModel *)conversationListViewModel {
    if (_conversationListViewModel == nil) {
        LCCKConversationListViewModel *conversationListViewModel = [[LCCKConversationListViewModel alloc] initWithConversationListViewController:self];
        _conversationListViewModel = conversationListViewModel;
    }
    return _conversationListViewModel;
}

- (void)updateStatusView {
    if (!self.shouldCheckSessionStatus) {
        return;
    }
    BOOL isConnected = [LCCKSessionService sharedInstance].connect;
    if (isConnected) {
        self.tableView.tableHeaderView = nil ;
    } else {
        self.tableView.tableHeaderView = (UIView *)self.clientStatusView;
    }
}

- (void)refresh {
    [self.conversationListViewModel refresh];
}


@end
