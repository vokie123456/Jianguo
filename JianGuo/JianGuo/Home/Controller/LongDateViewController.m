//
//  LongDateViewController.m
//  JianGuo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "LongDateViewController.h"
#import "JGHTTPClient+Home.h"
#import "JianZhiCell.h"
#import "JianzhiModel.h"
#import "JianZhiDetailController.h"

@interface LongDateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int pageCount;
    UIView *bgView;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;

@end

@implementation LongDateViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self showANopartJobView];
    IMP_BLOCK_SELF(LongDateViewController);
    __block int pageNum = pageCount;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//下拉刷新
        
        pageNum = 0;
        [block_self requestDataCount:@"0"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        pageNum += 10;
        
        [block_self requestDataCount:[NSString stringWithFormat:@"%d",pageNum]];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}
/**
 *  获取数据列表
 */
-(void)requestDataCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"正在加载...");
    [JGHTTPClient getLongDateJobListByCount:count Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        JGLog(@"%@",responseObject);
        
        if (count.intValue) {//上拉加载
           
            if ([[JianzhiModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_job"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (JianzhiModel *model in [JianzhiModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_job"]]) {
                [self.modelArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.modelArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            return;

        }else{
            [self.modelArr removeAllObjects];
            self.modelArr = [JianzhiModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_job"]];
            if (self.modelArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        JGLog(@"%@",error);
    }];
}

#pragma mark tableView 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"JianZhiCell";
    JianZhiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JianZhiCell" owner:nil options:nil]lastObject];
    }
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

/**
 *  显示无数据图片
 */
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"去找工作" forState:UIControlStateNormal];
    [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    btn.frame = CGRectMake(bgView.center.x-50, labelMiddle.bottom, 100, 30);
    [btn addTarget:self action:@selector(gotoPartJobVC:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = FONT(16);
    [bgView addSubview:btn];
    [self.view addSubview:bgView];
    bgView.hidden = YES;
}

-(void)gotoPartJobVC:(UIButton *)btn
{
    [self.tabBarController setSelectedIndex:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    });
}

-(void)dealloc
{

}

@end
