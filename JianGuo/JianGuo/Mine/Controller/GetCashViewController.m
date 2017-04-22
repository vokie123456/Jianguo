//
//  GetCashViewController.m
//  JianGuo
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "GetCashViewController.h"
#import "RealNameModel.h"
#import "BindCell.h"
#import "BindCardViewController.h"
#import "BindAliPayViewController.h"
#import "JGHTTPClient+Mine.h"
#import "JGHTTPClient+LoginOrRegister.h"
#import "QLAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/SSEBaseUser.h>
#import "UnBindViewController.h"
#import "BillsViewController.h"

#define SECONDCOUNT 60


@interface GetCashViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,SelectAcountDelegate>
{
    int count;
    NSTimer *_timer;
    BOOL isShowAlert;
    WalletModel *bankModel;
    WalletModel *aliPayModel;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *alipayView;
@property (nonatomic,strong) UIImageView *bankCarfView;
@property (nonatomic,strong) UIImageView *weixinView;
@property (nonatomic,strong) UITextField *countTF;

@property (nonatomic,strong) UITextField *phoneTf;

@property (nonatomic,strong) UIButton *btn_r;
@property (nonatomic,strong) UIButton *getCodeBtn;
@property (nonatomic,copy) NSString *drawCashType;
@property (nonatomic,copy) NSString *pay_type_id;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *jsonArr;
@end

@implementation GetCashViewController

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
    self.jsonArr = [NSMutableArray array];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    count = SECONDCOUNT;
    self.navigationItem.title = @"提现";
    [self.view addSubview:self.tableView];
    
    WalletModel *model = [WalletModel wallet];

    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setTitle:@"重新绑定" forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(gotoSettingVC) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 80, 30);
    self.btn_r = btn_r;
    self.btn_r.hidden = YES;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    sureBtn.frame = CGRectMake(30, 330+(model.weixin.intValue==0?0:55), SCREEN_W-60, 40);

    [sureBtn setBackgroundColor:GreenColor];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(sureGetCash) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    [self.tableView addSubview:sureBtn];
    
//    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    telBtn.frame=CGRectMake(10, 280+(model.weixin.intValue==0?0:55), 270, 30);
//
//    telBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [telBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"提现后进度可在支出明细中查询提现进度!"];
//
//    [attributeStr addAttribute:NSForegroundColorAttributeName value: [UIColor redColor] range:NSMakeRange(0, attributeStr.length)];
    
//    [attributeStr addAttributes:@{NSForegroundColorAttributeName:GreenColor,NSFontAttributeName:FONT(15)} range:NSMakeRange(14, 12)];
//    [telBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
//    [telBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 280+(model.weixin.intValue==0?0:55), 270, 30)];
    label.text = @"提现后进度可在支出明细中查询提现进度!";
    label.textColor = [UIColor redColor];
    label.font = FONT(12);
    [self.tableView addSubview:label];
    
//    [self.tableView addSubview:telBtn];
    
//    [JGHTTPClient selectRealnameInfoByloginId:[JGUser user].login_id Success:^(id responseObject) {
//        
//        JGLog(@"%@",responseObject);
//        if ([responseObject[@"code"]integerValue] == 200) {
//            RealNameModel *model = [RealNameModel mj_objectWithKeyValues:[responseObject[@"data"] objectForKey:@"t_user_realname"]];
//            
//            JGUser *user = [JGUser user];
//            user.status = model.status;
//            [JGUser saveUser:user WithDictionary:nil loginType:0];
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

