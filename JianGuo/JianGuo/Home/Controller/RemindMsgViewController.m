//
//  RemindMsgViewController.m
//  JianGuo
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "RemindMsgViewController.h"
#import "NotiMsgCell.h"
#import "JGHTTPClient+Home.h"
#import "NotiNewsModel.h"
#import "MyPartJobViewController.h"
#import "RealNameViewController.h"
#import "MyWalletViewController.h"
#import "WebViewController.h"
#import "JianZhiDetailController.h"

@interface RemindMsgViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *bgView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation RemindMsgViewController

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray  array];
    }
    return _dataArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
//        _tableView.rowHeight = 157;
        _tableView.delegate = self;
        _tableView.dataSource = self;
       
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKCOLORGRAY;
    
    self.title = @"提醒消息";
    
    [self.view addSubview:self.tableView];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension; // 自适应单元格高度
    self.tableView.estimatedRowHeight = 155; //先估计一个高度
    
    JGSVPROGRESSLOAD(@"正在加载...");
    [JGHTTPClient getNotiNewsByloginId:USER.login_id Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] intValue] == 200) {
            self.dataArr = [NotiNewsModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_push"]];
            [self.tableView reloadData];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }else{
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    [self showANopartJobView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [USERDEFAULTS removeObjectForKey:isHaveNewNews];
    [USERDEFAULTS synchronize];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotiMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotiMsgCell"];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotiMsgCell" owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotiNewsModel *model = self.dataArr[indexPath.row];
    
    int intType = model.type.intValue;
    UIViewController *VC;
    switch (intType) {
        case 0:{
            
            VC = [[MyPartJobViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        } case 1:{
            
            VC = [[MyWalletViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        } case 2:{
            
            VC = [[RealNameViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        } case 3:{//主页推送,留在主页就行,不用额外操作
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            break;
        } case 4:{//活动推送(H5)
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = model.html_url;
            
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        } case 5:{//推送一条兼职详情
            
            JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
            
            jzdetailVC.hidesBottomBarWhenPushed = YES;
            
            jzdetailVC.jobId = model.job_id;
            
            [self.navigationController pushViewController:jzdetailVC animated:YES];
            break;
        }
    }
}

-(void)showANopartJobView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, 250)];
    
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

@end
