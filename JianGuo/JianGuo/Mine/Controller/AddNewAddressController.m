//
//  AddNewAddressController.m
//  QQMarket
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddNewAddressController.h"
#import "UITextView+placeholder.h"
#import "JGHTTPClient+Address.h"
//#import "SelectAddressController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

@interface AddNewAddressController ()<CNContactPickerDelegate>
{
    CNContactPickerViewController *pickerVC;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *addressL;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;//男性
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;//女性
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextView *doorNoTV;
@property (weak, nonatomic) IBOutlet UISwitch *sw;


@property (nonatomic, copy) NSString* isDefault; //!< 纬度（垂直方向）
@property (nonatomic, copy) NSString* addressId; //!< 经度（水平方向）


@end

@implementation AddNewAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加收货地址";
    self.doorNoTV.placeholder = @"请输入您的收货地址";
    _sw.transform = CGAffineTransformMakeScale( 0.8, 0.8);//缩放
    
    self.addressId = [NSString stringWithFormat:@"%ld",self.model.id];
    self.isDefault = @"0";
    
    if (self.model) {
        self.title = @"编辑地址";
        self.nameTF.text = self.model.consignee;
        self.phoneTF.text = self.model.mobile;
        self.doorNoTV.text = self.model.location;
        self.doorNoTV.placeholder = nil;
        if (self.model.isDefault) {
            [self.sw setOn:YES];
            self.isDefault = @"1";
        }else{
            self.isDefault = @"0";
        }
    }
    
}


- (IBAction)saveNewAddress:(UIButton *)sender {
    
    if (![self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length){
        [self showAlertViewWithText:@"请填写收货人姓名" duration:1];
        return;
    }else if (![self.phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length){
        [self showAlertViewWithText:@"请填写收货人电话" duration:1];
        return;
    }else if (![self.doorNoTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length){
        [self showAlertViewWithText:@"请填写具体收货地址" duration:1];
        return;
    }
    
    [JGHTTPClient saveOrUpdateAddresWithContactName:self.nameTF.text tel:self.phoneTF.text location:self.doorNoTV.text isDefault:self.isDefault addressId:self.addressId Success:^(id responseObject) {
        
        [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
        if ([responseObject[@"code"]integerValue] == 200) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:2];
    }];
    
    
    
}

- (IBAction)switchAction:(UISwitch *)sender {
    
    if (sender.isOn) {
        JGLog(@"打开了/...");
        self.isDefault = @"1";
    }else{
        JGLog(@"关闭了/...");
        self.isDefault = @"0";
    }
    
}

- (IBAction)AccessAddressBook:(UIButton *)sender
{
    
    pickerVC = [[CNContactPickerViewController alloc] init];
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNPhoneNumber *phoneNumber = contactProperty.value;
    
    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];//invertedSet去反字符,即把 [非 @"0123456789" 里的字符]的字符找出来 组合成一个字符集合
    NSString *tel = [[phoneNumber.stringValue componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    
    self.phoneTF.text = tel;
}

@end
