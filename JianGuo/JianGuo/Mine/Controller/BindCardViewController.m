//
//  BindCardViewController.m
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BindCardViewController.h"
#import "JGHTTPClient+Mine.h"
#import "JianliCell.h"

@interface BindCardViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UITextField *bankTF;
@property (nonatomic,strong) UITextField *cardNoTF;
@end

@implementation BindCardViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定银行卡";
    [self.view addSubview:self.tableView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, SCREEN_W, 20)];
    label.textColor = [UIColor redColor];
    label.text = @"请务必核实输入信息,避免给您带来财务损失!";
    label.font = FONT(12);
    [self.tableView addSubview:label];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(30, 220, SCREEN_W-60, 35);
    [saveBtn setBackgroundColor:GreenColor];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.tableView addSubview:saveBtn];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JianliCell *cell = [JianliCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jiantouView.hidden = YES;
    cell.rightTf.userInteractionEnabled = YES;
    cell.rightTf.enabled = YES;
    cell.rightTf.font = FONT(15);
    switch (indexPath.row) {
        case 0:{
            
            cell.labelLeft.text = @"真实姓名:";
            cell.rightTf.placeholder = @"银行卡开户姓名";
            self.nameTF = cell.rightTf;
        
            break;
        } case 1:{
            
            cell.labelLeft.text = @"开户银行:";
            cell.rightTf.placeholder = @"如:建设银行";
            self.bankTF = cell.rightTf;
            
            break;
        } case 2:{
            
            cell.labelLeft.text = @"银行卡号:";
            cell.rightTf.placeholder = @"请务必核实无误";
            self.cardNoTF = cell.rightTf;
            self.cardNoTF.keyboardType = UIKeyboardTypeNumberPad;
            
            break;
        }
    }

    return cell;
}

-(void)clickSave
{
    if ([[self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [self showAlertViewWithText:@"请输入真实姓名" duration:1];
        return;
    }else if ([[self.bankTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0){
        [self showAlertViewWithText:@"请输入所属银行" duration:1];
        return;
    }else if ([[self.cardNoTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        [self showAlertViewWithText:@"请输入银行卡号" duration:1];
        return;
    }
    [JGHTTPClient bindCardOrAlipayByUserName:self.nameTF.text number:self.cardNoTF.text bankName:self.bankTF.text type:@"1" Success:^(id responseObject) {
        if([responseObject[@"code"] intValue] == 200){
            [self showAlertViewWithText:@"银行卡绑定成功" duration:1];
            WalletModel *wallet = [WalletModel wallet];
            
            [WalletModel saveWallet:wallet];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *vc = self.navigationController.viewControllers[2];
                [self.navigationController popToViewController:vc animated:YES];
            });
        }else{
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
