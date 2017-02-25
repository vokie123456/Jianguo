//
//  EditInfoViewController.m
//  JianGuo
//
//  Created by apple on 17/2/13.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "EditInfoViewController.h"
#import "JianliCell.h"
#import "UITextView+placeholder.h"
#import "DemandTypeView.h"
#import "PickerView.h"
#import "JGHTTPClient+Mine.h"
#import "JianliAccount.h"

@interface EditInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    JianliAccount *account;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UITextView *introduceTV;
@property (nonatomic,strong) UITextField *nickNameTF;
@property (nonatomic,strong) UITextField *sexTF;
@property (nonatomic,strong) UITextField *starTF;
@property (nonatomic,strong) UITextField *birthDateTF;
@property (nonatomic,strong) UITextField *QQTF;
@property (nonatomic,copy) NSString *starSet;
@property (nonatomic,copy) NSString *sex;

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    
    UIButton * btn_l = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_l setTitle:@"取消" forState:UIControlStateNormal];
    [btn_l addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btn_l.frame = CGRectMake(0, 0, 40, 30);
    
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_l];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setTitle:@"保存" forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 40, 30);
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    JGSVPROGRESSLOAD(@"正在拼命加载中...");
    [JGHTTPClient getJianliInfoByloginId:[JGUser user].login_id Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject);
        if (responseObject) {
            
            account = [JianliAccount mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self.tableView reloadData];
        }

        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
    
}

-(void)save
{
    JGSVPROGRESSLOAD(@"正在上传...");
    [JGHTTPClient uploadUserJianliInfoByname:self.nickNameTF.text nickName:nil iconUrl:nil sex:self.sex height:nil schoolId:nil cityId:nil areaId:nil inSchoolTime:nil birthDay:self.birthDateTF.text constellation:self.starTF.text introduce:self.introduceTV.text qq:self.QQTF.text isStudent:nil Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        if ([responseObject[@"code"] integerValue]== 200) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 80;
    }
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JianliCell *cell = [JianliCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelLeft.text = @"昵称";
        cell.rightTf.placeholder = @"尊姓大名";
        cell.jiantouView.hidden = YES;
        cell.rightTf.userInteractionEnabled = YES;
        self.nickNameTF = cell.rightTf;
        if (account) {
            self.nickNameTF.text = account.nickname;
        }
    }else if (indexPath.row == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelLeft.text = @"性别";
        cell.jiantouView.hidden = YES;
        self.sexTF = cell.rightTf;
        if (account) {
            self.sex = account.sex;
            if (account.sex.integerValue == 2) {
                cell.rightTf.text = @"男";
            }else if (account.sex.integerValue == 1){
                cell.rightTf.text = @"女";
            }
        }
        cell.rightTf.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if (indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelLeft.text = @"星座";
        cell.rightTf.placeholder = @"是处女座吗?";
        cell.jiantouView.hidden = YES;
        cell.rightTf.userInteractionEnabled = NO;
        self.starTF = cell.rightTf;
        if (account) {
           NSArray *array = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
            self.starSet = account.constellation;
            cell.rightTf.text = account.constellation;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 3){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelLeft.text = @"出生日期";
        cell.rightTf.placeholder = @"您出生的日子是哪天?";
        cell.jiantouView.hidden = YES;
        cell.rightTf.userInteractionEnabled = NO;
        self.birthDateTF = cell.rightTf;
        if (account) {
            cell.rightTf.text = account.birth_date;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 4){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelLeft.text = @"QQ";
        cell.rightTf.placeholder = @"留下您的QQ号,交到更多朋友";
        cell.jiantouView.hidden = YES;
        cell.rightTf.userInteractionEnabled = YES;
        self.QQTF = cell.rightTf;
        if (account) {
            cell.rightTf.text = account.qq;
        }
    }else if (indexPath.row == 5) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelLeft.text = @"个性签名";
        cell.jiantouView.hidden = YES;
        [cell.rightTf removeFromSuperview];
        [cell.lineView removeFromSuperview];
        UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(cell.labelLeft.right-5, 5, SCREEN_W-cell.labelLeft.right-10, 70)];
        textV.backgroundColor = BACKCOLORGRAY;
        textV.font = FONT(15);
        textV.placeholder = @"一段介绍你自己的文字";
        [cell.contentView addSubview:textV];
        self.introduceTV = textV;
        if (account) {
            textV.text = account.introduce;
            textV.placeholder = nil;
        }
        
    }
        
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1){//选择性别
        PickerView *pickerView = [PickerView aPickerView:^(NSString *sex) {
            if ([sex isEqualToString:@"男"]) {
                self.sex = @"2";
            }else if ([sex isEqualToString:@"女"]){
                self.sex = @"1";
            }
            self.sexTF.text = sex;
        }];
        pickerView.arrayData = @[@"男",@"女"];
        [pickerView show];
        
    }else if (indexPath.row == 2) {//选择星座
        DemandTypeView *view = [DemandTypeView demandTypeViewselectBlock:^(NSInteger index, NSString *title) {
            self.starTF.text = title;
            self.starSet = [NSString stringWithFormat:@"%ld",index];
        }];
        view.titleArr = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
    }else if (indexPath.row == 3){//生日
        PickerView *pickerView = [PickerView aPickerView:^(NSString *inSchoolTime) {
            self.birthDateTF.text = inSchoolTime;
        }];
        pickerView.isDatePicker = YES;
        pickerView.initalDateStr = @"1998-01-01";
        [pickerView show];
    }
    
}



@end
