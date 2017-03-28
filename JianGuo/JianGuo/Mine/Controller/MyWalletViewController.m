//
//  MyWalletViewController.m
//  JianGuo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MyWalletViewController.h"
#import "IncomeModel.h"
#import "ExportModel.h"
#import "MoneyRecordModel.h"
#import "WalletCell.h"
#import "MyWalletHeadView.h"
#import "JGHTTPClient+Mine.h"
#import "GetCashViewController.h"
#import "JGHTTPClient+Mine.h"
#import "PayPwViewController.h"
#import "PayDetailCell.h"
#import "SelectScrollView.h"

#define selectViewH 50

//钱包明细枚举
typedef NS_ENUM(NSUInteger,WalletType)
{
    WalletIncome = 1,
    WalletPay = 2
    
};


@interface MyWalletViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ClickSelectDelegate>
{
    WalletType walletType;
    MyWalletHeadView *header;
    SelectScrollView *selectView;
    UIView *bgView;
    int pageCount;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,copy) NSString *sumMoney;

@end

@implementation MyWalletViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 84;
        _tableView.pagingEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的钱包";
    
    
    header = [MyWalletHeadView aWalletHeadView];
    header.delegate = self;
    [self.view addSubview:header];
    
    selectView = [SelectScrollView aSelectViewWithTittles:@[@"收入明细",@"支出明细"] frame:CGRectMake(0, header.bottom, SCREEN_W, selectViewH)];
    IMP_BLOCK_SELF(MyWalletViewController);
    selectView.clickSelectBlock = ^(NSInteger tag){
        switch (tag) {
            case 0:{
                
                [block_self clickIncomeBtn];
                
                break;
            } case 1:{
                
                [block_self clickPayBtn];
                
                break;
            }
        }
        
    };
    [self.view addSubview:selectView];
    
    self.tableView.frame = CGRectMake(0, selectView.bottom, SCREEN_W, SCREEN_H-header.height-64-selectViewH);
    
    [self.view addSubview:self.tableView];
    
    walletType = WalletIncome;

    [self setnavigationBarButton];
    
    __block int pageNum = pageCount;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//下拉刷新
        [block_self requestData];
        [block_self requestList:@"1"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        
        pageNum = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0?1:0);
        
        [block_self requestList:[NSString stringWithFormat:@"%d",pageNum]];
        
    }];

    
    [self showANopartJobView];
}

-(void)viewDidLayoutSubviews
{
    header.frame = CGRectMake(0, 0, SCREEN_W, 145);
}

-(void)requestData
{
    [JGHTTPClient lookUserBalanceByloginId:USER.login_id Success:^(id responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
   
            header.money = [responseObject[@"data"] objectForKey:@"money"];
            
            self.sumMoney = [responseObject[@"data"] objectForKey:@"money"];
        }

    } failure:^(NSError *error) {
        
    }];
}

/**
 *  设置导航条上的按钮
 */
-(void)setnavigationBarButton
{
    UIButton *btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setBackgroundImage:[UIImage imageNamed:@"icon_shezhi"] forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 19, 19);
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:RGBACOLOR(0, 162, 255, 0)] forBarMetrics:UIBarMetricsDefault];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (walletType == WalletIncome) {
        return 84;
    }else{
        return 75;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MoneyRecordModel *model = self.dataArr[indexPath.row];
    if (walletType == WalletIncome) {
        
        static NSString *identifier = @"WalletCell";
        WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletCell" owner:nil options:nil] lastObject];
        }
        
        cell.model = model;
        
        return cell;
    }else{
        static NSString *identifier = @"PayDetailCell";
        PayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PayDetailCell" owner:nil options:nil] lastObject];
        }
        
        cell.model = model;
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  点击右上角按钮
 */
-(void)clickSetting
{
    
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    NSString *type;
    if (walletType == WalletIncome) {
        type = @"1";
    }else if (walletType == WalletPay){
        type = @"2";
    }
    
    [JGHTTPClient lookUserMoneyLogByloginId:USER.login_id type:type count:count Success:^(id responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            if (count.intValue>1) {//上拉加载
                
                if ([[MoneyRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                    [self showAlertViewWithText:@"没有更多数据" duration:1];
                    return ;
                }
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (MoneyRecordModel *model in [MoneyRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                    [self.dataArr addObject:model];
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                    [indexPaths addObject:indexPath];
                }
                
                [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                return;
                
            }else{
                [self.dataArr removeAllObjects];
                self.dataArr = [MoneyRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
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
            [self showAlertViewWithText:NETERROETEXT duration:1];
        }];
    

}

/**
 *  点击收入明细
 */
-(void)clickIncomeBtn
{
    if (walletType == WalletIncome) {
        return;
    }
    walletType = WalletIncome;
    
    [self requestList:@"1"];
}
/**
 *  点击支出明细
 */
-(void)clickPayBtn
{
    if (walletType == WalletPay) {
        return;
    }
    walletType = WalletPay;
    [self requestList:@"1"];
}

-(void)clickCashBtn
{
    /*
    if (USER.status.intValue != 2) {
        NSString *message;
        switch (USER.status.intValue) {
            case 0:{
                
                message = @"您的兼果账号被封,不能提现";
                
                break;
            } case 1:{
                
                message = @"您还没有实名认证,不能提现";
                
                break;
            } case 3:{
                
                message = @"您的实名认证还未通过,不能提现";
                
                break;
            } case 4:{
                
                message = @"您的实名认证未通过,不能提现";
                
                break;
            }
            default:
                break;
        }

        
        [self showAlertViewWithText:message duration:1];
        return;
    }*/

    GetCashViewController *cashVC = [[GetCashViewController alloc] init];
    cashVC.sumMoney = self.sumMoney;
    cashVC.refreshBlock = ^(){
        [self requestData];
    };
    [self.navigationController pushViewController:cashVC animated:YES];
    
}

// 当pagingEnabled属性为YES时，不调用，该方法
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    //    if (velocity.y > 0.0)
    //    {
    //        //向上滑动隐藏导航栏
    //        [self.navigationController setNavigationBarHidden:YES animated:NO];
    ////        CGRect rect = self.tableView.frame;
    ////        rect.origin.y = 64;
    ////        self.tableView.frame = rect;
    //    }else{
    //        //向下滑动显示导航栏
    //        [self.navigationController setNavigationBarHidden:NO animated:NO];
    ////        CGRect rect = self.tableView.frame;
    ////        rect.origin.y = 0;
    ////        self.tableView.frame = rect;
    //    }
}

-(void)showANopartJobView
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, 250)];
    
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
-(UIImage *)imageWithBgColor:(UIColor *)color {//用颜色生成一个image对象
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:RGBACOLOR(0, 162, 255,self.tableView.contentOffset.y/100)] forBarMetrics:UIBarMetricsDefault];
}

-(void)dealloc
{
    JGLog(@"%@ ---- dealloc",NSStringFromClass([self class]));
}

@end
