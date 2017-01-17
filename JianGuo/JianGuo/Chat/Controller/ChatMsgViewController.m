//
//  ChatMsgViewController.m
//  JianGuo
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "ChatMsgViewController.h"
#import "ChatCell.h"
#import "DateOrTimeTool.h"
#import "UIImageView+WebCache.h"
#import "BCKeyBoard.h"


//#define USER [JGUser user]

@interface ChatMsgViewController ()<UITableViewDataSource,AVIMClientDelegate,UITableViewDelegate,UITextFieldDelegate,BCKeyBoardDelegate,UIScrollViewDelegate>
{

    NSMutableArray* _dataArray;
    UIView* _chatView;
    BOOL isKeyboardDisappear;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) AVIMClient *client;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) NSMutableArray *messageArr;
@property (nonatomic,strong) AVIMTypedMessage *lastMessage;//每次获取到的一组消息中的最早的那一条

@end

@implementation ChatMsgViewController

-(NSMutableArray *)messageArr
{
    if (!_messageArr) {
        _messageArr = [[NSMutableArray alloc] init];
    }
    return _messageArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-40)];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [NotificationCenter addObserver:self selector:@selector(receiveMessage:) name:kNotificationDidReceiveMessage object:nil];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getMoreMessageFromServerByMessageId];
        
    }];
    
    [self customUI];
    
    [self getMessagesFromServer];
    
}
//获取一个对话的 最近 消息数组
-(void)getMessagesFromServer
{
    [self.conversation queryMessagesFromServerWithLimit:20 callback:^(NSArray *objects, NSError *error) {
        
        if (objects.count) {
            
            // 将更早的消息记录插入到 Tabel View 的顶部
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,[objects count])];
            [self.messageArr insertObjects:objects atIndexes:indexes];
            [self.tableView reloadData];
            self.lastMessage = [objects objectAtIndex:0];
            
            //滚动到最后一行
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
    }];
}
/**
 *  获取当前对话 某条消息之前的消息 ,即历史消息
 */
-(void)getMoreMessageFromServerByMessageId
{
    [self.conversation queryMessagesBeforeId:self.lastMessage.messageId timestamp:self.lastMessage.sendTimestamp limit:20 callback:^(NSArray *objects, NSError *error) {
        
        
        [self.tableView.mj_header endRefreshing];//结束下拉刷新
        
        if (objects.count == 0) {
            [self showAlertViewWithText:@"没有更多消息记录" duration:1];
            return ;
        }

        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                               NSMakeRange(0,[objects count])];
        [self.messageArr insertObjects:objects atIndexes:indexes];
        [self.tableView reloadData];
        self.lastMessage = [objects objectAtIndex:0];
        
    }];
}

//键盘出现
- (void)keyboardWillShow:(NSNotification*)noti{
    //键盘的高度
    
    CGSize size = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //屏幕宽高
    CGSize winSize = self.view.frame.size;
    //tableView的大小
    if (self.messageArr.count <= 6) {
        
    }else{
        self.tableView.frame = CGRectMake(0, - size.height, winSize.width, winSize.height - 40 );
    }
}

//键盘消失
- (void)keyboardWillHide:(NSNotification*)noti{
    //屏幕宽高
    CGSize winSize = self.view.frame.size;
    //tableView的大小恢复
    if (!isKeyboardDisappear) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_W, winSize.height - 40);
    }
}

/**
 回调返回高度
 */
