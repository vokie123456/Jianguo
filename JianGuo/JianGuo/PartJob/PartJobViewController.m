//
//  PartJobViewController.m
//  JianGuo
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "PartJobViewController.h"
#import "CityModel.h"
#import "PartTypeModel.h"
#import "AreaModel.h"
#import "JianZhiDetailController.h"
#import "JGHTTPClient+Home.h"
#import "JGHTTPClient+Job.h"
#import "JianZhiCell.h"
#import "JianzhiModel.h"
#import "DOPDropDownMenu.h"

@interface PartJobViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    UIView *bgView;
    int pageCount;
}
/** 职业种类 */
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *areaId;
@property (nonatomic,copy) NSString *sequenceType;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic, strong) DOPDropDownMenu *selectMenu;
@property (nonatomic,strong) NSMutableArray *jobTypeArr;
@property (nonatomic,strong) NSMutableArray *sortTypeArr;
@property (nonatomic,strong) NSMutableArray *areaTypeArr;

@property (nonatomic,copy) NSString *currentType;

@end

@implementation PartJobViewController


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_W, SCREEN_H-64)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

-(NSMutableArray *)jobTypeArr
{
    if (!_jobTypeArr) {
        
        NSMutableArray *arr  = (NSMutableArray *)JGKeyedUnarchiver(JGJobTypeArr);
        PartTypeModel *model = [[PartTypeModel alloc] init];
        model.id = @"0";
        model.name = @"全部兼职";
        [arr insertObject:model atIndex:0];
        _jobTypeArr = arr;
    }
    return _jobTypeArr;
}
-(NSMutableArray *)sortTypeArr
{
    if (!_sortTypeArr) {
        _sortTypeArr = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JGSort" ofType:@"plist"]]];
    }
    return _sortTypeArr;
}
-(NSMutableArray *)areaTypeArr
{
    if (!_areaTypeArr) {
        NSMutableArray *arr = (NSMutableArray *)[CityModel city].areaList;
        AreaModel *model = [[AreaModel alloc] init];
        model.id = @"0";
        model.areaName = @"全部地区";
        [arr insertObject:model atIndex:0];
        _areaTypeArr = arr;
    }
    return _areaTypeArr;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.cityId = [CityModel city].code;
        self.type = @"0";
        self.areaId = @"0";
        self.sequenceType = @"0";
        [NotificationCenter addObserver:self selector:@selector(changeCity:) name:kNotificationCity object:nil];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    //    self.tableView.tableHeaderView = self.selectMenu;

    
    [self initMenu];
    [self requestList:@"1"];
    [self showANopartJobView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//上拉刷新
        
        [self requestList:@"1"];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{//上拉加载
        pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
        [self requestList:[NSString stringWithFormat:@"%d",pageCount]];
    }];

}
//城市改变通知
-(void)changeCity:(NSNotification *)noti
{
    [self.areaTypeArr removeAllObjects];
    self.areaTypeArr = nil;
    [self.selectMenu reloadData];
    
    self.cityId = [CityModel city].code;

    self.areaId = @"0";
    
    [self requestList:@"1"];
}

-(void)initMenu{
    self.selectMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    self.selectMenu.delegate = self;
    self.selectMenu.dataSource = self;
    [self.view addSubview:self.selectMenu];
}


-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...")
    [JGHTTPClient getJobsListByHotType:self.type cityId:self.cityId areaId:self.areaId sequenceType:self.sequenceType count:count Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if (count.intValue>1) {//上拉加载
            if ([[JianzhiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (JianzhiModel *model in [JianzhiModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list_t_job"]]) {
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
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
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
}


#pragma mark DOPDropDownMenuDataSource (三方筛选控件代理方法)
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{//有几列
    return 3;
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{//哪一列有几行
    if (column == 0) {
        return self.jobTypeArr.count;
    }else if (column == 1){
        return self.areaTypeArr.count;
    }else {
        return self.sortTypeArr.count;
    }
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{//设置哪一列的哪一行 的名字
    
    if (indexPath.column == 0) {
        PartTypeModel *model = self.jobTypeArr[indexPath.row];
        return model.name;
    } else if (indexPath.column == 1){
        AreaModel *model = self.areaTypeArr[indexPath.row];
        return model.areaName;
    } else {
        return [self.sortTypeArr[indexPath.row] objectForKey:@"name"];
    }
    
}
#pragma mark - DOPDropDownMenuDelegate
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{//选择第几行执行什么操作
    
    if (indexPath.column == 0) {
        
        PartTypeModel *model = self.jobTypeArr[indexPath.row];
        self.type = model.id;
        
    } else if (indexPath.column == 1){
        
        AreaModel *model = self.areaTypeArr[indexPath.row];
        self.areaId = model.id;
        
    } else {
        self.sequenceType = [self.sortTypeArr[indexPath.row] objectForKey:@"id"];
    }
    [self  requestList:@"1"];
    
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


-(void)dealloc
{
    [NotificationCenter removeObserver:self name:kNotificationJobType object:nil];
    [NotificationCenter removeObserver:self name:kNotificationCity object:nil];
}

@end
