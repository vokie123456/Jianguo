//
//  MerChantViewController.m
//  JianGuo
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MerChantViewController.h"
#import "MerCntHeaderView.h"
#import "JianZhiCell.h"
#import "JGHTTPClient+Home.h"
#import "JianzhiModel.h"
#import "JianZhiDetailController.h"

@interface MerChantViewController()<UITableViewDataSource,UITableViewDelegate>
{
    MerCntHeaderView *_header;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UILabel *countL;

@end

@implementation MerChantViewController

-(UILabel *)countL
{
    if (!_countL) {
        _countL = [[UILabel alloc] init];
    }
    return _countL;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_W, SCREEN_H)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _header = [MerCntHeaderView aMerchantHeaderView];
        _header.model = self.model;
        _tableView.tableHeaderView = _header;
        _tableView.rowHeight = 110;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    
    [self customBackBtn];
    
    [self requestHotJob];
}

-(void)requestHotJob
{
//    JGSVPROGRESSLOAD(@"加载中...")
//    IMP_BLOCK_SELF(MerChantViewController)
//    [JGHTTPClient getpartJobsListByHotType:@"1" count:@"0" Success:^(id responseObject) {
//        [SVProgressHUD dismiss];
//        if (responseObject) {
//            if ([responseObject[@"code"] integerValue] == 200) {
//                JGLog(@"%@",responseObject);
//                //把字典转成json格式
//                JGLog(@"%@",[JGHTTPClient dictionaryToJson:responseObject]);
//
//                if (block_self.dataArr.count) {
//                    [block_self.dataArr removeAllObjects];
//                }
//                
//                block_self.dataArr = [JianzhiModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_job"]];
//                block_self.countL.text = [NSString stringWithFormat:@"(%lu个)",(unsigned long)block_self.dataArr.count];
//                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
}


/**
 *  自定义返回按钮
 */
-(void)customBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 12, 21);
    [backBtn addTarget:self action:@selector(popToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}/**
  *  返回上一级页面
  */
-(void)popToLoginVC
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] animated:YES];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }else{
        return 0.01;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [self customAheaderView];
    }else{
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"merchant";
    JianZhiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JianZhiCell" owner:nil options:nil]lastObject];
    }
    cell.model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JianzhiModel *model = self.dataArr[indexPath.row];
    
    JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
    
    jzdetailVC.hidesBottomBarWhenPushed = YES;
    
    jzdetailVC.jobId = model.id;
    
    jzdetailVC.merchantId = model.merchant_id;
    
    jzdetailVC.jzModel = model;
    
    [self.navigationController pushViewController:jzdetailVC animated:YES];
}

/**
 *  自定义section headerView
 *
 *  @return 一个View
 */
-(UIView *)customAheaderView
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    sectionHeaderView.backgroundColor = WHITECOLOR;
    
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 18, 18)];
    leftImgView.image = [UIImage imageNamed:@"icon_remen"];
    [sectionHeaderView addSubview:leftImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftImgView.right+5, 0, 100, 40)];
    label.text = @"在招的兼职";
    label.font = FONT(SCREEN_W==320?16:18);
    label.textColor = RGBCOLOR(249, 124, 124);
    [sectionHeaderView addSubview:label];
    
    self.countL.frame = CGRectMake(label.right+5, 0, 100, 40);
    self.countL.font = FONT(SCREEN_W==320?12:14);
    self.countL.textColor = [UIColor lightGrayColor];
    [sectionHeaderView addSubview:self.countL];

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeaderView.frame.size.height-1, SCREEN_W, 1)];
    lineView.backgroundColor = BACKCOLORGRAY;
    [sectionHeaderView addSubview:lineView];
    
    
    return sectionHeaderView;
    
}


@end
