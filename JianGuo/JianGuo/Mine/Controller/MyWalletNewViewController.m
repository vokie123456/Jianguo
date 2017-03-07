//
//  MyWalletNewViewController.m
//  JianGuo
//
//  Created by apple on 17/2/18.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MyWalletNewViewController.h"
#import "WalletCollectionCell.h"
#import "GetCashViewController.h"
#import "AddMoneyViewController.h"
#import "BillsViewController.h"
#import "JGHTTPClient+Mine.h"

static NSString *identifier = @"WalletCollectionCell";

@interface MyWalletNewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MyWalletNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的钱包";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = BACKCOLORGRAY;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WalletCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    
    [self.collectionView reloadData];
    
//    [self requestData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}

-(void)requestData
{
    [JGHTTPClient lookUserBalanceByloginId:USER.login_id Success:^(id responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            
            NSString *money = [responseObject[@"data"] objectForKey:@"money"];
            self.moneyL.text = [NSString stringWithFormat:@"¥ %.2f",money.floatValue];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WalletCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.item == 0) {
        
        cell.iconView.image = [UIImage imageNamed:@"Withdrawals"];
        cell.label.text = @"我要提现";
        
    }else if (indexPath.item == 1){
        
        cell.iconView.image = [UIImage imageNamed:@"recharge"];
        cell.label.text = @"我要充值";
        
    }else if (indexPath.item == 2){
        
        cell.iconView.image = [UIImage imageNamed:@"income"];
        cell.label.text = @"收入明细";
        
    }else if (indexPath.item == 3){
        
        cell.iconView.image = [UIImage imageNamed:@"expenditure"];
        cell.label.text = @"支出明细";
        
    }else {
        cell.iconView.image = nil;
        cell.label.text = nil;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {//提现
        
        GetCashViewController *cashVC = [[GetCashViewController alloc] init];
        cashVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cashVC animated:YES];
        
    }else if (indexPath.item == 1){//充值
        
        AddMoneyViewController *addMoneyVC = [[AddMoneyViewController alloc] init];
        addMoneyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addMoneyVC animated:YES];
        
    }else if (indexPath.item == 2){//收入明细
        
        BillsViewController *billVC = [[BillsViewController alloc] init];
        billVC.hidesBottomBarWhenPushed = YES;
        billVC.type = @"1";
        [self.navigationController pushViewController:billVC animated:YES];
        
    }else if (indexPath.item == 3){//支出明细
        
        BillsViewController *billVC = [[BillsViewController alloc] init];
        billVC.hidesBottomBarWhenPushed = YES;
        billVC.type = @"2";
        [self.navigationController pushViewController:billVC animated:YES];
        
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_W/3, SCREEN_W/3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


@end
