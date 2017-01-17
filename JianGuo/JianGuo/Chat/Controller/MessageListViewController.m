//
//  MessageListViewController.m
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MessageListViewController.h"
#import "ChatMsgViewController.h"
#import <AVOSCloudIM.h>
#import "ChatListCell.h"
#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"
#import "ChatNoticeOrMetionView.h"
#import <WZLBadgeImport.h>

@interface MessageListViewController ()<UITableViewDataSource,AVIMClientDelegate,UITableViewDelegate,NotiAndMetionDelegate>
{
    BOOL isfirstAppear;
    int convCount;
}

@property (nonatomic,strong) AVIMClient *client;
@property (nonatomic,strong) AVIMConversation *conversation;
@property (nonatomic,strong) NSMutableArray *iconArr;
@property (nonatomic,strong) NSMutableArray *conversationArr;
@property (nonatomic,strong) NSMutableArray *lastMessageArr;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MessageListViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        _tableView.delegate =self;
        _tableView.rowHeight = 57;
        _tableView.dataSource = self;
        ChatNoticeOrMetionView *notiOrMetnView = [ChatNoticeOrMetionView aNoticeOrMetionView];
        notiOrMetnView.delegate = self;
        _tableView.tableHeaderView = notiOrMetnView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}


-(NSMutableArray *)iconArr
{
    if (!_iconArr) {
        _iconArr = [NSMutableArray array];
    }
    return _iconArr;
}

-(NSMutableArray *)conversationArr
{
    if (!_conversationArr) {
        _conversationArr = [NSMutableArray array];
    }
    return _conversationArr;
}

-(NSMutableArray *)lastMessageArr
{
    if (!_lastMessageArr) {
        _lastMessageArr = [NSMutableArray array];
    }
    return _lastMessageArr;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        [NotificationCenter addObserver:self selector:@selector(receiveMessage:) name:kNotificationDidReceiveMessage object:nil];
        [NotificationCenter addObserver:self selector:@selector(logout) name:kNotificationLogoutSuccessed object:nil];
        [NotificationCenter addObserver:self selector:@selector(login) name:kNotificationLoginSuccessed object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        [self.view addSubview:self.tableView];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([self checkExistPhoneNum]) {
            [self getLastConversitions];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
        
    }];
}

-(void)logout
{
    [self.lastMessageArr removeAllObjects];
    [self.tableView reloadData];
}
-(void)login
{
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarItem clearBadge];
    if (!isfirstAppear) {
        if ([self checkExistPhoneNum]) {
            [self getLastConversitions];
            isfirstAppear = YES;
            [self showAlertViewWithText:@"下拉可以刷新聊天列表" duration:1];
        }
    }
       
}

/**
 *  收到消息的通知
 */
-(void)receiveMessage:(NSNotification *)noti
{
    if (self.tabBarController.selectedIndex!=2) {
//        [self.tabBarItem setBadgeValue:@""];
        self.tabBarItem.badgeCenterOffset = CGPointMake(-SCREEN_W/8+12, 8);
        [self.tabBarItem showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeScale];
    }
    AVIMTextMessage *message = noti.object;
    BOOL isNewConversation = NO;
    for (AVIMConversation *conversation in self.conversationArr) {
        if ([conversation.conversationId isEqualToString:message.conversationId]) {
            isNewConversation = YES;//如果是新对话,这个值为 NO
        }
    }
    if (!isNewConversation) {//一个新对话的消息
        [self getLastConversitions];
    } else {
        for (int i=0;i<self.conversationArr.count;i++) {
            AVIMConversation *conversation = [self.conversationArr objectAtIndex:i];
            if ([conversation.conversationId isEqualToString:message.conversationId]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                ChatListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.redView.hidden = NO;
            }
        }

    }
    
}

#pragma 查询最近对话列表
- (void)getLastConversitions{
    
    if (self.conversationArr.count) {
        [self.conversationArr removeAllObjects];
    }
    
    //用 self.client 创建一个 query 来查询最近的 对话列表
    AVIMConversationQuery *query = [[[JGIMClient shareJgIm] getAclient] conversationQuery];
    // Tom 设置查询最近 20 个活跃对话
    query.limit = 100;
    [query whereKey:kAVIMKeyMember containedIn:@[[NSString stringWithFormat:@"%@",USER.login_id]]];//查询 有自己参与的 对话 数组
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        JGLog(@"查询成功！");
        convCount = (int)objects.count;
        [self.tableView.mj_header endRefreshing];
        if (self.lastMessageArr.count) {
            [self.lastMessageArr removeAllObjects];
        }
        [self.conversationArr addObjectsFromArray:objects];
        
        [self.tableView reloadData];
        
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversationArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CHATLIST"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatListCell" owner:nil options:nil]lastObject];
        
    }
    JGLog(@"%ld",indexPath.row);

    AVIMConversation *conversation = self.conversationArr[indexPath.row];
    
    [conversation queryMessagesFromServerWithLimit:1 callback:^(NSArray *objects, NSError *error) {
        if (objects.count) {
            
            AVIMTypedMessage *message = [objects firstObject];
            if (![message isKindOfClass:[AVIMTextMessage class]]) {
                message.text = @"此版本暂不支持这类消息";
            }else{
                cell.lastMessageLabel.text = message.text;
            }

            cell.timeLabel.text = [DateOrTimeTool compareDate:[[NSString stringWithFormat:@"%lld",message.sendTimestamp] substringToIndex:10]];
        }else{
            cell.timeLabel.text = [[NSString stringWithFormat:@"%@",conversation.createAt] substringWithRange:NSMakeRange(5, 5)];
        }
    }];
    
    cell.nickNameLabel.text = [conversation.attributes objectForKey:@"othername"];
    
    [cell.leftIcon sd_setImageWithURL:[NSURL URLWithString:conversation.attributes[@"otherimg"]] placeholderImage:[UIImage imageNamed:@"icon_touxiang"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tabBarItem setBadgeValue:nil];
    ChatListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChatMsgViewController *chatVC = [[ChatMsgViewController alloc] init];
    chatVC.sendMessageBlock = ^(NSString *message){
        
        cell.lastMessageLabel.text = message;
        
    };
    cell.redView.hidden = YES;
    chatVC.conversation = self.conversationArr[indexPath.row];
    chatVC.title = chatVC.conversation.attributes[@"othername"];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/**
 *  点击通知消息
 */
-(void)clickNotice:(UIButton *)btn
{
    [self showAlertViewWithText:@"您还没有通知消息" duration:1];
}
/**
 *  点击提醒消息
 */
-(void)clickMetion:(UIButton *)btn
{
    [self showAlertViewWithText:@"您还没有提醒消息" duration:1];
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationDidReceiveMessage object:nil];
    [NotificationCenter removeObserver:self name:kNotificationLoginSuccessed object:nil];
    [NotificationCenter removeObserver:self name:kNotificationLogoutSuccessed object:nil];
}

@end