- (void)returnHeight:(CGFloat)height
{
    JGLog(@"%f",height);
    if (height == 246) {
        isKeyboardDisappear = YES;
        if (self.messageArr.count <= 5) {
            
        }else{
            self.tableView.frame = CGRectMake(0, - 265, SCREEN_W, SCREEN_H - 40 );
        }
        
    }else{
        isKeyboardDisappear = NO;
    }
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArr.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVIMTextMessage* message = self.messageArr[indexPath.row];
    //计算文本所占大小
    CGSize size = [message.text boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
    return size.height+50;
}

//自定义cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AVIMTextMessage *message = self.messageArr[indexPath.row];
    CGSize size = [message.text boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
    
    if ([message.clientId integerValue] == [USER.login_id integerValue]) {//
        //自己发的,显示在右边
        [cell.rightIcon sd_setImageWithURL:[NSURL URLWithString:message.attributes[@"avatar"]] placeholderImage:[UIImage imageNamed:@"avator"]];
        cell.rightBubble.hidden = NO;
        cell.leftBubble.hidden = YES;
        cell.leftIcon.hidden = YES;
        //显示文本
        cell.rightLabel.text = message.text;
        //重新计算label和气泡的大小
        cell.rightLabel.frame = CGRectMake(10, 10, size.width, size.height);
        cell.rightBubble.frame = CGRectMake(SCREEN_W - 75 -size.width, 20, size.width + 20, size.height + 20);
    }else{
        //显示在左边,接收到的
        [cell.leftIcon sd_setImageWithURL:[NSURL URLWithString:message.attributes[@"avatar"]] placeholderImage:[UIImage imageNamed:@"avator"]];
        cell.rightBubble.hidden = YES;
        cell.leftBubble.hidden = NO;
        cell.rightIcon.hidden = YES;
        //显示文本
        cell.leftLabel.text = message.text;
        //重新计算label和气泡的大小
        cell.leftLabel.frame = CGRectMake(15, 10, size.width, size.height);
        cell.leftBubble.frame = CGRectMake(45, 20, size.width + 30, size.height + 20);
        
    }
    if (message.sendTimestamp==0) {
        cell.timeLabel.text = @"刚刚";
    }else{
        cell.timeLabel.text = [DateOrTimeTool getMessageTime:message.sendTimestamp/1000];
    }
    
//    JGLog(@"%@",[NSDate dateWithTimeIntervalSince1970:message.sendTimestamp/1000]);
    
    return cell;
}

-(void)customUI
{
    NSArray *array = @[@"chatBar_colorMore_photoSelected",@"chatBar_colorMore_audioCall",@"chatBar_colorMore_location",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png"];
    
    BCKeyBoard *bc = [[BCKeyBoard alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 46 -64, [UIScreen mainScreen].bounds.size.width,46)];
    
    bc.delegate = self;
    
    bc.imageArray = array;//图片数组
    
    bc.placeholder = @"说点儿什么吧";//占位文字
    
    bc.placeholderColor = LIGHTGRAYTEXT;//占位文字颜色
    
    bc.backgroundColor = [UIColor clearColor];
    
    bc.currentCtr = self;//当前控制器
    
    [self.view addSubview:bc];
    
    //监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self sendText];
    return YES;
}


#pragma mark ===== BC键盘的点击发送按钮的代理函数 =====

-(void)didSendText:(NSString *)text
{
    if ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showAlertViewWithText:@"不允许发送空消息" duration:1];
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    [attributes setObject:[JGUser user].login_id forKey:@"userid"];
    for (NSString *clientId in self.conversation.members) {
        if (![clientId isEqualToString:USER.login_id]) {
            [attributes setObject:clientId forKey:@"touserid"];
        }
    }
    [attributes setObject:[JGUser user].name forKey:@"nickname"];
    [attributes setObject:[JGUser user].iconUrl forKey:@"avatar"];
    [attributes setObject:@(0) forKey:@"type"];
    
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:text attributes:attributes];
    
    [self.messageArr addObject:message];
    
    [self.conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            JGLog(@"发送成功！");
            if (self.sendMessageBlock) {
                self.sendMessageBlock(text);
            }
        }
    }];
    
    //    添加一行
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //滚动到最后一行
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)receiveMessage:(NSNotification *)noti
{
    AVIMTextMessage *message = noti.object;
    if ([message.conversationId isEqualToString: self.conversation.conversationId]) {
        
        [self.messageArr addObject:message];
        //    添加一行
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //滚动到最后一行
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.view endEditing:YES];
}
-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationDidReceiveMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