-(void)gotoSettingVC
{
    UnBindViewController *unBindVC = [[UnBindViewController alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    if (aliPayModel) {
        [array addObject:aliPayModel];
    }
    if (bankModel) {
        [array addObject:bankModel];
    }
    unBindVC.dataArr = array;
    aliPayModel = nil;
    bankModel = nil;
    [self.navigationController pushViewController:unBindVC animated:YES];
}

-(void)call
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"联系兼果客服" message:@"010-53350021" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [APPLICATION openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://010-53350021"]]];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [JGHTTPClient getBindInfoSuccess:^(id responseObject) {
        if ([responseObject[@"code"]integerValue] == 200) {
            
            if ([responseObject[@"data"] count]) {
                self.btn_r.hidden = NO;
                for (NSDictionary *dic in responseObject[@"data"]) {
                    if ([dic[@"type"] integerValue] == 1) {//银行卡
                        bankModel = [WalletModel mj_objectWithKeyValues:dic[@"entity"]];
                        bankModel.type = dic[@"type"];
                    }else if ([dic[@"type"] integerValue] == 2){//支付宝
                        aliPayModel = [WalletModel mj_objectWithKeyValues:dic[@"entity"]];
                        aliPayModel.type = dic[@"type"];
                    }
                }
            }else{
                self.btn_r.hidden = YES;
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55;
    }else{
        return 90;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section?35:20;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!section) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 270, 35)];
        label.text = @"  请务必核实输入信息,避免给您带来财务损失!";
        label.textColor = [UIColor redColor];
        label.font = FONT(12);
        return label;
    }else
        return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    WalletModel *model = [WalletModel wallet];
    return section == 0 ? (model.weixin.intValue==0 ? 2:3):1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.drawCashType = nil;
    if(indexPath.section == 0){
        static NSString *identifier = @"BindCell";
        BindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BindCell" owner:nil options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.unBindBtn.hidden= YES;
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.iconView.image = [UIImage imageNamed:@"aliPay"];
            cell.bindTypeL.text = @"支付宝";
            if (aliPayModel) {
                cell.bindStateL.text = aliPayModel.receive_name;
                cell.jiantouView.hidden = YES;
                cell.selectView.hidden = NO;
                self.alipayView = cell.selectView;
            }else{
                cell.bindStateL.text = @"未绑定";
                cell.jiantouView.hidden = NO;
                cell.selectView.hidden = YES;
            }
        }else if (indexPath.row == 1){
            
            cell.iconView.image = [UIImage imageNamed:@"card"];
            cell.bindTypeL.text = @"银行卡";
            if (bankModel) {
                cell.bindStateL.text = bankModel.name;
                cell.jiantouView.hidden = YES;
                cell.selectView.hidden = NO;
                self.bankCarfView = cell.selectView;
            }else{
                cell.bindStateL.text = @"未绑定";
                cell.jiantouView.hidden = NO;
                cell.selectView.hidden = YES;
            }
        }else if (indexPath.row == 2){
            
            cell.iconView.image = [UIImage imageNamed:@"wx"];
            cell.bindTypeL.text = @"微信";
            if (![WALLET.weixin isEqualToString:@"0"]) {
//                cell.bindStateL.text = WALLET.nickname;
                cell.jiantouView.hidden = YES;
                cell.selectView.hidden = NO;
                self.weixinView = cell.selectView;
            }else{
                cell.bindStateL.text = @"未绑定";
            }
        }
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 25)];
        label.text = @"提现金额:";
        label.font = FONT(14);
        [cell.contentView addSubview:label];
        UITextField *countTF = [[UITextField alloc] initWithFrame:CGRectMake(label.right, 10, SCREEN_W-100, 25)];
        countTF.font = FONT(14);
        countTF.placeholder = [NSString stringWithFormat:@"本次最大提取金额%.2f元",self.sumMoney.floatValue];
        [countTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        countTF.delegate = self;
        countTF.keyboardType = UIKeyboardTypeDecimalPad;
        [cell.contentView addSubview:countTF];
        self.countTF = countTF;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_W, 1)];
        lineView.backgroundColor = BACKCOLORGRAY;
        [cell.contentView addSubview:lineView];
        
        UITextField *phoneTf = [[UITextField alloc] initWithFrame:CGRectMake(label.left, 50, SCREEN_W-40, 40)];
        phoneTf.placeholder = @"请输入您收到的验证码";
        //        phoneTf.delegate = self;
        phoneTf.keyboardType = UIKeyboardTypeDecimalPad;
        [phoneTf addTarget:self action:@selector(ensureRightInPut:) forControlEvents:UIControlEventEditingChanged];
        phoneTf.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:phoneTf];
        self.phoneTf = phoneTf;
        
        UIButton *getCodeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        getCodeBtn.layer.masksToBounds = YES;
        getCodeBtn.layer.cornerRadius = 5;
        getCodeBtn.titleLabel.font = FONT(14);
        getCodeBtn.frame = CGRectMake(SCREEN_W-90, 55, 60, 25);
        [getCodeBtn setTitle:@"验证码" forState:UIControlStateNormal];
        [getCodeBtn addTarget:self action:@selector(getCodeByPhoneNum:) forControlEvents:UIControlEventTouchUpInside];
        [getCodeBtn setBackgroundColor:GreenColor];
        [cell.contentView addSubview:getCodeBtn];
        self.getCodeBtn = getCodeBtn;
        
        
        return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BindCell *cell = (BindCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    self.alipayView.image = [UIImage imageNamed:@"icon_weixuanzhongda"];
    self.bankCarfView.image = [UIImage imageNamed:@"icon_weixuanzhongda"];
    self.weixinView.image = [UIImage imageNamed:@"icon_weixuanzhongda"];
    self.drawCashType = nil;
    
    if (indexPath.section == 1) {
        return;
    }

    if (indexPath.row == 0) {//绑定支付宝
        
        if (aliPayModel) {
            self.drawCashType = @"2";
            self.pay_type_id = aliPayModel.id;
            cell.selectView.image = [UIImage imageNamed:@"mark"];
        }else{
            
            BindAliPayViewController *alipayVC = [[BindAliPayViewController alloc] init];
            [self.navigationController pushViewController:alipayVC animated:YES];
            
        }
        
    }else if (indexPath.row == 1){//绑定银行卡
        if (bankModel) {
            
            self.drawCashType = @"1";
            self.pay_type_id = bankModel.id;
            cell.selectView.image = [UIImage imageNamed:@"mark"];
        }else{
            
            BindCardViewController *cardVC = [[BindCardViewController alloc] init];
            [self.navigationController pushViewController:cardVC animated:YES];
            
        }
        
    }else if (indexPath.row == 2){//绑定微信
        
        
        if ([WALLET.weixin isEqualToString:@"0"]) {//未绑定
            //请求微信授权
            [self bindWeiXin];
        }else{//已绑定了微信
            
        }
        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)bindWeiXin
{
    
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         
         if (state == SSDKResponseStateSuccess)
         {
             JGLog(@"rawData = %@",user.rawData);
             JGLog(@"uid=%@",user.uid);//就是微信的 openid
             JGLog(@"%@",user.credential);
             JGLog(@"token=%@",user.credential.token);
             JGLog(@"nickname=%@",user.nickname);
             JGLog(@"iConUrl = %@",user.icon)
             
             JGSVPROGRESSLOAD(@"正在请求...");
             [JGHTTPClient bindweixinByloginId:USER.login_id openid:user.uid nickname:user.nickname sex:user.rawData[@"sex"] province:user.rawData[@"province"] city:user.rawData[@"city"] country:user.rawData[@"country"] headimgurl:user.icon privilege:nil unionid:user.rawData[@"unionid"] Success:^(id responseObject) {
                 [SVProgressHUD dismiss];
                 if ([responseObject[@"code"] intValue ] == 200) {
                     [self showAlertViewWithText:@"绑定微信成功" duration:1];
                 }
             } failure:^(NSError *error) {
                 [SVProgressHUD dismiss];
                 [self showAlertViewWithText:NETERROETEXT duration:1];
             }];
             
         }
         
         else
         {
             [self showAlertViewWithText:@"微信授权失败" duration:1];
         }
         
     }];
}

