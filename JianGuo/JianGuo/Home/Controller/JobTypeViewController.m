//
//  JobTypeViewController.m
//  JianGuo
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JobTypeViewController.h"
#import "JianZhiCell.h"
#import "JianzhiModel.h"
#import "JGHTTPClient+Home.h"
#import "JianZhiDetailController.h"

@interface JobTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *bgView;
    int pageCount;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation JobTypeViewController

-(NSMutableArray *)modelArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
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
    
    IMP_BLOCK_SELF(JobTypeViewController);
    __block int pageNum = pageCount;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//上拉刷新
        
        block_self.tableView.tableHeaderView = nil;

        [block_self requestList:@"1"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0?1:0);
        
        [block_self requestList:[NSString stringWithFormat:@"%d",pageNum]];
    }];
    [self.tableView.mj_header beginRefreshing];

}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...")
    [JGHTTPClient getpartJobsListByHotType:self.type count:count areaId:nil orderField:nil Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if (count.intValue>1) {//上拉加载
            
            if ([[JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (JianzhiModel *model in [JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            return;
            
        }else{
            [self.dataArr removeAllObjects];
            self.dataArr = [JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
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
    }];
    
}
/**
 *  显示无数据图片
 */
-(void)showANopartJobView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_W, 250)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.center.x-60, 0, 120, 120)];
    imgView.image = [UIImage imageNamed:@"img_renwu1"];
    [bgView addSubview:imgView];
    
    UILabel *labelMiddle = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+5, SCREEN_W, 25)];
    labelMiddle.text = @"还没有任何数据哦!";
    labelMiddle.font = FONT(16);
    labelMiddle.textColor = LIGHTGRAYTEXT;
    labelMiddle.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:labelMiddle];
    
    [self.tableView addSubview:bgView];
    bgView.hidden = YES;
}

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
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JianZhiCell *cell = (JianZhiCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    JianzhiModel *model = self.dataArr[indexPath.row];
    
    JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
    
    if (cell.leftCountL.hidden) {//隐藏的时候是招满了
        NSMutableAttributedString *sendCount = [[NSMutableAttributedString alloc] initWithString:@"已经招满"];
        [sendCount addAttributes:@{NSForegroundColorAttributeName:RedColor} range:NSMakeRange(0, sendCount.length)];
        
        jzdetailVC.sendCount = sendCount;
        
    }else{//不隐藏的时候是吧显示的内容直接传过去
        jzdetailVC.sendCount = cell.leftCountL.attributedText;
    }
    
    jzdetailVC.hidesBottomBarWhenPushed = YES;
    
    jzdetailVC.jobId = model.id;
    
    [self.navigationController pushViewController:jzdetailVC animated:YES];
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


@end
