//
//  MyBuySkillChildViewController.m
//  JianGuo
//
//  Created by apple on 17/8/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyBuySkillChildViewController.h"
#import "MakeEvaluateViewController.h"
#import "TextReasonViewController.h"
#import "MyBuySkillDetailViewController.h"
#import "LCCKConversationViewController.h"

#import "MySkillManageCell.h"

#import "MyBuySkillListModel.h"

#import "JGHTTPClient+Skill.h"

#import "AlertView.h"
#import "QLAlertView.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"


@interface MyBuySkillChildViewController ()<UITableViewDataSource,UITableViewDelegate,MySkillManageDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MyBuySkillChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 300;
    
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
    [JGHTTPClient getMyBuySkillsListWithPageNum:count type:self.type Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (count.intValue>1) {//上拉加载
            
            if ([[MyBuySkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (MyBuySkillListModel *model in [MyBuySkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_tableView reloadData];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [MyBuySkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
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
//    MyBuySkillListModel *model = self.dataArr[indexPath.row];
//    if (model.isAdjust&&model.orderStatus == 1) {
//        return 330;
//    }else{
//        return 300;
//    }
    return 300;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySkillManageCell *cell = [MySkillManageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.buyModel = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBuySkillListModel *model = self.dataArr[indexPath.row];
    
    MyBuySkillDetailViewController *skillVC = [[MyBuySkillDetailViewController alloc] init];
    skillVC.hidesBottomBarWhenPushed = YES;
    skillVC.orderNo = model.orderNo;
    [self.navigationController pushViewController:skillVC  animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark MySkillManageDelegate
-(void)clickRight:(id)sender model:(MyBuySkillListModel *)model
{
    UIButton *button = sender;
    if ([button.currentTitle containsString:@"付"]) {
        //跳转到支付页面
        [QLAlertView showAlertTittle:@"确定购买?" message:@"购买后将从您的钱包余额里扣除服务费" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient payOrderWithOrderNo:model.orderNo Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                    [self requestList:@"1"];
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
        
    }else if ([button.currentTitle containsString:@"服务完成"]){
        [QLAlertView showAlertTittle:@"确定已经完成服务?" message:@"确认后平台会把服务费付给服务者" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient userSureOrderCompletedWithOrderNo:model.orderNo Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                    [self.dataArr removeObject:model];
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.dataArr indexOfObject:model] inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }else if ([button.currentTitle containsString:@"催TA干活"]){
        [QLAlertView showAlertTittle:@"确定催TA确认?" message:@"" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient remindToDoSkillWithOrderNo:model.orderNo type:@"1" Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }else if ([button.currentTitle containsString:@"去评价"]){
        MakeEvaluateViewController *evaluateVC = [[MakeEvaluateViewController alloc] init];
        evaluateVC.type = @"1";
        evaluateVC.orderNo = model.orderNo;
        [self.navigationController pushViewController:evaluateVC animated:YES];
    }else if ([button.currentTitle containsString:@"投诉订单"]){
        [QLAlertView showAlertTittle:@"确定要投诉服务者?" message:@"" isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient complainOrderWithOrderNo:model.orderNo Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                    
                    model.orderStatus = -5;
                    NSInteger index = [self.dataArr indexOfObject:model];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }
}

-(void)clickLeft:(id)sender model:(MyBuySkillListModel *)model
{
    UIButton *button = sender;
    if ([button.currentTitle containsString:@"取消订单"]){
        [QLAlertView showAlertTittle:@"确定取消订单?" message:nil isOnlySureBtn:NO compeletBlock:^{
            
            [JGHTTPClient cancelOrderWithOrderNo:model.orderNo Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
                if ([responseObject[@"code"]integerValue] == 200) {
                    [self requestList:@"1"];
                }
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:2];
            }];
            
        }];
    }else if ([button.currentTitle containsString:@"申请退款"]){
        [QLAlertView showAlertTittle:@"确定申请退款?" message:nil isOnlySureBtn:NO compeletBlock:^{
            //跳转到申请退款页面
            TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
            reasonVC.transitioningDelegate = self;
            reasonVC.orderNo = [NSString stringWithFormat:@"%@",model.orderNo];
            reasonVC.userId = [NSString stringWithFormat:@"%ld",model.publishUid];
            reasonVC.modalPresentationStyle = UIModalPresentationCustom;
            reasonVC.functionType = ControllerFunctionTypeSkillApplyRefund;
            IMP_BLOCK_SELF(MyBuySkillChildViewController);
            reasonVC.callBackBlock = ^(){
                [block_self requestList:@"1"];
            };
            [self presentViewController:reasonVC animated:YES completion:nil];
            
            
        }];
    }
}

-(void)clickChat:(id)sender model:(MyBuySkillListModel *)model
{
    
    if (model.publishUid == USER.login_id.integerValue) {
        [self showAlertViewWithText:@"您不能跟自己聊天!" duration:1];
        return ;
    }
    LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId:[NSString stringWithFormat:@"%ld",model.publishUid]];
    
    [self.navigationController pushViewController:conversationViewController animated:YES];
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}


@end