-(void)sureGetCash
{
   
    [self.view endEditing:YES];
    if (!self.drawCashType) {
        [self showAlertViewWithText:@"请选择提现方式" duration:1];
        return;
    }else if ([self.countTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].floatValue==0) {
        [self showAlertViewWithText:@"请填写提现金额" duration:1];
        return;
    }else if (self.countTF.text.floatValue>self.sumMoney.floatValue) {
        [self showAlertViewWithText:@"超出余额" duration:1];
        return;
    }else if (self.phoneTf.text.length==0) {
        [self showAlertViewWithText:@"请您输入验证码！" duration:1];
        return;
    }
    
    if (!isShowAlert) {
        
    }
    
    IMP_BLOCK_SELF(GetCashViewController)
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:USER.login_id forKey:@"pay_user_id"];

    [dict setObject:self.countTF.text forKey:@"money"];
    [dict setObject:self.pay_type_id forKey:@"pay_type_id"];//支付宝还是银行卡
    [dict setObject:@"3" forKey:@"type"];//表示是  提现
    
    [self.jsonArr addObject:dict];//TODO:
    


    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.jsonArr
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    [SVProgressHUD showWithStatus:@"正在提交申请..." maskType:SVProgressHUDMaskTypeClear];
    [JGHTTPClient PayWageByCode:self.phoneTf.text jsonStr:jsonStr Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [block_self showAlertViewWithText:responseObject[@"message"] duration:1];
        
        if ([responseObject[@"code"] intValue] == 200) {
            
            
            [QLAlertView showAlertTittle:@"提现成功!" message:@"尊敬的用户，您当前的提现申请将会在 24小时内 为您处理，请您耐心等待提现结果，给您带来的不便，敬请谅解!\n\n您可以到【我的钱包】––>【支出明细】中查看提现进度!!!" isOnlySureBtn:YES compeletBlock:^{
                
                
                BillsViewController *billVC = [[BillsViewController alloc] init];
                billVC.hidesBottomBarWhenPushed = YES;
                billVC.type = @"2";
                billVC.isFromGetCash = YES;
                billVC.navigationItem.title = @"支出明细";
                [self.navigationController pushViewController:billVC animated:YES];
//                    [block_self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            block_self.countTF.text = nil;
            
        }else{
            [block_self showAlertViewWithText:responseObject[@"message"] duration:1];
        }

        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [block_self showAlertViewWithText:NETERROETEXT duration:1];

    }];

}

