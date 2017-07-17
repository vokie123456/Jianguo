//
//  FunsFollowViewController.m
//  JianGuo
//
//  Created by apple on 17/6/26.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "FunsFollowViewController.h"
#import "LCCKConversationViewController.h"
#import "MineChatViewController.h"

#import "FunsCell.h"

#import "FunsModel.h"

#import "JGHTTPClient+Mine.h"
#import "JGHTTPClient+Demand.h"


@interface FunsFollowViewController ()<UITableViewDataSource,UITableViewDelegate,FunsCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;
/** titleView上的滑线 */
@property (nonatomic,strong) UIView *line;
/** 0==我的关注  1==我的粉丝 */
@property (nonatomic,copy) NSString *type;

@end

@implementation FunsFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customSegmentView];
    
    self.type = @"0";
    
    [self requestWithCount:@"1"];
    
    self.tableView.rowHeight = 80;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestWithCount:@"1"];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
        
        
        [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];

}

-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getFunsOrFollowsWithType:self.type userId:self.userId pageCount:count Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (count.intValue>1) {//上拉加载
            
            if ([[FunsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (FunsModel *model in [FunsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [FunsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];
}

-(void)customSegmentView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-100, 44)];
    
    UIButton *leftB = [UIButton buttonWithType:UIButtonTypeCustom];
    leftB.tag = 1000;
    [leftB setTitle:@"我关注的" forState:UIControlStateNormal];
    if (USER.login_id.integerValue != self.userId.integerValue) {
        [leftB setTitle:@"TA关注的" forState:UIControlStateNormal];
    }
    leftB.frame = CGRectMake(0, 0, titleView.width/2, 40);
    [leftB setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [leftB addTarget:self action:@selector(segmentData:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    rightB.tag = 1001;
    [rightB setTitle:@"我的粉丝" forState:UIControlStateNormal];
    if (USER.login_id.integerValue != self.userId.integerValue) {
        [rightB setTitle:@"TA的粉丝" forState:UIControlStateNormal];
    }
    rightB.frame = CGRectMake(leftB.right, 0, titleView.width/2, 40);
    [rightB setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [rightB addTarget:self action:@selector(segmentData:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, leftB.bottom, 100, 2)];
    line.backgroundColor = GreenColor;
    CGPoint lineCenter = line.center;
    lineCenter.x = leftB.center.x;
    line.center = lineCenter;
    self.line = line;
    
    [titleView addSubview:leftB];
    [titleView addSubview:rightB];
    [titleView addSubview:line];
    
    self.navigationItem.titleView = titleView;
    
}

-(void)segmentData:(UIButton *)sender
{
    CGPoint center = self.line.center;
    center.x = sender.center.x;
    [UIView animateWithDuration:0.3 animations:^{
        self.line.center = center;
    }];
    if (sender.tag == 1000) {//我关注的
        
        self.type = @"0";
        [self requestWithCount:@"1"];
        
    }else if (sender.tag == 1001){//我的粉丝
        
        self.type = @"1";
        [self requestWithCount:@"1"];
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FunsCell *cell = [FunsCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FunsModel *user = self.dataArr[indexPath.row];
    MineChatViewController *mineUserVC = [[MineChatViewController alloc] init];
    mineUserVC.hidesBottomBarWhenPushed = YES;
    mineUserVC.userId = user.userId;
    [self.navigationController pushViewController:mineUserVC animated:YES];
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type.integerValue==0 ) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消关注";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        FunsModel *model = self.dataArr[indexPath.row];
        
        [JGHTTPClient followUserWithUserId:model.userId status:@"0" Success:^(id responseObject) {
            
            [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [self.dataArr removeObject:model];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}

-(void)followSomeOne:(NSString *)userId
{
    if (![self checkExistPhoneNum]) {
        [self gotoCodeVC];
        return;
    }
    //1==关注 , 0==取消
    [JGHTTPClient followUserWithUserId:userId status:@"1" Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showAlertViewWithText:@"关注成功" duration:1];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)chatSomeOne:(NSString *)userId
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
    if (userId.integerValue == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithString:userId]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
}

@end
