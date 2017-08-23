//
//  AddressListViewController.m
//  JianGuo
//
//  Created by apple on 17/8/1.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddNewAddressController.h"

#import "AddressListCell.h"

#import "AddressModel.h"

#import "JGHTTPClient+Address.h"

@interface AddressListViewController () <AddressCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"地址管理";
    
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageCount = 0;
        [self requestList:@"1"];
        
    }];
    
    
    self.tableView.mj_footer = ({
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{//上拉加载
            pageCount = ((int)self.dataArr.count/10) + ((int)(self.dataArr.count/10)>=1?1:2) + ((self.dataArr.count%10)>0&&self.dataArr.count>10?1:0);
            [self requestList:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        }];
        //        footer.automaticallyHidden = YES;
        footer;
        
    });
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)requestList:(NSString *)count
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getAddresListWithPageNum:count Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (count.intValue>1) {//上拉加载
            
            if ([[AddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]] count] == 0) {
                [self showAlertViewWithText:@"没有更多数据" duration:1];
                return ;
            }
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (AddressModel *model in [AddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]) {
                [self.dataArr addObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_tableView reloadData];
            //            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            return;
            
        }else{
            
            [self.dataArr removeAllObjects];
            self.dataArr = [AddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] ];
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
        [self showAlertViewWithText:NETERROETEXT duration:1.5];
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressListCell *cell = [AddressListCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.section];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isFromPlaceOrderVC) {
        
        AddressModel *model = self.dataArr[indexPath.section];
        AddressListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (self.selectAddressBlock) {
            self.selectAddressBlock(model,cell);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
- (IBAction)addNewAddress:(id)sender {
    
    AddNewAddressController *addVC = [[AddNewAddressController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

//删除地址
-(void)deleteAddress:(AddressModel *)model
{
    [JGHTTPClient deleteAddressWithAddress:[NSString stringWithFormat:@"%ld",model.id] Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            NSInteger index = [self.dataArr indexOfObject:model];
            [self.dataArr removeObject:model];
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationLeft];
            
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:2];
    }];
}
//编辑地址
-(void)editAddress:(AddressModel *)model
{
    AddNewAddressController *addVC = [[AddNewAddressController alloc] init];
    addVC.model = model;
    [self.navigationController pushViewController:addVC animated:YES];
    
}


@end
