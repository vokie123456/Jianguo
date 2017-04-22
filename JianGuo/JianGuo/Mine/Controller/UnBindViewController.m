//
//  UnBindViewController.m
//  JianGuo
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "UnBindViewController.h"

#import "BindAliPayViewController.h"
#import "BindCardViewController.h"

#import "BindCell.h"
#import "JGHTTPClient+Mine.h"

@interface UnBindViewController ()<UITableViewDataSource,UITableViewDelegate,SelectAcountDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation UnBindViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"解除绑定";
    
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BindCell";
    BindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BindCell" owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.selectView.hidden = YES;
    cell.selectBtn.hidden = YES;
    cell.jiantouView.hidden = YES;
    WalletModel *model = self.dataArr[indexPath.row];
    if (model.type.integerValue == 1) {
        
        cell.iconView.image = [UIImage imageNamed:@"card"];
        cell.bindTypeL.text = @"银行卡";
        cell.bindStateL.text = model.name;
        
    }else if (model.type.integerValue == 2){
        
        cell.iconView.image = [UIImage imageNamed:@"aliPay"];
        cell.bindTypeL.text = @"支付宝";
        cell.bindStateL.text = model.receive_name;
        
    }
    return cell;

}

-(void)clickUnBandBtn:(UIButton *)sender
{
    BindCell *cell = (BindCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WalletModel *model = self.dataArr[indexPath.row];
    
    if (model.type.integerValue == 1) {//银行卡
        
        BindCardViewController *cardVC = [[BindCardViewController alloc] init];
        [self.navigationController pushViewController:cardVC animated:YES];
        
    }else if (model.type.integerValue == 2){//支付宝
        
        BindAliPayViewController *alipayVC = [[BindAliPayViewController alloc] init];
        [self.navigationController pushViewController:alipayVC animated:YES];
        
    }
    /*
    JGSVPROGRESSLOAD(@"正在解绑...");
    [JGHTTPClient unBindByTypeId:model.id Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"]integerValue] == 200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    */
}

@end
