//
//  SearchDemandsViewController.m
//  JianGuo
//
//  Created by apple on 17/6/8.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SearchDemandsViewController.h"
#import "DemandDetailNewViewController.h"

#import "DemandModel.h"
#import "CityModel.h"
#import "SchoolModel.h"

#import "DemandListCell.h"

#import "JGHTTPClient+Demand.h"

#import "JGHTTPClient+Mine.h"

#import "DOPDropDownMenu.h"


static NSString *identifier = @"DemandListCell";


@interface SearchDemandsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    NSString *keyword;
    __weak IBOutlet NSLayoutConstraint *tableViewTopCons;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) DOPDropDownMenu *selectMenu;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *cityArr;
@property (nonatomic,strong) NSMutableArray *schoolArr;

@property (nonatomic,copy) NSString *cityCode;
@property (nonatomic,strong) NSString *orderType;
@property (nonatomic,strong) NSString *sex;
/** 学校id */
@property (nonatomic,copy) NSString *schoolId;

@end

@implementation SearchDemandsViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.cityArr = JGKeyedUnarchiver(JGCityArr);
        CityModel *model = self.cityArr.firstObject;
        
        [JGHTTPClient searchSchoolByName:nil cityCode:model.code Success:^(id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue] == 200) {
                self.schoolArr = [SchoolModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                SchoolModel *school = [[SchoolModel alloc] init];
                school.id = @"0";
                school.name = @"全部学校";
                [self.schoolArr insertObject:school atIndex:0];
                [self.selectMenu reloadData];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderType = @"create_time";
    if (self.isModule) {
        [self initMenu];
        tableViewTopCons.constant = 44;
        self.searchBar.hidden = YES;
        self.cityCode = @"0";
    }else{
        self.navigationItem.titleView = self.searchBar;
        
        self.searchBar.tintColor = [UIColor blueColor];
    }
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     
     setTitleTextAttributes:@{NSForegroundColorAttributeName : LIGHTGRAYTEXT}
     
     forState:UIControlStateNormal];
    
//    self.searchBar.barTintColor = LIGHTGRAYTEXT;
//    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(64, 0, SCREEN_W, SCREEN_H)];
//    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    self.searchBar.inputAccessoryView = coverView;

    
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestWithCount:@"1"];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageCount = ((int)(self.dataArr.count-1)/10) + ((int)((self.dataArr.count-1)/10)>=1?1:2) + (((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0);
        
        JGLog(@"one ====  %d",(int)self.dataArr.count/10);
        JGLog(@"two ==== %d",((int)(self.dataArr.count/10)>=1?1:2));
        JGLog(@"three ==== %d",(((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0));
        [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        
    }];
    if (self.isModule) {
        self.searchBar.hidden = YES;
        [self.tableView.mj_header beginRefreshing];
    }else{
        self.navigationItem.titleView = self.searchBar;
        
        self.searchBar.tintColor = [UIColor blueColor];
    }
    
//    [self.tableView.mj_header beginRefreshing];
}


//配置筛选控件
-(void)initMenu{
    self.selectMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    self.selectMenu.delegate = self;
    self.selectMenu.dataSource = self;
    self.selectMenu.isScrollTop = YES;
    self.selectMenu.textSelectedColor = GreenColor;
    if (SCREEN_W == 320) {
        self.selectMenu.fontSize = 12;
    }
    
    [self.view addSubview:self.selectMenu];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getDemandListWithSchoolId:self.schoolId cityCode:self.cityCode keywords:keyword orderBy:self.orderType type:self.type sex:self.sex userId:nil pageCount:count Success:^(id responseObject) {
        //        [SVProgressHUD dismiss];
        //        JGLog(@"%@",responseObject);
        //        self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        JGLog(@"%@",responseObject);
        
        if (count.integerValue>1) {//上拉加载
            
            if ([[DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (DemandModel *model in [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            /*
             NSMutableArray *sections = [NSMutableArray array];
             for (DemandModel *model in [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
             [self.dataArr addObject:model];
             NSIndexSet* section = [NSIndexSet indexSetWithIndex:self.dataArr.count-1];
             [sections addObject:section];
             }
             [_tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.dataArr.count-sections.count, sections.count)] withRowAnimation:UITableViewRowAnimationFade];
             */
            return;
            
        }else{
            self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }
        
        [self.tableView reloadData];
        if ([DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
            [self showAlertViewWithText:@"没有更多数据" duration:1];
            return ;
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
    DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    DemandModel *model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemandDetailNewViewController *detailVC = [DemandDetailNewViewController new];
    if (self.dataArr.count>indexPath.row) {
        detailVC.demandId = [(DemandModel *)self.dataArr[indexPath.row] demandId];
    }
    detailVC.hidesBottomBarWhenPushed = YES;
    //    detailVC.callBackBlock = ^(){
    //        [self requestWithCount:@"1"];
    //    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UISearchBarDelegate 协议

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];

    return YES;
    
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];

//    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    keyword = searchText;
    [self requestWithCount:@"1"];
    [APPLICATION.keyWindow endEditing:YES];
}



#pragma mark DOPDropDownMenuDataSource (三方筛选控件代理方法)
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{//有几列
    return 4;
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{//哪一列有几行
    if (column == 0) {
        return self.cityArr.count;
    }else if (column == 1){
        return self.schoolArr.count;
    }else if (column == 2){
        return 3;
    }else {
        return 2;
    }
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{//设置哪一列的哪一行 的名字
    
    if (indexPath.column == 0) {
        CityModel *model = self.cityArr[indexPath.row];
        return model.cityName;
    } else if (indexPath.column == 1){
        
        SchoolModel *model = self.schoolArr[indexPath.row];
        return model.name;
        
    } else if (indexPath.column == 2){
        NSArray *titleArr = @[@"不限男女",@"只看女",@"只看男 "];
        return titleArr[indexPath.row];
    } else {
        NSArray *titleArr = @[@"最新",@"最热"];
        return titleArr[indexPath.row];
    }
    
}
#pragma mark - DOPDropDownMenuDelegate
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{//选择第几行执行什么操作
    
    if (indexPath.column == 0) {
        
        CityModel *model = self.cityArr[indexPath.row];
        self.cityCode = model.code;
        self.schoolId = @"0";
        [self getSchoolsByCityCode:model.code];
        
        [self.selectMenu selectIndexPath:[DOPIndexPath indexPathWithCol:1 row:0] triggerDelegate:NO];
        
    } else if (indexPath.column == 1){
        
        SchoolModel *school = self.schoolArr[indexPath.row];
        self.schoolId = school.id;
        
    } else if (indexPath.column == 2){
        
        if (indexPath.row == 0) {
            self.sex = @"0";//不限男女
        }else if (indexPath.row == 1){
            self.sex = @"1";//只看女
        }else if (indexPath.row == 2){
            self.sex = @"2";//只看男
        }
        
    } else if (indexPath.column == 3){
        
        if (indexPath.row == 0) {
            self.orderType = @"create_time";//最新
        }else if (indexPath.row == 1){
            self.orderType = @"like_count";//最热
        }
        
    }
    [self requestWithCount:@"1"];
    
}

-(void)getSchoolsByCityCode:(NSString *)cityCode
{
    [JGHTTPClient searchSchoolByName:nil cityCode:cityCode Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"code"] integerValue] == 200) {
            self.schoolArr = [SchoolModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            SchoolModel *school = [[SchoolModel alloc] init];
            school.id = @"0";
            school.name = @"全部学校";
            [self.schoolArr insertObject:school atIndex:0];
            //                [self.selectMenu reloadData];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



@end
