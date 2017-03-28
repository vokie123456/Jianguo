//
//  CitySchoolViewController.m
//  JianGuo
//
//  Created by apple on 17/2/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CitySchoolViewController.h"
#import "NavigatinViewController+Drawer.h"
#import "MJNIndexView.h"
#import "BrandCell.h"
#import "TitleCell.h"
#import "CityModel.h"
#import "JGHTTPClient+Mine.h"
#import "SchoolModel.h"

@interface CitySchoolViewController ()<UITableViewDataSource,UITableViewDelegate,MJNIndexViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UITableView *schoolTableView;
@property (nonatomic, strong) MJNIndexView *indexView;
@property (nonatomic,strong) NSMutableArray *cityArr;
@property (strong, nonatomic) NSMutableArray* schoolArr;
@property (strong, nonatomic) NSIndexPath *selectedBrandIndex;

@property (nonatomic,copy) NSString *cityCode;

@end

@implementation CitySchoolViewController

-(NSMutableArray *)cityArr
{
    if (!_cityArr) {
        NSArray *array = JGKeyedUnarchiver(JGCityArr);
        _cityArr = [NSMutableArray arrayWithArray:array];
    }
    return _cityArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择学校";
    
    [self initViews];
    
    self.swipeGestureRecognizer.enabled = NO;
    
}

- (void)initViews
{
    
    [self.tableView registerNib:[UINib nibWithNibName:kBrandCellId bundle:nil] forCellReuseIdentifier:kBrandCellId];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    //自定义indexView
    self.indexView = [[MJNIndexView alloc] initWithFrame:self.tableView.frame];
    self.indexView.dataSource = self;
//    if (kSystemVersion>=7) {
//        self.indexView.top = 65;
//        self.indexView.height = self.tableView.height-65;
//    }
    [self.view addSubview:self.indexView];
    // 配置车系抽屉
    [self p_setupSeriesDrawer];
}
// 初始化车系抽屉UI
- (void) p_setupSeriesDrawer
{
    UIView *content = [[UIView alloc] initWithFrame:(CGRect){CGPointMake(0, 0),SCREEN_W-kDrawerOpenX,SCREEN_H-64}];
    UITableView *seriesTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,content.width,content.height}];
    [seriesTableView registerNib:[UINib nibWithNibName:kTitleCellId bundle:nil] forCellReuseIdentifier:kTitleCellId];
    seriesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    seriesTableView.dataSource = self;
    seriesTableView.delegate = self;
//    if (kSystemVersion>=7) {
//        seriesTableView.contentInset = UIEdgeInsetsMake(CONTENTINSET_TOP+IOS7_STATUS_BAR_HEGHT, 0, 0, 0);
//        seriesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(CONTENTINSET_TOP+IOS7_STATUS_BAR_HEGHT, 0, 0, 0);
//    }
    self.schoolTableView = seriesTableView;
    [content addSubview:seriesTableView];
    // 配置到drawerView中
    [self setupDrawerWithContent:content scrollConent:seriesTableView];
}


- (void) closeDrawerCompleted {
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    if (selectedIndex) {
        [self.tableView deselectRowAtIndexPath:selectedIndex animated:YES];
    }
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.tableView == tableView) {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return 60;
        }
        return 44;
    }
    else
    {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return section?self.cityArr.count:1;
    }
    else
    {
        return self.schoolArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.tableView == tableView) {
        return section?@"当前开通城市":@"定位城市";
    }else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        if(indexPath.section == 0){
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *locationL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 40)];
            locationL.textAlignment = NSTextAlignmentCenter;
            locationL.textColor = GreenColor;
            locationL.font = [UIFont boldSystemFontOfSize:16];
            locationL.layer.cornerRadius = 5;
            locationL.layer.borderWidth = 1.5;
            
            locationL.layer.borderColor = GreenColor.CGColor;
            locationL.text = [USERDEFAULTS objectForKey:CityName];
            [cell.contentView addSubview:locationL];
            return cell;
            
        }else{
            BrandCell *cell = [BrandCell cellWithTableView:tableView];
            cell.titleLabel.text = [self.cityArr[indexPath.row] cityName];
            return cell;
        }
    }
    else
    {
        TitleCell *cell = [TitleCell cellWithTableView:tableView];
        SchoolModel *school = self.schoolArr[indexPath.row];
        cell.lbTitle.text = school.name;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return;
        }
        
//        if (self.selectSchoolBlock) {
//            self.selectSchoolBlock(nil,model);
//        }
        CityModel *model = self.cityArr[indexPath.row];
        self.cityCode = model.code;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES animated:YES];
        [self showDrawer];
        JGSVPROGRESSLOAD(@"加载中...");
        [JGHTTPClient searchSchoolByName:nil cityCode:self.cityCode Success:^(id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue] == 200) {
                self.schoolArr = [SchoolModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//                SchoolModel *school = [[SchoolModel alloc] init];
//                school.id = @"0";
//                school.name = @"全部学校";
//                [self.schoolArr insertObject:school atIndex:0];
                [self.schoolTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
    else
    {
        if (self.selectSchoolBlock) {
            SchoolModel *model = self.schoolArr[indexPath.row];
            self.selectSchoolBlock(model,nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark – indexView
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    NSMutableArray*titleList=[NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6"]];
    
    return titleList;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:YES];
}

- (void)gestureBegin
{
}

- (void)gestureEnd
{
}



@end
