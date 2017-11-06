//
//  DemandStatusParentViewController.m
//  JianGuo
//
//  Created by apple on 17/6/27.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandStatusParentViewController.h"
#import "MyPostDetailViewController.h"
#import "SignDemandViewController.h"
#import "TextReasonViewController.h"
#import "MySignDetailViewController.h"
#import "MineChatViewController.h"

#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "QLHudView.h"
#import "QLAlertView.h"

#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+DemandOperation.h"

#import "MyDemandCell.h"
#import "MySignDemandCell.h"

#import "DemandPostModel.h"



@interface DemandStatusParentViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MyDemandClickDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
/** 数据源 数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation DemandStatusParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"已结束的任务";
    
    self.tableView.estimatedRowHeight = 187;
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
    
    
    if (!self.isFinishedVC) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"已结束" style:UIBarButtonItemStylePlain target:self action:@selector(finishedDemands:)];
        item.tintColor = GreenColor;
        
        self.navigationItem.rightBarButtonItem = item;
        self.navigationItem.title = @"任务管理";
    }
    
}

-(void)finishedDemands:(NSString *)sender
{
    DemandStatusParentViewController *VC = [[DemandStatusParentViewController alloc] init];
    VC.isFinishedVC = YES;
    VC.type = @"null";
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getMyDemandsListWithPageNum:count type:self.type pageSize:nil Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (count.intValue>1) {//上拉加载
            
            if ([[DemandPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (DemandPostModel *model in [DemandPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [self.tableView reloadData];
//            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [DemandPostModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
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

    MyDemandCell *cell = [MyDemandCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DemandPostModel *model = self.dataArr[indexPath.row];
    if (model.kind.integerValue == 1) {
        
        MyPostDetailViewController *postVC = [[MyPostDetailViewController alloc] init];
        postVC.demandId = model.demandId;
        postVC.isTimeOut = model.isTimeout.boolValue;
        IMP_BLOCK_SELF(DemandStatusParentViewController);
        postVC.changeStatusBlock = ^(){
            [block_self requestList:@"1"];
        };
        postVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:postVC animated:YES];
    }else{
        
        MySignDetailViewController *signVC = [[MySignDetailViewController alloc] init];
        signVC.demandId = model.demandId;
        
        IMP_BLOCK_SELF(DemandStatusParentViewController);
        signVC.changeStatusBlock = ^(){
            [block_self requestList:@"1"];
        };
        signVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:signVC animated:YES];
    }
    
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.layer.transform = CATransform3DRotate(cell.layer.transform, M_PI, 1, 0, 0);//沿x轴正轴旋转60度
//    //    cell.transform = CGAffineTransformTranslate(cell.transform, -SCREEN_W/2, 0);
//    cell.alpha = 0.0;
//    
//    [UIView animateWithDuration:0.8 animations:^{
//        
//        cell.layer.transform = CATransform3DRotate(cell.layer.transform, M_PI, 1, 0, 0);
//        
//        cell.alpha = 1.0;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//}

- (IBAction)clickLeft:(id)sender {
    
    MyDemandCell *cell = (MyDemandCell *)[[[[sender superview]superview]superview]superview];
    DemandPostModel *model = cell.model;
    UIButton *btn = sender;
    
    if (model.kind.integerValue == 2) {
        
        switch (model.status.integerValue) {
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
    }else if (model.kind.integerValue == 1){
        
        switch (model.status.integerValue) {
            case 1:{//下架任务
                
                [QLAlertView showAlertTittle:@"确定下架任务?" message:nil isOnlySureBtn:NO compeletBlock:^{
                    
                    btn.userInteractionEnabled = NO;
                    JGSVPROGRESSLOAD(@"正在请求...");
                    [JGHTTPClient offDemandWithDemandId:model.demandId reason:nil money:nil Success:^(id responseObject) {
                        
                        btn.userInteractionEnabled = YES;
                        [SVProgressHUD dismiss];
                        [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
                        if ([responseObject[@"code"] integerValue] == 200) {//下架成功
                            
                            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                            [self.dataArr removeObject:model];
                            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            
                        }
                        
                    } failure:^(NSError *error) {
                        
                        btn.userInteractionEnabled = YES;
                        [SVProgressHUD dismiss];
                        [QLHudView showAlertViewWithText:NETERROETEXT duration:1.f];
                        
                    }];
                    
                }];
                
                
                break;
            } case 2:{//下架任务 <暂时改为 无操作>
                
                
                
                break;
            } case 3:{//拒绝付款
                
                TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
                reasonVC.transitioningDelegate = self;
                reasonVC.demandId = model.demandId;
                reasonVC.userId = [model.enrolls.firstObject enrollUid];
                reasonVC.modalPresentationStyle = UIModalPresentationCustom;
                reasonVC.functionType = ControllerFunctionTypeRefusePay;
                IMP_BLOCK_SELF(DemandStatusParentViewController);
                reasonVC.callBackBlock = ^(){
                    [block_self requestList:@"1"];
                };
                [self presentViewController:reasonVC animated:YES completion:nil];
                
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
    
}

- (IBAction)clickRight:(id)sender {
    
    MyDemandCell *cell = (MyDemandCell *)[[[[sender superview]superview]superview]superview];
    DemandPostModel *model = cell.model;
    UIButton *btn = sender;
    
    if (model.kind.integerValue == 1) {
        
        switch (model.status.integerValue) {
            case 1:{//查看报名
                
                SignDemandViewController *usersVC = [[SignDemandViewController alloc] init];
                usersVC.demandId = model.demandId;
                [self.navigationController pushViewController:usersVC animated:YES];
                
                break;
            } case 2:{//催他干活
                
                JGSVPROGRESSLOAD(@"正在请求...");
                btn.userInteractionEnabled = NO;
                [JGHTTPClient remindUserWithDemandId:model.demandId Success:^(id responseObject) {
                    
                    [SVProgressHUD dismiss];
                    btn.userInteractionEnabled = YES;
                    [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
                    if ([responseObject[@"code"] integerValue] == 200) {
                        
                        
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                    [QLHudView showAlertViewWithText:NETERROETEXT duration:1.f];
                    [SVProgressHUD dismiss];
                    btn.userInteractionEnabled = YES;
                }];
                
                break;
            } case 3:{//确认完工
                
                [QLAlertView showAlertTittle:@"确定完成任务?" message:nil isOnlySureBtn:NO compeletBlock:^{
                    
                    JGSVPROGRESSLOAD(@"正在请求...");
                    btn.userInteractionEnabled = NO;
                    [JGHTTPClient sureToFinishDemandWithDemandId:model.demandId type:@"2" Success:^(id responseObject) {
                        
                        [SVProgressHUD dismiss];
                        btn.userInteractionEnabled = YES;
                        [QLHudView showAlertViewWithText:responseObject[@"message"] duration:1.f];
                        if ([responseObject[@"code"] integerValue] == 200) {
                            
                            [self requestList:@"1"];
                            
                        }
                        
                    } failure:^(NSError *error) {
                        [SVProgressHUD dismiss];
                        btn.userInteractionEnabled = YES;
                        [QLHudView showAlertViewWithText:NETERROETEXT duration:1.f];
                        
                    }];
                    
                }];
                
                
                break;
            } case 4:{//去评价
                
                TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
                reasonVC.transitioningDelegate = self;
                reasonVC.demandId = model.demandId;
                //            reasonVC.userId = model.enrollUserId;
                reasonVC.modalPresentationStyle = UIModalPresentationCustom;
                reasonVC.functionType = ControllerFunctionTypePublisherEvualuate;
                IMP_BLOCK_SELF(DemandStatusParentViewController);
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
    }else if (model.kind.integerValue == 2){
        
        switch (model.status.integerValue) {
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
                IMP_BLOCK_SELF(DemandStatusParentViewController);
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
     
    
}

-(void)lookUser:(NSString *)userId
{
    MineChatViewController *mineVC = [[MineChatViewController alloc] init];
    mineVC.userId = userId;
    mineVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineVC animated:YES];
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
