//
//  BindAliPayViewController.m
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "BindAliPayViewController.h"
#import "JGHTTPClient+Mine.h"
#import "JianliCell.h"

@interface BindAliPayViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UITextField *alipayTF;
@end

@implementation BindAliPayViewController
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
    self.title = @"绑定支付宝";
    [self.view addSubview:self.tableView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 135, SCREEN_W, 20)];
    label.textColor = [UIColor redColor];
    label.text = @"请务必核实输入信息,避免给您带来财务损失!";
    label.font = FONT(12);
    [self.tableView addSubview:label];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(30, 180, SCREEN_W-60, 35);
    [saveBtn setBackgroundColor:GreenColor];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.tableView addSubview:saveBtn];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
            cell.rightTf.placeholder = @"支付宝真实姓名";
            self.nameTF = cell.rightTf;
            
            break;
        } case 1:{
            
            cell.labelLeft.text = @"支付宝账号:";
            cell.rightTf.placeholder = @"账号(手机号/邮箱)";
            self.alipayTF = cell.rightTf;
            self.alipayTF.delegate = self;
            self.alipayTF.keyboardType = UIKeyboardTypeASCIICapable;
            
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
    }else if ([[self.alipayTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0){
        [self showAlertViewWithText:@"请输入支付宝账号" duration:1];
        return;
    }
    [JGHTTPClient bindCardOrAlipayByUserName:self.nameTF.text number:self.alipayTF.text bankName:nil type:@"2" Success:^(id responseObject) {
        if([responseObject[@"code"] intValue] == 200){
            [self showAlertViewWithText:@"支付宝绑定成功" duration:1];
            WalletModel *wallet = [WalletModel wallet];

            wallet.name = self.nameTF.text;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.alipayTF) {
        
        return [self validateNumber:string];
    }else
        return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.@abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
