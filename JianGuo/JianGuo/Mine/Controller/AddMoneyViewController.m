//
//  AddMoneyViewController.m
//  JianGuo
//
//  Created by apple on 17/2/18.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "AddMoneyViewController.h"
#import "PostSuccessViewController.h"
#import "PaySelectCell.h"
#import <BeeCloud.h>
#import "JGHTTPClient+Money.h"
#import "JGHTTPClient+Mine.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "QLHudView.h"
#import "MobClick.h"


@interface AddMoneyViewController ()<UITableViewDataSource,UITableViewDelegate,BeeCloudDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate>
{
    PayChannel payType;
}
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIImageView *selecViewAliPay;
@property (nonatomic,strong) UIImageView *selecViewWXPay;
@property (nonatomic,copy) NSString *payType;

@end

@implementation AddMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值";
    payType = PayChannelAliApp;
    self.payType = @"2";//支付宝
    self.moneyTF.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置BeeCloud代理
    [BeeCloud setBeeCloudDelegate:self];
    
    [self requestData];
}

-(void)requestData
{
    [JGHTTPClient lookUserBalanceByloginId:USER.login_id Success:^(id responseObject) {
        if ([responseObject[@"code"] intValue] == 200) {
            
            NSString *money = [responseObject[@"data"] objectForKey:@"money"];
            
            [self.moneyBtn setTitle:[NSString stringWithFormat:@"%.2f",money.floatValue] forState:UIControlStateNormal];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaySelectCell *cell = [PaySelectCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.leftView.image = [UIImage imageNamed:@"aliPay"];
        cell.selectView.image = [UIImage imageNamed:@"mark"];
        self.selecViewAliPay = cell.selectView;
    }else if (indexPath.row == 1){
        cell.payWayL.text = @"微信支付";
        cell.leftView.image = [UIImage imageNamed:@"wxPay"];
        cell.selectView.image = [UIImage imageNamed:@"markk"];
        self.selecViewWXPay = cell.selectView;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//选择支付宝
        self.selecViewAliPay.image = [UIImage imageNamed:@"mark"];
        self.selecViewWXPay.image = [UIImage imageNamed:@"markk"];
        self.payType = @"2";
        payType = PayChannelAliApp;
    }else if (indexPath.row == 1){//选择微信
        self.selecViewAliPay.image = [UIImage imageNamed:@"markk"];
        self.selecViewWXPay.image = [UIImage imageNamed:@"mark"];
        self.payType = @"1";
        payType = PayChannelWxApp;
    }
}
- (IBAction)pay:(id)sender {
    
    if (self.moneyTF.text.floatValue<=0) {
        [self showAlertViewWithText:@"请输入充值金额!" duration:1];
        return;
    }
    [self doPay:payType];
    
}

#pragma mark 支付代码
- (void)doPay:(PayChannel)channel {
    NSString *billno = [self genBillNo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:USER.login_id?USER.login_id:@"0" forKey:@"user_id"];
    
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.cardType = 1;
    payReq.channel = channel; //支付渠道
    payReq.title = @"兼果校园官方"; //订单标题
    NSInteger money = self.moneyTF.text.floatValue*100;
    payReq.totalFee = [NSString stringWithFormat:@"%ld",money]; //订单价格
    payReq.billNo = billno; //商户自定义订单号
    if (channel == PayChannelAliApp) {
        payReq.scheme = @"JianGuopayDemo"; //URL Scheme,在Info.plist中配置;
    }else if (channel == PayChannelWxApp){
        payReq.scheme = @"wx8c1fd6e2e9c4fd49"; //URL Scheme,在Info.plist中配置;
    }
    payReq.billTimeOut = 300; //订单超时时间
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}

#pragma mark - 生成订单号
- (NSString *)genBillNo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}


/**
 *  不同类型的请求，对应不同的响应
 *
 *  @param resp 响应体
 */
- (void)onBeeCloudResp:(BCBaseResp *)resp
{
    if (resp.type == BCObjsTypePayResp) {
        // 支付请求响应
        BCPayResp *tempResp = (BCPayResp *)resp;
        BCPayReq *request = (BCPayReq *)tempResp.request;
        
        if (request.channel == PayChannelWxApp) {
            self.payType = @"1";
        }else if (request.channel == PayChannelAliApp){
            self.payType = @"2";
        }
        
        
        JGLog(@"%@",request.title);
        JGLog(@"%@",request.totalFee);
        JGLog(@"%@",request.billNo);
        
        if (tempResp.resultCode == 0) {
            BCPayReq *payReq = (BCPayReq *)resp.request;
            //百度钱包比较特殊需要用户用获取到的orderInfo，调用百度钱包SDK发起支付
            if (payReq.channel == PayChannelBaiduApp && ![BeeCloud getCurrentMode]) {
                //                    [[BDWalletSDKMainManager getInstance] doPayWithOrderInfo:tempResp.paySource[@"orderInfo"] params:nil delegate:self];
            } else {
                //微信、支付宝、银联支付成功
                [QLHudView showAlertViewWithText:resp.resultMsg duration:1];
            }
        } else {
            //支付取消或者支付失败
            [self showAlertViewWithText:[NSString stringWithFormat:@"%@",tempResp.resultMsg] duration:1];
            
            
        }
        if (tempResp.resultCode == BCErrCodeUserCancel) {
            return;
        }
        NSString *payChannel;
        if (request.channel == PayChannelWxApp) {
            payChannel = @"weixin";
        }else if (request.channel == PayChannelAliApp){
            payChannel = @"aliPay";
        }
        
        [MobClick event:@"recharge_userVersion" attributes:@{@"payChannel":payChannel} counter:request.totalFee.intValue];
        
        [JGHTTPClient uploadOrderPayResultWithType:self.payType title:request.title money:request.totalFee detail:tempResp.resultMsg code:[NSString stringWithFormat:@"%ld",tempResp.resultCode] beeNo:tempResp.bcId orderId:request.billNo userId:USER.login_id Success:^(id responseObject) {
            
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
            if ([responseObject[@"code"] integerValue] == 200) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                PostSuccessViewController *postVC = [[PostSuccessViewController alloc] init];
                postVC.labelStr = @"充值成功";
                postVC.detailStr = @"您可以到【我的钱包】中查看账单详细";
                postVC.transitioningDelegate = self;
                postVC.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:postVC animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            
            
            
        }];
        
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
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

- (IBAction)textChange:(UITextField *)sender {
    
    if (self.moneyTF == sender) {
        
        NSInteger length = sender.text.length;
        
        
        //数字开头不能是 ..小数点
        if (length==1&&[sender.text isEqualToString:@"."]) {
            sender.text = nil;
        }
        
        //限制不能连续输入 ..小数点, 数字中只能出现一个 ..小数点
        if ([sender.text containsString:@".."]) {
            sender.text = [sender.text substringToIndex:length-2];
            return;
        }
        
        if (length>1) {//
            if ([[sender.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]&&![[sender.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]) {
                sender.text = @"0";
            }
            if ([[sender.text substringToIndex:length-2] containsString:@"."]&&[[sender.text substringWithRange:NSMakeRange(length-1, 1)] isEqualToString:@"."]&&length>2) {
                
                sender.text = [sender.text substringToIndex:length-2];
            }
            
        }
        
        if (length>4) {
            NSString *string = [sender.text substringWithRange:NSMakeRange(length-4, 1)];
            if ([string isEqualToString:@"."] ) {
                sender.text = [sender.text substringToIndex:length-1];
            }
        }
    }
    
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}



@end
