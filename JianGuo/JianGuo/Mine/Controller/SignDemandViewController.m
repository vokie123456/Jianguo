//
//  SignDemandViewController.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SignDemandViewController.h"
#import "MineChatViewController.h"
#import "LCCKConversationViewController.h"
#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+DemandOperation.h"
#import "BillCell.h"
#import "SignUsers.h"
#import "SignersCell.h"

#import "DemandModel.h"

@interface SignDemandViewController ()<UITableViewDataSource,UITableViewDelegate,AgreeUserSomeOneDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SignDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"报名列表";
    
    self.tableView.rowHeight = 118;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestWithCount:@"1"];
        
    }];
    
    self.tableView.mj_footer = ({
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{//上拉加载
            pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
            [self requestWithCount:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        }];
//        footer.automaticallyHidden = YES;
        footer;
        
    });
    
    [self requestWithCount:@"1"];
    
}


-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient signerListWithDemandId:self.demandId pageNum:count pageSize:nil Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (count.intValue>1) {//上拉加载
            
            if ([[SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (SignUsers *model in [SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:1];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//            [_tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArr.count-sections.count, sections.count)] withRowAnimation:UITableViewRowAnimationFade];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }
        
        [self.tableView reloadData];
        if ([SignUsers mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 44;
        }else
            return 65;
    }else
        return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section?self.dataArr.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = [NSString stringWithFormat:@"订单号: %@",self.demandId];
            cell.textLabel.font = FONT(14);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.bottom-1, SCREEN_W-15, 1)];
            line.backgroundColor = BACKCOLORGRAY;
            [cell.contentView addSubview:line];
            
            return cell;
        }else if (indexPath.row == 1){
            BillCell *cell = [BillCell cellWithTableView:tableView];
            
//            cell.titleL.text = @"一起看电影";
//            cell.timeL.text = @"去哪儿看你来定";
//            cell.moneyL.text = @"￥100";
//            cell.moneyL.textColor = [UIColor orangeColor];
            
            return cell;
        }
        return nil;
    }else{
        
        SignersCell *cell = [SignersCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignUsers *user = self.dataArr[indexPath.row];
    MineChatViewController *mineUserVC = [[MineChatViewController alloc] init];
    mineUserVC.hidesBottomBarWhenPushed = YES;
    mineUserVC.userId = user.enrollUid;
    [self.navigationController pushViewController:mineUserVC animated:YES];
    
}

- (IBAction)chat:(id)sender {
    
    SignersCell *cell = (SignersCell *)[[sender superview]superview];
    SignUsers *model = cell.model;
    if (model.enrollUid.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:model.enrollUid]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
    
}



- (IBAction)use:(id)sender {
    
    SignersCell *cell = (SignersCell *)[[sender superview]superview];
    SignUsers *model = cell.model;
    
    JGSVPROGRESSLOAD(@"正在请求...");
    [JGHTTPClient admitUserWithDemandId:self.demandId userId:model.enrollUid Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
        if ([responseObject[@"code"] integerValue] == 200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestWithCount:@"1"];
            });
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}

//
//-(void)userSomeOne:(NSString *)userId status:(NSString *)status cell:(SignersCell *)cell
//{
//    JGSVPROGRESSLOAD(@"请求中...")
//    [JGHTTPClient signDemandWithDemandId:self.demandId userId:userId status:status reason:nil Success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        [self showAlertViewWithText:responseObject[@"message"] duration:1];
//        if ([responseObject[@"code"] integerValue] == 200) {
//            [self refreshData];
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
//}

-(void)refreshData
{
    [self requestWithCount:@"1"];
}

-(void)chatUser:(NSString *)userId
{
    if (userId.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:userId]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
    

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


@end
