//
//  MyPartJobViewController.m
//  JianGuo
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MyPartJobViewController.h"
#import "PartJobViewController.h"
#import "JGHTTPClient+Home.h"
#import "JianzhiModel.h"
#import "SignListCell.h"
#import "JianZhiDetailController.h"
#import "HomeViewController.h"

@interface MyPartJobViewController()<UITableViewDataSource,UITableViewDelegate,ClickCancelBtnDeleagte>
{

    int pageCount;
    UIView *bgView;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,copy) NSString *type;
@end

@implementation MyPartJobViewController


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.type = @"0";
    self.title = @"我的兼职";

    IMP_BLOCK_SELF(MyPartJobViewController);
    [self.view addSubview:self.tableView];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//上拉刷新

        [block_self requestList:@"1" type:block_self.type];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        
        pageCount = ((int)self.modelArr.count/10) + ((int)(self.modelArr.count/10)>1?1:2);
        
        [block_self requestList:[NSString stringWithFormat:@"%d",pageCount] type:block_self.type];
    }];
    [self.tableView.mj_header beginRefreshing];

    [self showANopartJobView];
}

-(void)requestList:(NSString *)count type:(NSString *)type
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getJobListByLoginId:USER.login_id count:count type:type Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        JGLog(@"%@",responseObject);
        if (count.intValue>1) {//上拉加载
            
            if ([[JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (JianzhiModel *model in [JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ]) {
                [self.modelArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.modelArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            return;
            
        }else{
            [self.modelArr removeAllObjects];
            self.modelArr = [JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.modelArr.count == 0) {
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
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"SignListCell";
    SignListCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"SignListCell" owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = self.modelArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JianzhiModel *model = self.modelArr[indexPath.row];
    
    JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
    
    jzdetailVC.hidesBottomBarWhenPushed = YES;
    
    jzdetailVC.jobId = model.id;
    
    jzdetailVC.merchantId = model.merchant_id;
    
    jzdetailVC.jzModel = model;
    
    [self.navigationController pushViewController:jzdetailVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)showANopartJobView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_W, 250)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.center.x-60, 0, 120, 120)];
    imgView.image = [UIImage imageNamed:@"img_renwu1"];
    [bgView addSubview:imgView];
    
    UILabel *labelMiddle = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+5, SCREEN_W, 25)];
    labelMiddle.text = @"您还没有报名任何兼职哦";
    labelMiddle.font = FONT(16);
    labelMiddle.textColor = LIGHTGRAYTEXT;
    labelMiddle.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:labelMiddle];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"去找工作" forState:UIControlStateNormal];
//    [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
//    btn.frame = CGRectMake(bgView.center.x-50, labelMiddle.bottom, 100, 30);
//    [btn addTarget:self action:@selector(gotoPartJobVC:) forControlEvents:UIControlEventTouchUpInside];
//    btn.titleLabel.font = FONT(16);
//    [bgView addSubview:btn];
    [self.tableView addSubview:bgView];
    bgView.hidden = YES;
}
/**
 *  跳到兼职页
 */
-(void)gotoPartJobVC:(UIButton *)btn
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeVC animated:YES];
}

-(void)clickLeftBtn:(UIButton *)btn
{//每种情况下要根据status判断
    SignListCell *cell = (SignListCell *)[[[btn superview] superview]superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    JianzhiModel *model = self.modelArr[indexPath.row];
    int status = model.status.intValue;
        
    if (status == 1) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定取消?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self changeStatus:@"4" jobId:model.id];
            }];
            [alertVC addAction:cancelAC];
            [alertVC addAction:sureAC];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
//     if (status == 3) {//点击取消参加
//            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定取消?" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self changeStatus:@"4" jobId:model.id];
//            }];
//            [alertVC addAction:cancelAC];
//            [alertVC addAction:sureAC];
//            [self presentViewController:alertVC animated:YES completion:nil];
//        }
    
        
    

}

-(void)clickRightBtn:(UIButton *)btn
{//每种情况下要根据status判断
//    SignListCell *cell = (SignListCell *)[[[btn superview] superview]superview];
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    JianzhiModel *model = self.modelArr[indexPath.row];
//    
//    int status = model.status.intValue;
//
//    if (self.type.intValue == 0) {// 待录取 - 右边按钮隐藏
//        
//        
//        
//    }else if (self.type.intValue == 1){//已录取 - 确认参加
//        
//        if(status == 3){//点击确认参加
//            [self changeStatus:@"5" jobId:model.id];
//        }else if (status == 5){//已确认参加后再取消参加
//            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定取消?" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self changeStatus:@"4" jobId:model.id];
//            }];
//            [alertVC addAction:cancelAC];
//            [alertVC addAction:sureAC];
//            [self presentViewController:alertVC animated:YES completion:nil];
//        }
    
//    }else if (self.type.intValue == 2){// 已完成 - 崔工资
    
//        if(status == 9){//催工资
//            [self changeStatus:@"10" jobId:model.id];
//        }
    
//    }
}

-(void)changeStatus:(NSString *)currentStatus jobId:(NSString *)jobId
{
    [JGHTTPClient changeStausByjobId:jobId loginId:USER.login_id offer:currentStatus Success:^(id responseObject) {
        JGLog(@"%@",responseObject);
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        [self requestList:@"1" type:self.type];
    } failure:^(NSError *error) {
        JGLog(@"%@",error);
    }];
}

@end
