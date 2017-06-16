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
#import "DemandListCell.h"

#import "JGHTTPClient+Demand.h"


static NSString *identifier = @"DemandListCell";


@interface SearchDemandsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSString *keyword;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SearchDemandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isModule) {
        self.searchBar.hidden = YES;
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

- (BOOL)prefersStatusBarHidden {
    return NO;
}


-(void)requestWithCount:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    
    [JGHTTPClient getDemandListWithSchoolId:nil cityCode:nil keywords:keyword orderBy:@"create_time" type:self.type sex:nil userId:USER.login_id pageCount:count Success:^(id responseObject) {
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
        detailVC.demandId = [(DemandModel *)self.dataArr[indexPath.row] id];
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
}


@end
