//
//  RemindMsgViewController.m
//  JianGuo
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "RemindMsgViewController.h"


#import "MyWalletNewViewController.h"
#import "RealNameNewViewController.h"
#import "SignDemandViewController.h"

#import "MyPostDetailViewController.h"
#import "BillsViewController.h"
#import "DemandDetailNewViewController.h"
#import "MySignDetailViewController.h"
#import "JianZhiDetailController.h"
#import "MyPartJobViewController.h"
#import "WebViewController.h"
#import "MineChatViewController.h"
#import "SkillsDetailViewController.h"
#import "MySkillDetailViewController.h"
#import "MyBuySkillDetailViewController.h"


#import "NotiMsgCell.h"
#import "JGHTTPClient+Home.h"
#import "NotiNewsModel.h"




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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49)];
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
    self.tableView.estimatedRowHeight = 140; //先估计一个高度
    
    self.view.backgroundColor = BACKCOLORGRAY;
    self.tableView.backgroundColor = BACKCOLORGRAY;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//下拉刷新
        
        [self requestWithCount:@"1"];
    }];
    
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = ({
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{//上拉加载
            pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
            [self requestWithCount:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        }];
//        footer.automaticallyHidden = YES;
        footer;
    
    });
    
    
    [self showANopartJobView];
    
    [self requestWithCount:@"1"];
    
}

-(void)requestWithCount:(NSString *)count
{
    
    JGSVPROGRESSLOAD(@"正在加载...");
    [JGHTTPClient getNotiNewsByPageNum:count Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (count.intValue>1) {//上拉加载
            
            if ([[NotiNewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (JianzhiModel *model in [NotiNewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            return;
            
        }else{
            [self.dataArr removeAllObjects];
            self.dataArr = [NotiNewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
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
        case 4:
        case 1:{//报名推送
            
            VC = [[MyPartJobViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 2:
        case 3:{//主页推送,留在主页就行,不用额外操作
            
            
            JianZhiDetailController *jzdetailVC = [[JianZhiDetailController alloc] init];
            
            jzdetailVC.hidesBottomBarWhenPushed = YES;
            
            jzdetailVC.jobId = model.job_id;
            
            [self.navigationController pushViewController:jzdetailVC animated:YES];
            break;
            
            break;
        }
        case 5:{//钱包推送
            
            VC = [[MyWalletNewViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 7:
        case 6:{//实名推送
            
            VC = [[RealNameNewViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case 8:{//收到了果聊消息 –––> 果聊联系人页面
            
            [self.tabBarController setSelectedIndex:1];
            
            break;
        }
        case 9:{//报名了外露的兼职(主要是发短信的形式) –––>不做处理
            
            break;
        }
        case 10:{//发布的任务收到了新报名(–––>我发布的报名列表)
            
            SignDemandViewController *signVC = [SignDemandViewController new];
            signVC.demandId = model.job_id;
            signVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signVC animated:YES];
            
            break;
        }
            // ***  报名的需求  ***
        case 14://被投诉,收到投诉处理结果(––––>任务详情页面)
        case 13://被雇主投诉(––––>任务详情页面)
        case 16://报名的需求被录用(––––>任务详情页面)
        case 17:{//报名的需求被拒绝(–––>我发布的报名列表)
            MySignDetailViewController *detailVC = [[MySignDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = model.job_id;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 15:{//任务服务费用到账(–––>钱包明细,收入明细)
            
            BillsViewController *billVC = [[BillsViewController alloc] init];
            billVC.hidesBottomBarWhenPushed = YES;
            billVC.type = @"1";
            billVC.title = @"明细";
            [self.navigationController pushViewController:billVC animated:YES];
            break;
        }
            // ***  发布的需求  ***
        case 11://发布的任务未通过审核
        case 12://发布需求,投诉了服务者,收到了投诉处理结果
        case 18:{//发布的需求收到了新评论(–––>也是任务详情页)
            MyPostDetailViewController *detailVC = [[MyPostDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = model.job_id;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 19:{//收到了评论,去普通的需求详情页
            DemandDetailNewViewController *detailVC = [[DemandDetailNewViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.demandId = model.job_id;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 24:{//活动推送(H5)
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.url = model.html_url;
            
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        case 25:{//评价推送(H5)
            
            MineChatViewController *mineChatVC = [[MineChatViewController alloc] init];
            mineChatVC.hidesBottomBarWhenPushed = YES;
            mineChatVC.userId = [NSString stringWithFormat:@"%@",USER.login_id];
            [self.navigationController pushViewController:mineChatVC animated:YES];
            break;
        }
        case 30:{//技能详情
            
            SkillsDetailViewController *skillDetailVC = [[SkillsDetailViewController alloc] init];
            skillDetailVC.hidesBottomBarWhenPushed = YES;
            skillDetailVC.skillId = [NSString stringWithFormat:@"%@",model.job_id];
            [self.navigationController pushViewController:skillDetailVC animated:YES];
            break;
        }
        case 31:{//我发布的技能的详情
            
            MySkillDetailViewController *mySkillVC = [[MySkillDetailViewController alloc] init];
            mySkillVC.hidesBottomBarWhenPushed = YES;
            mySkillVC.orderNo = [NSString stringWithFormat:@"%@",model.job_id];
            [self.navigationController pushViewController:mySkillVC animated:YES];
            break;
        }
        case 32:{//我购买的技能的详情
            
            MyBuySkillDetailViewController *myBuySkillVC = [[MyBuySkillDetailViewController alloc] init];
            myBuySkillVC.hidesBottomBarWhenPushed = YES;
            myBuySkillVC.orderNo = [NSString stringWithFormat:@"%@",model.job_id];
            [self.navigationController pushViewController:myBuySkillVC animated:YES];
            break;
        }
            
        case 100:{
            
            break;
        }
    }

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform = CATransform3DRotate(cell.layer.transform, M_PI, 1, 0, 0);//沿x轴正轴旋转60度
//    cell.transform = CGAffineTransformTranslate(cell.transform, -SCREEN_W/2, 0);
    cell.alpha = 0.0;
    
    [UIView animateWithDuration:0.8 animations:^{
        
        cell.layer.transform = CATransform3DRotate(cell.layer.transform, M_PI, 1, 0, 0);
        
        cell.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
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
