//
//  MySkillsChildViewController.m
//  JianGuo
//
//  Created by apple on 17/8/2.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MySkillsChildViewController.h"
#import "MySkillDetailViewController.h"
#import "MakeEvaluateViewController.h"
#import "LCCKConversationViewController.h"

#import "MySkillManageCell.h"

#import "MySkillListModel.h"

#import "JGHTTPClient+Skill.h"

#import "AlertView.h"
#import "QLAlertView.h"

@interface MySkillsChildViewController () <UITableViewDataSource,UITableViewDelegate,MySkillManageDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MySkillsChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 330;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestList:@"1"];
        
    }];
    
    
    self.tableView.mj_footer = ({
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{//上拉加载
            pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
            [self requestList:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        }];
        //        footer.automaticallyHidden = YES;
        footer;
        
    });
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getMySkillsListWithPageNum:count type:self.type Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (count.intValue>1) {//上拉加载
            
            if ([[MySkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (MySkillListModel *model in [MySkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_tableView reloadData];
            //            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [MySkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySkillListModel *model = self.dataArr[indexPath.row];
    if (model.isAdjust&&model.orderStatus ==1) {
        return 330;
    }else{
        return 300;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySkillManageCell *cell = [MySkillManageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySkillListModel *model = self.dataArr[indexPath.row];
    MySkillDetailViewController *skillVC = [[MySkillDetailViewController alloc] init];
    skillVC.hidesBottomBarWhenPushed = YES;
    skillVC.orderNo = model.orderNo;
    [self.navigationController pushViewController:skillVC  animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark MySkillManageDelegate 
-(void)clickRight:(id)sender model:(MySkillListModel *)model
{
    UIButton *button = sender;
    if ([button.currentTitle containsString:@"调整价格"]) {
        [[AlertView aAlertViewCallBackBlock:^(NSString *price) {
            
            [JGHTTPClient alertSkillPriceWithOrderNo:model.orderNo changePrice:price Success:^(id responseObject) {
                
                if ([responseObject[@"code"] integerValue] == 200) {
                    model.isAdjust = 1;
                    model.realPrice = price.floatValue;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.dataArr indexOfObject:model] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }] show];
    }else if ([button.currentTitle containsString:@"完成服务"]){
        [QLAlertView showAlertTittle:@"确定已经完成服务?" message:nil isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient skillExpertSureOrderCompletedWithOrderNo:model.orderNo Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                    [self requestList:@"1"];
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }else if ([button.currentTitle containsString:@"催TA确认"]){
        [QLAlertView showAlertTittle:@"确定催TA确认?" message:@"" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient remindToDoSkillWithOrderNo:model.orderNo type:@"2" Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }else if ([button.currentTitle containsString:@"去评价"]){
        MakeEvaluateViewController *evaluateVC = [[MakeEvaluateViewController alloc] init];
        evaluateVC.type = @"2";
        evaluateVC.orderNo = model.orderNo;
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }else if ([button.currentTitle containsString:@"同意退款"]){
        [QLAlertView showAlertTittle:@"确定同意退款?" message:@"" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient decideDealRefundWithOrderNo:model.orderNo type:@"1" Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }
}

-(void)clickLeft:(id)sender model:(MySkillListModel *)model
{
    UIButton *button = sender;
    if ([button.currentTitle containsString:@"拒绝退款"]){
        [QLAlertView showAlertTittle:@"确定拒绝退款申请?" message:@"" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient decideDealRefundWithOrderNo:model.orderNo type:@"2" Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }
}

-(void)clickChat:(id)sender model:(MySkillListModel *)model
{
    
    if (model.buyUid == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithFormat:@"%ld",model.buyUid]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
}

@end
