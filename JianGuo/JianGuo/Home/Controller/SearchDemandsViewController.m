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
#import "SkillListModel.h"
#import "CityModel.h"
#import "SchoolModel.h"

#import "DemandListCell.h"
#import "SkillsCell.h"

#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+Skill.h"

#import "JGHTTPClient+Mine.h"

#import "DOPDropDownMenu.h"


static NSString *identifier = @"DemandListCell";


@interface SearchDemandsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    NSString *keyword;
    __weak IBOutlet NSLayoutConstraint *tableViewTopCons;
    UIView *titleView;
    UIButton *button;
    UIView *backgroundView;
    UIView *selectView;
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
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-100, 40)];
    self.searchBar.frame = CGRectMake(0, 0, titleView.width, titleView.height);
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundColor:RGBCOLOR(233, 235, 236)];
    button.titleLabel.font = FONT(15);
    [button setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [button setTitle:@"技能▼" forState:UIControlStateNormal];
    [titleView addSubview:button];
    self.searchBar.frame = CGRectMake(button.right, 0, titleView.width-button.width, 40);
    
    [titleView addSubview:self.searchBar];
    
    self.orderType = @"createTime";
    if (self.isModule) {
        [self initMenu];
        tableViewTopCons.constant = 44;
        self.searchBar.hidden = YES;
        self.cityCode = @"0";
        [self.tableView.mj_header beginRefreshing];
    }else{
        self.navigationItem.titleView = titleView;
        self.searchBar.hidden = NO;
        
        self.searchBar.tintColor = [UIColor blueColor];
    }
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
    
     setTitleTextAttributes:@{NSForegroundColorAttributeName : LIGHTGRAYTEXT}
     
     forState:UIControlStateNormal];
    
    self.searchBar.barTintColor = LIGHTGRAYTEXT;
//    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(64, 0, SCREEN_W, SCREEN_H)];
//    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    self.searchBar.inputAccessoryView = coverView;

    
    
    [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        
        if (self.isModule) {
            
            [self requestWithCount:@"1"];
            
        }else{
            
            if ([button.currentTitle containsString:@"任务"]) {
                [self requestWithCount:@"1"];
            }else if ([button.currentTitle containsString:@"技能"]){
                [self requestListCount:@"1"];
            }
        }
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageCount = ((int)(self.dataArr.count-1)/10) + ((int)((self.dataArr.count-1)/10)>=1?1:2) + (((self.dataArr.count-1)%10)>0&&(self.dataArr.count-1)>10?1:0);
        if ([button.currentTitle containsString:@"任务"]) {
            [self requestWithCount:[NSString stringWithFormat:@"%ld",pageCount]];
        }else if ([button.currentTitle containsString:@"技能"]){
            [self requestListCount:[NSString stringWithFormat:@"%ld",pageCount]];
        }
        
    }];
//    if (self.isModule) {
//        self.searchBar.hidden = YES;
//        [self.tableView.mj_header beginRefreshing];
//    }else{
//        self.navigationItem.titleView = self.searchBar;
//        
//        self.searchBar.tintColor = [UIColor blueColor];
//    }
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)setSearchBarLeftView
{
    
}

-(void)changeType:(UIButton *)sender
{
    
    backgroundView = [[UIView alloc] initWithFrame:APPLICATION.keyWindow.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    [APPLICATION.keyWindow addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromView)];
    [backgroundView addGestureRecognizer:tap];
    
    
    selectView = [[UIView alloc] initWithFrame:CGRectZero];
    selectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    
    CGRect rect = [button convertRect:button.frame toView:backgroundView];
    selectView.frame = CGRectMake(rect.origin.x+5, rect.size.height+rect.origin.y, 50, 0);
    selectView.clipsToBounds = YES;
    
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn0 setTitle:@"技能" forState:UIControlStateNormal];
    
    [btn0 addTarget:self action:@selector(selectSkill:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [selectView addSubview:btn0];
    
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn1 setTitle:@"任务" forState:UIControlStateNormal];
    
    [btn1 addTarget:self action:@selector(selectSkill:) forControlEvents:UIControlEventTouchUpInside];
    
    btn0.frame = CGRectMake(0, 0, 50, 40);
    btn1.frame = CGRectMake(0, btn0.bottom, 50, 40);
    [selectView addSubview:btn1];
    
    [backgroundView addSubview:selectView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = [button convertRect:button.frame toView:backgroundView];
        selectView.frame = CGRectMake(rect.origin.x+5, rect.size.height+rect.origin.y, 50, 80);
        
    }];
    
}

-(void)removeFromView
{
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect rect = [button convertRect:button.frame toView:backgroundView];
//        selectView.frame = CGRectMake(rect.origin.x, rect.size.height+rect.origin.y, 80, 0);
//        
//    } completion:^(BOOL finished) {
//    }];
    
    [backgroundView removeFromSuperview];
}

-(void)selectSkill:(UIButton *)sender
{
    [self removeFromView];
    
    [button setTitle:[sender.currentTitle stringByAppendingString:@"▼"] forState:UIControlStateNormal];
    
    if ([sender.currentTitle containsString:@"任务"]) {
        
        [self requestWithCount:@"1"];
        
    }else if ([sender.currentTitle containsString:@"技能"]){
        [self requestListCount:@"1"];
    }
    
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
            
            
//            NSMutableArray *indexPaths = [NSMutableArray array];
            for (DemandModel *model in [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
//                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
//                [indexPaths addObject:indexPath];
            }
            
            
            [self.tableView reloadData];
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
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];
}


//技能
-(void)requestListCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getSkillListWithSchoolId:self.schoolId cityCode:self.cityCode keywords:keyword orderBy:self.orderType type:self.type sex:self.sex userId:nil pageCount:count Success:^(id responseObject) {
        //        [SVProgressHUD dismiss];
        //        JGLog(@"%@",responseObject);
        //        self.dataArr = [DemandModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        JGLog(@"%@",responseObject);
        
        if (count.integerValue>1) {//上拉加载
            
            if ([[SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            
            
//            NSMutableArray *indexPaths = [NSMutableArray array];
            for (SkillListModel *model in [SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
//                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
//                [indexPaths addObject:indexPath];
            }
            
            [self.tableView reloadData];
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
            self.dataArr = [SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
        }
        
        [self.tableView reloadData];
        if ([SkillListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] == 0) {
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([button.currentTitle containsString:@"任务"]||self.isModule) {
        return UITableViewAutomaticDimension;
    }else if ([button.currentTitle containsString:@"技能"]){
        return 335;
    }else
        return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isModule) {
        DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        DemandModel *model = self.dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }else if ([button.currentTitle containsString:@"任务"]) {
        DemandListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        DemandModel *model = self.dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }else if ([button.currentTitle containsString:@"技能"]){
        SkillsCell *cell = [SkillsCell cellWithTableView:tableView];
        cell.model = self.dataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else return nil;
    
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
    
//    self.navigationItem.titleView = titleView;

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
    if ([button.currentTitle containsString:@"任务"]) {
        [self requestWithCount:@"1"];
    }else if ([button.currentTitle containsString:@"技能"]){
        [self requestListCount:@"1"];
    }
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
            self.orderType = @"createTime";//最新
        }else if (indexPath.row == 1){
            self.orderType = @"viewCount";//最热
        }
        
    }
    
    if (self.isModule) {
        [self requestWithCount:@"1"];
    }else if ([button.currentTitle containsString:@"任务"]) {
        [self requestWithCount:@"1"];
    }else if ([button.currentTitle containsString:@"技能"]){
        [self requestListCount:@"1"];
    }
    
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
