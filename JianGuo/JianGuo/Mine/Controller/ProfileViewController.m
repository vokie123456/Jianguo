//
//  ProfileViewController.m
//  JianGuo
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "ProfileViewController.h"
#import "QNUploadManager.h"
#import "JianliCell.h"
#import "UITextView+placeholder.h"
#import "DemandTypeView.h"
#import "PickerView.h"
#import "SearchSchoolViewController.h"
#import "SchoolModel.h"
#import "JGHTTPClient+Mine.h"
#import "CityModel.h"
#import "QLTakePictures.h"
#import "MineChatCell.h"

#define scrollViewHeight 300

#define iconWidth 80

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentIndex;
    
    QLTakePictures *takePic;
    
}
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UITextField *nickNameTF;
@property (nonatomic,strong) UITextField *sexTF;
@property (nonatomic,strong) UITextField *birthDateTF;
@property (nonatomic,strong) UITextField *isStudentTF;
@property (nonatomic,strong) UITextField *addressTF;
@property (nonatomic,strong) UITextField *schoolTF;
@property (nonatomic,strong) UITextField *intoSchoolTimeTF;
@property (nonatomic,strong) UITextField *QQTF;
@property (nonatomic,strong) UITextView *introduceTF;
@property (nonatomic,strong) UIButton *iconBtn;


@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *schoolId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *areaId;
@property (nonatomic,copy) NSString *starSet;
@property (nonatomic,copy) NSString *isStudent;

@end

@implementation ProfileViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"填写基本资料";
    
    self.tableView.estimatedRowHeight = 44;
    
    [self.view addSubview:self.tableView];
    
    [self.view bringSubviewToFront:self.nextBtn];
    
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setTitle:@"确定" forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(commitInfo) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 40, 30);
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)takePhoto
{
    takePic = [QLTakePictures aTakePhotoAToolWithComplectionBlock:^(UIImage *image) {
        [self.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
        takePic = nil;//防止循环引用,导致 takePic 释放不了
    }];
    takePic.VC = self;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 3){
        return 80;
    }
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1 || section == 2){
        return 3;
    }else
        return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JianliCell *cell = [JianliCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame = CGRectMake(SCREEN_W/2-iconWidth/2, 20, iconWidth, iconWidth);
        [iconBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        [iconBtn setBackgroundImage:[UIImage imageNamed:@"myicon"] forState:UIControlStateNormal];
        iconBtn.layer.cornerRadius = iconWidth/2;
        iconBtn.layer.masksToBounds = YES;
        [cell.contentView addSubview:iconBtn];
        self.iconBtn = iconBtn;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iconBtn.bottom+10, SCREEN_W, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = LIGHTGRAYTEXT;
        label.font = FONT(14);
        label.text = @"请上传您的头像";
        [cell.contentView addSubview:label];
        
        return cell;
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"姓名";
            cell.rightTf.placeholder = @"尊姓大名";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = YES;
            self.nameTF = cell.rightTf;

        }else if (indexPath.row == 1){
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"性别";
            cell.rightTf.placeholder = @"您是男生还是女神?";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.sexTF = cell.rightTf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.labelLeft.text = @"性别";
//            cell.jiantouView.hidden = YES;
//            cell.rightTf.userInteractionEnabled = NO;
//            cell.selectYes.hidden = NO;
//            cell.selectNo.hidden = NO;
//            cell.selectNo.labeYysOrNo.text = @"我是女神";
//            cell.selectYes.labeYysOrNo.text = @"我是男神";
//            //用户性别(男=2,女=1)
//            cell.seletIsStudentBlock = ^(NSString *sex){
//                self.sex = sex;
//            };
            
        }else if (indexPath.row == 2){
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"出生日期";
            cell.rightTf.placeholder = @"您出生的日子是哪天?";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.birthDateTF = cell.rightTf;
            cell.lineView.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"是否学生";
            cell.rightTf.placeholder = @"您还在象牙塔里吗?";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.isStudentTF = cell.rightTf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }else if (indexPath.row == 1){
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"所在学校";
            cell.rightTf.placeholder = @"您在哪所大学学习?";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.schoolTF = cell.rightTf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 2){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"入学时间";
            cell.rightTf.placeholder = @"请选择您的入学时间";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.intoSchoolTimeTF = cell.rightTf;
            cell.lineView.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section == 3){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelLeft.text = @"我的特长";
        cell.jiantouView.hidden = YES;
        [cell.rightTf removeFromSuperview];
        [cell.lineView removeFromSuperview];
        UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(cell.labelLeft.right-5, 5, SCREEN_W-cell.labelLeft.right-10, 70)];
        textV.backgroundColor = BACKCOLORGRAY;
        textV.font = FONT(15);
        textV.placeholder = @"描述您的特长,例如:编程序,做PPT...";
        [cell.contentView addSubview:textV];
        self.introduceTF = textV;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section == 1 ) {
        
        if (indexPath.row == 1) {//性别
            DemandTypeView *view = [DemandTypeView demandTypeViewselectBlock:^(NSInteger index, NSString *title) {
                self.sexTF.text = title;
                self.sex = [NSString stringWithFormat:@"%ld",index];
            }];
            view.titleArr = @[@"女神",@"男神"];
        }else if (indexPath.row == 2){//出生日期
            PickerView *pickerView = [PickerView aPickerView:^(NSString *inSchoolTime) {
                self.birthDateTF.text = inSchoolTime;
            }];
            pickerView.isDatePicker = YES;
            pickerView.initalDateStr = @"1998-01-01";
            [pickerView show];
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {//是否是学生
            DemandTypeView *view = [DemandTypeView demandTypeViewselectBlock:^(NSInteger index, NSString *title) {
                self.isStudentTF.text = title;
                self.isStudent = [NSString stringWithFormat:@"%ld",index];
            }];
            view.titleArr = @[@"是",@"否"];
        }else if (indexPath.row == 1){//所在学校
            
            SearchSchoolViewController *searchVC = [[SearchSchoolViewController alloc] init];
            
            searchVC.seletSchoolBlock = ^(SchoolModel *school){
                self.schoolTF.text = school.name;
                self.schoolId = school.id;
            };
            
            [self.navigationController pushViewController:searchVC animated:YES];
            
        }else if (indexPath.row == 2){//入学时间
            PickerView *pickerView = [PickerView aPickerView:^(NSString *inSchoolTime) {
                self.intoSchoolTimeTF.text = inSchoolTime;
            }];
            pickerView.isDatePicker = YES;
            pickerView.initalDateStr = @"2016-09-01";
            [pickerView show];
            
        }
    }
}

