//
//  SearchSchoolViewController.m
//  JianGuo
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "SearchSchoolViewController.h"
#import "JGHTTPClient+Mine.h"
#import "SchoolModel.h"
#import "SearchSchoolViewController+AlertView.h"

@interface SearchSchoolViewController ()<UISearchBarDelegate>
{
    NSArray *data;
    NSArray *filterData;
    UISearchController *searchController;
}

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSArray *resultArr;

@end

@implementation SearchSchoolViewController

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
        
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索您的学校";
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                           , 44)];
    searchBar.placeholder = @"输入您的学校名字";
    searchBar.delegate = self;
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = searchBar;
    
    [self customBackBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = BACKCOLORGRAY;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

//    CGFloat top = 5;
//    CGFloat bottom = 5 ;
//    CGFloat left = 0;
//    CGFloat right = 0;
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"icon-navigationBar"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
    [self requestBy:@""];
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
}

/**
 *  返回上一级页面
 */
-(void)popToLoginVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    // 这个有点类似sql语句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@", searchText]; // name\pinYin\pinYinHead不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
    self.resultArr = [self.dataArr filteredArrayUsingPredicate:predicate]; // 这个self.resultCities可以是一个不可变数组
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

-(void)requestBy:(NSString *)searchText
{
    JGSVPROGRESSLOAD(@"正在加载...");
    [JGHTTPClient searchSchoolByName:searchText Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        if (self.dataArr.count) {
            [self.dataArr removeAllObjects];
        }
        
        if (responseObject) {
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                
                SchoolModel *schoolModel = [SchoolModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:schoolModel];
                
            }
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.resultArr.count) {
        return self.resultArr.count;
    }
    else
        return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"schoolCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    if (self.resultArr.count) {
        SchoolModel *schoolModel = self.resultArr[indexPath.row];
        
        cell.textLabel.text = schoolModel.name;
    }else{
        SchoolModel *schoolModel = self.dataArr[indexPath.row];
        
        cell.textLabel.text = schoolModel.name;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultArr.count) {
        SchoolModel *schoolModel = self.resultArr[indexPath.row];
        if (self.seletSchoolBlock) {
            self.seletSchoolBlock(schoolModel);
        }
    }else{
        SchoolModel *schoolModel = self.dataArr[indexPath.row];
        if (self.seletSchoolBlock) {
            self.seletSchoolBlock(schoolModel);
        }
    }
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2)] animated:YES];
}

@end