-(void)clickBtnOfCell:(UIButton *)btn
{
    BindCell *cell = (BindCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
//    self.alipayView.image = [UIImage imageNamed:@"icon_weixuanzhongda"];
//    self.bankCarfView.image = [UIImage imageNamed:@"icon_weixuanzhongda"];
//    self.weixinView.image = [UIImage imageNamed:@"icon_weixuanzhongda"];
//    self.drawCashType = nil;
//    
//    if (indexPath.row == 0) {//绑定支付宝
//        if (![WALLET.zhifubao isEqualToString:@"0"]) {
//            self.drawCashType = @"0";
//            cell.selectView.image = [UIImage imageNamed:@"icon_xuanzhongda"];
//        }
//        
//    }else if (indexPath.row == 1){//绑定银行卡
//        if (![WALLET.yinhang isEqualToString:@"0"]) {
//            self.drawCashType = @"1";
//            cell.selectView.image = [UIImage imageNamed:@"icon_xuanzhongda"];
//        }
//        
//    }else if (indexPath.row == 2){//绑定微信
//        if (![WALLET.weixin isEqualToString:@"0"]) {
//            self.drawCashType = @"2";
//            cell.selectView.image = [UIImage imageNamed:@"icon_xuanzhongda"];
//        }
//        
//    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
/**
 *  获取验证码
 */
-(void)getCodeByPhoneNum:(UIButton *)getCodeBtn
{
    
    [SVProgressHUD showWithStatus:@"让验证码飞一会儿" maskType:SVProgressHUDMaskTypeNone];
    [self.getCodeBtn setBackgroundColor:RGBACOLOR(200, 200, 200, 1)];
    self.getCodeBtn.userInteractionEnabled = NO;
    _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
    
    
    [JGHTTPClient getAMessageAboutCodeByphoneNum:USER.tel type:@"4" Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject[@"code"]);
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [self showAlertViewWithText:@"验证码已成功发送!" duration:1];
            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

/**
 *  监听textEield的输入
 *
 *  @param textField 输入框
 */
-(void)ensureRightInPut:(UITextField *)textField
{
    if (self.phoneTf.text.length>6) {
        self.phoneTf.text = [self.phoneTf.text substringToIndex:6];
    }
    
}

-(void)changeSeconds
{
    count--;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%d S",count] forState:UIControlStateNormal];
    if (count == 0) {
        [_timer invalidate];
        count = SECONDCOUNT;
        [self.getCodeBtn setTitle:@"验证" forState:UIControlStateNormal];
        [self.getCodeBtn setBackgroundColor:GreenColor ];
        self.getCodeBtn.userInteractionEnabled = YES;
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

-(void)textChanged:(UITextField *)textFiled
{
    if (self.countTF == textFiled) {
        
        NSInteger length = textFiled.text.length;
        
        if (length>1) {
            if ([[textFiled.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]||[[textFiled.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]) {
                textFiled.text = nil;
            }
        }
        
        if (length>4) {
            NSString *string = [textFiled.text substringWithRange:NSMakeRange(length-4, 1)];
            if ([string isEqualToString:@"."] ) {
                textFiled.text = [textFiled.text substringToIndex:length-1];
            }
        }
    }
}

//键盘出现
-(void)keyboardWillShow:(NSNotification *)noti
{
    // 取出键盘最终的frame
//    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
//     取出键盘弹出需要花费的时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//     修改transform
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.tableView.frame;
        [self.tableView setFrame:CGRectMake(0, -100, frame.size.width, frame.size.height)];
        }];
    
}
//键盘消失
-(void)keyboardWillHidden:(NSNotification *)noti
{
    // 取出键盘最终的frame
//    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //     取出键盘弹出需要花费的时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //     修改transform
    [UIView animateWithDuration:duration animations:^{
        
//        self.view.transform = CGAffineTransformIdentity;
        CGRect frame = self.tableView.frame;
        [self.tableView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
    }];
}

-(void)dealloc
{
    [NotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