- (IBAction)next:(UIButton *)sender {
    
    if (self.nameTF.text.length==0) {
        [self showAlertViewWithText:@"请填写您的姓名" duration:1];
        return;
    }else if (self.sex.length==0){
        [self showAlertViewWithText:@"请选择您的性别" duration:1];
        return;
    }else if (self.nickNameTF.text.length==0){
        [self showAlertViewWithText:@"请给自己一个昵称" duration:1];
        return;
    }else if (self.starSet.length==0){
        [self showAlertViewWithText:@"请选择您的星座" duration:1];
        return;
    }else if (self.birthDateTF.text.length==0){
        [self showAlertViewWithText:@"请选择您的出生日期" duration:1];
        return;
    }else if (self.addressTF.text.length==0) {
        [self showAlertViewWithText:@"请选择您所在的地址" duration:1];
        return;
    }else if (self.schoolTF.text.length==0){
        [self showAlertViewWithText:@"请选择您的大学" duration:1];
        return;
    }else if (self.intoSchoolTimeTF.text.length==0){
        [self showAlertViewWithText:@"请选择您的入学时间" duration:1];
        return;
    }else if (self.QQTF.text.length==0) {
    [self showAlertViewWithText:@"留下您的QQ号吧" duration:1];
    return;
    }
    
    [self commitInfo];
    
}

-(void)commitInfo
{
    
    JGSVPROGRESSLOAD(@"上传中...")
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    
    NSData *data = UIImageJPEGRepresentation(self.iconBtn.currentBackgroundImage, 1);
    [manager putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp == nil) {
            [SVProgressHUD dismiss];
            [self showAlertViewWithText:@"上传图片失败" duration:1];
            return ;
        }else{//上传图片成功后再上传个人资料
            
            NSString *url = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
            
            
            [JGHTTPClient uploadUserJianliInfoByname:nil nickName:self.nameTF.text iconUrl:url sex:self.sex height:nil schoolId:self.schoolId cityId:self.cityId areaId:self.areaId inSchoolTime:self.intoSchoolTimeTF.text birthDay:self.birthDateTF.text constellation:nil introduce:self.introduceTF.text qq:self.QQTF.text isStudent:self.isStudent Success:^(id responseObject) {//是不是学生这个字段在业务上不要了
                
                [SVProgressHUD dismiss];
                JGLog(@"%@",responseObject);
                if (responseObject) {
                    [self showAlertViewWithText:responseObject[@"message"] duration:1];
                }
                if ([responseObject[@"code"] intValue] == 200) {
                    
                    JGUser *user = [JGUser user];
                    user.resume = @"1";
                    user.nickname = self.nameTF.text;
                    user.gender = self.sex;
                    user.schoolId = self.schoolId;
                    user.iconUrl = url;
                    user.birthDay = self.birthDateTF.text;
                    [JGUser saveUser:user WithDictionary:nil loginType:0];
                    
                    [NotificationCenter postNotificationName:kNotificationLoginSuccessed object:nil];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                
                
            } failure:^(NSError *error) {
                
                [SVProgressHUD dismiss];
                [self showAlertViewWithText:NETERROETEXT duration:1];
                
            }];
            
        }
        
    } option:nil];

}

/**
 *  返回上一级页面
 */
-(void)popToLoginVC
{

    [self.navigationController popViewControllerAnimated:YES];
    
}




@end
