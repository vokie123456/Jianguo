//
//  DiscoveryViewController.m
//  JianGuo
//
//  Created by apple on 17/5/23.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "WebViewController.h"
#import "WebViewController.h"

#import "JGHTTPClient+Discovery.h"

#import "DiscoveryCell.h"

#import "DiscoveryModel.h"

#import "QLSuccessHudView.h"

@interface DiscoveryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 180;
    
    [self requestList:@"1"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//上拉刷新
        
        [self requestList:@"1"];
    }];
    self.tableView.mj_footer = ({
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{//上拉加载
            pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
            [self requestList:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        }];
        //        footer.automaticallyHidden = YES;
        footer;
        
    });
    
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...")
    [JGHTTPClient getDiscoveryListPageNum:count Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (count.intValue>1) {//上拉加载
            if ([[DiscoveryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (DiscoveryModel *model in [DiscoveryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            return;
            
        }else{
            [self.dataArr removeAllObjects];
            self.dataArr = [DiscoveryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
            if (self.dataArr.count == 0) {
                bgView.hidden = NO;
            }else{
                bgView.hidden = YES;
            }
            [self.tableView reloadData];
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
    DiscoveryCell *cell = [DiscoveryCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    DiscoveryModel *model = self.dataArr[indexPath.row];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    NSString *url = [[model.linkUrl componentsSeparatedByString:@"\\"]componentsJoinedByString:@""];
    webVC.url = url;
    webVC.ishaveShareButton = YES;
    webVC.model = model;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 != 0) {
        cell.transform = CGAffineTransformTranslate(cell.transform, SCREEN_W/2, 0);
        
    }else{
        cell.transform = CGAffineTransformTranslate(cell.transform, -SCREEN_W/2, 0);
    }
    cell.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        cell.transform = CGAffineTransformIdentity;
        
        cell.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}



@end
