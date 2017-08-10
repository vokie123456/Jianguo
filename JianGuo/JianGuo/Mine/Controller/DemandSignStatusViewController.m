//
//  DemandSignStatusViewController.m
//  JianGuo
//
//  Created by apple on 17/6/28.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandSignStatusViewController.h"
#import "TextReasonViewController.h"
#import "MySignDetailViewController.h"

#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+DemandOperation.h"

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "QLAlertView.h"

#import "MySignDemandCell.h"

#import "DemandSignModel.h"

@interface DemandSignStatusViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
/** 数据源 数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation DemandSignStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
    
    [self requestList:@"1"];
    
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMySignedDemandsListWithPageNum:count type:self.type pageSize:nil Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (count.intValue>1) {//上拉加载
            
            if ([[DemandSignModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (DemandSignModel *model in [DemandSignModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_tableView reloadData];
//            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [DemandSignModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
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
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySignDemandCell *cell = [MySignDemandCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    if (cell.model.limitTimeStr.length == 0) {
        cell.timeLimitHeightCons.constant = 0;
        cell.timeLimitL.hidden = YES;
    }else{
        cell.timeLimitHeightCons.constant = 35;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DemandSignModel *model = self.dataArr[indexPath.row];
    MySignDetailViewController *signVC = [[MySignDetailViewController alloc] init];
    signVC.demandId = model.demandId;
    signVC.type = model.type;
    IMP_BLOCK_SELF(DemandSignStatusViewController);
    signVC.changeStatusBlock = ^(){
        [block_self requestList:@"1"];
    };
    signVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signVC animated:YES];
    
}


- (IBAction)clickLeft:(id)sender {
    
    
    MySignDemandCell *cell = (MySignDemandCell *)[[[[sender superview]superview]superview]superview];
    DemandSignModel *model = cell.model;
    
    switch (model.type.integerValue) {
        case 1:{//隐藏无操作
            
            
            break;
        } case 2:{//隐藏无操作
            
            
            
            break;
        } case 3:{//催任务发布者确认完工
            
            JGSVPROGRESSLOAD(@"正在请求...");
            [JGHTTPClient remindPublisherWithDemandId:model.demandId Success:^(id responseObject) {
                
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                if ([responseObject[@"code"] integerValue] == 200) {
                    
                }
                
            } failure:^(NSError *error) {
                
                [self showAlertViewWithText:NETERROETEXT duration:1.f];
                [SVProgressHUD dismiss];
            }];
            
            break;
        } case 4:{//隐藏了––>无操作
            
            
            
            break;
        } case 5:{//隐藏––>无操作
            
            
            
            break;
        }
        default:
            break;
    }
    
}
- (IBAction)clickRight:(id)sender {
    
    MySignDemandCell *cell = (MySignDemandCell *)[[[[sender superview]superview]superview]superview];
    DemandSignModel *model = cell.model;
    
    switch (model.type.integerValue) {
        case 1:{//取消报名
            
            [QLAlertView showAlertTittle:@"确定取消报名?" message:nil isOnlySureBtn:NO compeletBlock:^{
                
                JGSVPROGRESSLOAD(@"正在请求...");
                [JGHTTPClient cancelSignWithDemandId:model.demandId Success:^(id responseObject) {
                    
                    [SVProgressHUD dismiss];
                    [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                    if ([responseObject[@"code"] integerValue] == 200) {
                        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                        [self.dataArr removeObject:model];
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    
                } failure:^(NSError *error) {
                    
                    [self showAlertViewWithText:NETERROETEXT duration:1.f];
                    [SVProgressHUD dismiss];
                }];
                
            }];
            
            break;
        } case 2:{//确认完工
            
            
            [QLAlertView showAlertTittle:@"确定完成任务?" message:nil isOnlySureBtn:NO compeletBlock:^{
                
                
                JGSVPROGRESSLOAD(@"正在请求...");
                [JGHTTPClient sureToFinishDemandWithDemandId:model.demandId type:@"1" Success:^(id responseObject) {
                    
                    [SVProgressHUD dismiss];
                    [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                    if ([responseObject[@"code"] integerValue] == 200) {
                        
                        [self requestList:@"1"];
                    }
                    
                } failure:^(NSError *error) {
                    
                    [self showAlertViewWithText:NETERROETEXT duration:1.f];
                    [SVProgressHUD dismiss];
                }];
                
            }];
            
            break;
        } case 3:{//催TA确认
            
            JGSVPROGRESSLOAD(@"正在请求...");
            [JGHTTPClient remindPublisherWithDemandId:model.demandId Success:^(id responseObject) {
                
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:responseObject[@"message"] duration:1.f];
                if ([responseObject[@"code"] integerValue] == 200) {
                    
                }
                
            } failure:^(NSError *error) {
                
                [self showAlertViewWithText:NETERROETEXT duration:1.f];
                [SVProgressHUD dismiss];
            }];
            
            break;
        } case 4:{//去评价
            
            TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
            reasonVC.transitioningDelegate = self;
            reasonVC.demandId = model.demandId;
            reasonVC.userId = model.publishUserId;
            reasonVC.modalPresentationStyle = UIModalPresentationCustom;
            reasonVC.functionType = ControllerFunctionTypeWaiterEvaluate;
            IMP_BLOCK_SELF(DemandSignStatusViewController);
            reasonVC.callBackBlock = ^(){
                [block_self requestList:@"1"];
            };
            [self presentViewController:reasonVC animated:YES completion:nil];
            
            
            break;
        } case 5:{//隐藏––>无操作
            
            
            
            break;
        }
        default:
            break;
    }
    
}

-(void)testGesture
{
    JGLog(@"响应了点击手势...");
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（就是击了tableViewCell），则不截获Touch事件（就是继续执行Cell的点击方法）
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
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
