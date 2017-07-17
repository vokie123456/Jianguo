//
//  EditProfileViewController.m
//  JianGuo
//
//  Created by apple on 17/6/21.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EditingInfoViewController.h"
#import "ConfirmSchoolViewController.h"
#import "SearchSchoolViewController.h"
#import "RealNameNewViewController.h"

#import "JGHTTPClient+Mine.h"

#import "SchoolModel.h"
#import "EditUserModel.h"


#import "EditProfileCell.h"
#import "TextFieldCell.h"

#import "PickerView.h"
#import "DemandTypeView.h"
#import "TZImagePickerController.h"
#import "QNUploadManager.h"
#import "UIImageView+WebCache.h"
#import "QLAlertView.h"

static CGFloat const sectionHeaderHeight = 50.f;

@interface EditProfileViewController ()<UITableViewDataSource,UITableViewDelegate,TZImagePickerControllerDelegate>
{
    BOOL isSelectNewPicture;
    EditUserModel *model;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) UIImageView *iconView;

/** 城市id */
@property (nonatomic,strong) NSString *cityCode;
/** 学校id */
@property (nonatomic,copy) NSString *schoolId;
/** 性别 */
@property (nonatomic,copy) NSString *gender;
/** 昵称 */
@property (nonatomic,strong) NSString *nickName;
/** 生日 */
@property (nonatomic,strong) NSString *birthDay;
/** 入学时间 */
@property (nonatomic,strong) NSString *intoSchoolTime;
/** 简介 */
@property (nonatomic,strong) NSString *introduce;
/** 头像 */
@property (nonatomic,strong) NSString *headImg;


@end

@implementation EditProfileViewController

-(NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //拉取自己的资料信息
    [self getMyProfile];
    
    self.navigationItem.title = @"编辑资料";
    
    
    
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setTitle:@"保存" forState:UIControlStateNormal];
    [btn_r setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 40, 30);
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.tableView.rowHeight = 44;
    
}

-(void)getMyProfile
{
    JGSVPROGRESSLOAD(@"加载中...");
    [JGHTTPClient getMyselfProfileWithUserId:USER.login_id Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        model = [EditUserModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, sectionHeaderHeight)];
    sectionHeaderView.backgroundColor = WHITECOLOR;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_W-20, sectionHeaderView.height-1)];
    label.textColor = LIGHTGRAYTEXT;
    label.text = section?@"认证信息": @"基本资料";
    label.font = [UIFont boldSystemFontOfSize:16.f];
    [sectionHeaderView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeaderView.height-1, SCREEN_W, 1)];
    line.backgroundColor = BACKCOLORGRAY;
    [sectionHeaderView addSubview:line];
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return sectionHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return !section?10:0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section?2:8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EditProfileCell *cell = [EditProfileCell cellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.iconView.image = [UIImage imageNamed:@"emotion"];
            self.iconView = cell.iconView;
            cell.iconView.hidden = NO;
            cell.rightL.hidden = YES;
            
            if (model) {
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"myicon"]];
                self.headImg = model.headImg;
            }
            
        }else if (indexPath.row == 1){
            cell.leftL.text = @"昵称";
            if (model) {
                cell.rightL.text = model.nickname;
                self.nickName = model.nickname;
            }
        }else if (indexPath.row == 2){
            cell.leftL.text = @"性别";
            if (model) {
                cell.rightL.text = model.sex.integerValue == 1?@"女神":@"男神";
                self.gender = model.sex;
            }
        }else if (indexPath.row == 3){
            cell.leftL.text = @"生日";
            if (model) {
                cell.rightL.text = model.birthDate;
                self.birthDay = model.birthDate;
            }
        }else if (indexPath.row == 4){
            cell.leftL.text = @"家乡";
            if (model) {
                cell.rightL.text = model.hometown;
                self.cityCode = model.hometownCode;
            }
        }else if (indexPath.row == 5){
            cell.leftL.text = @"学校";
            if (model) {
                cell.rightL.text = model.schoolName;
                self.schoolId = model.schoolId;
            }
        }else if (indexPath.row == 6){
            cell.leftL.text = @"入学时间";
            if (model) {
                cell.rightL.text = model.intoSchoolDate;
                self.intoSchoolTime = model.intoSchoolDate;
            }
        }else if (indexPath.row == 7){
            cell.leftL.text = @"简介";
            if (model) {
                cell.rightL.text = model.introduce;
                self.introduce = model.introduce;
            }
            cell.lineView.hidden= YES;
        }
        return cell;
    }else{
        TextFieldCell *cell = [TextFieldCell aTextFieldCell];
        

        cell.txfName.delegate = self;
        cell.lblText.textColor = LIGHTGRAYTEXT;
        cell.txfName.borderStyle = UITextBorderStyleNone;
        cell.txfName.font = [UIFont systemFontOfSize:14];
        cell.txfName.enabled = NO;
        
        if (indexPath.row == 0) {
            cell.iconView.image = [UIImage imageNamed:@"icon_card"];
            cell.lblText.text = @"身份认证";
            cell.txfName.placeholder = @"已认证";
        }else if (indexPath.row == 1){
            cell.iconView.image = [UIImage imageNamed:@"icon_card"];
            cell.lblText.text = @"学校认证";
            cell.txfName.placeholder = @"一年内可进行2次学校认证";
        }

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        EditProfileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (indexPath.row == 0) {//点击换头像
            
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePickerVc.allowPickingVideo = NO;
            imagePickerVc.allowCrop = YES;
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }else if (indexPath.row == 1){//姓名
            
            EditingInfoViewController *editVC = [[EditingInfoViewController alloc] init];
            editVC.hidesBottomBarWhenPushed = YES;
            editVC.editCompletCallBack = ^(NSString *editStr){
                cell.rightL.text = editStr;
                self.nickName = editStr;
            };
            [self.navigationController pushViewController:editVC animated:YES];
            
        }else if (indexPath.row == 2){//性别
            
            if (model.sex.integerValue && USER.resume.integerValue != 0) {
                [self showAlertViewWithText:@"性别不能修改" duration:1.f];
                return;
            }
            
            [QLAlertView showAlertTittle:@"温馨提示" message:@"性别填写后不能修改!" isOnlySureBtn:YES compeletBlock:^{
                
                
                DemandTypeView *view = [DemandTypeView demandTypeViewselectBlock:^(NSInteger index, NSString *title) {
                    cell.rightL.text = title;
                    //                self.sexTF.text = title;
                    self.gender= [NSString stringWithFormat:@"%ld",index];
                }];
                view.titleArr = @[@"女神",@"男神"];
                
            }];
            return;
            
        }else if (indexPath.row == 3){//生日
            
            PickerView *pickerView = [PickerView aPickerView:^(NSString *birthDay) {
                self.birthDay = birthDay;
                cell.rightL.text = birthDay;
//                [mutableDict setObject:birthDay forKey:@"birthday"];
            }];
            pickerView.isDatePicker = YES;
            NSString *timeString = @"1997-01-01";
            pickerView.datePickerView.date = [self.formatter dateFromString:timeString];
            [pickerView show];
            
        }else if (indexPath.row == 4){//家乡
            
            PickerView *view = [PickerView aProvincePickerView:^(NSString *str, NSString *Id) {
                
                cell.rightL.text = str;

                self.cityCode = Id;
                
            }];
            view.isCityPicker = YES;
            [view show];
            
        }else if (indexPath.row == 5){//学校
            
            
            SearchSchoolViewController *searchVC = [[SearchSchoolViewController alloc] init];
            
            searchVC.seletSchoolBlock = ^(SchoolModel *school){
                
                cell.rightL.text = school.name;
//                [mutableDict setObject:school.name forKey:@"school"];
                self.schoolId = school.id;
//                self.hadSelectedSchool = YES;
                
            };
            
            [self.navigationController pushViewController:searchVC animated:YES];
            
        }else if (indexPath.row == 6){//入学时间
            
            PickerView *pickerView = [PickerView aPickerView:^(NSString *inSchoolTime) {
                self.intoSchoolTime = inSchoolTime;
                cell.rightL.text = inSchoolTime;
//                [mutableDict setObject:inSchoolTime forKey:@"time"];
            }];
            pickerView.isDatePicker = YES;
            NSString *timeString = @"2015-09-01";
            pickerView.datePickerView.date = [self.formatter dateFromString:timeString];
            [pickerView show];
            
        }else if (indexPath.row == 7){//简介
            
            EditingInfoViewController *editVC = [[EditingInfoViewController alloc] init];
            editVC.hidesBottomBarWhenPushed = YES;
            editVC.editCompletCallBack = ^(NSString *editStr){
                cell.rightL.text = editStr;
                self.introduce = editStr;
            };
            [self.navigationController pushViewController:editVC animated:YES];
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {//身份认证,跳转页面
            
            RealNameNewViewController *realNameVC = [[RealNameNewViewController alloc] init];
            realNameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:realNameVC animated:YES];
            return;
            
        }else if (indexPath.row == 1){//学校认证,跳转页面
            
            ConfirmSchoolViewController *confirmVC = [[ConfirmSchoolViewController alloc] init];
            confirmVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:confirmVC animated:YES];
            return;
            
        }
        
    }
    
    
}

-(void)saveInfo:(UIButton *)sender
{
    if (self.nickName.length ==0) {
        [self showAlertViewWithText:@"请填写您的昵称" duration:1];
        return;
    }else if (self.gender.integerValue==0){
        [self showAlertViewWithText:@"请选择您的性别" duration:1];
        return;
    }else if (self.birthDay.length==0){
        [self showAlertViewWithText:@"请选择您的生日" duration:1];
        return;
    }else if (self.cityCode.integerValue==0){
        [self showAlertViewWithText:@"请选择您的家乡" duration:1];
        return;
    }else if (self.schoolId.integerValue==0){
        [self showAlertViewWithText:@"请选择您的学校" duration:1];
        return;
    }else if (self.intoSchoolTime.length==0){
        [self showAlertViewWithText:@"请选择您的入学时间" duration:1];
        return;
    }
    
    if (isSelectNewPicture) {
        [self commitInfo];
    }else{
        [self uploadMyselfServer];
    }
}


-(void)commitInfo
{
    
    JGSVPROGRESSLOAD(@"上传中...")
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    
    NSData *data = UIImageJPEGRepresentation(self.iconView.image, 0.7);
    [manager putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp == nil) {
            [SVProgressHUD dismiss];
            [self showAlertViewWithText:@"上传图片失败" duration:1];
            return ;
        }else{//上传图片成功后再上传个人资料
            
            self.headImg = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
            
            [self uploadMyselfServer];
            
        }
        
    } option:nil];
    
}

-(void)uploadMyselfServer
{
    
    [JGHTTPClient editUserProfileWithCityCode:self.cityCode headImg:self.headImg introduce:self.introduce sex:self.gender birthDay:self.birthDay schoolId:self.schoolId nickName:self.nickName intoSchoolDate:self.intoSchoolTime Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject);
        if (responseObject) {
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
        if ([responseObject[@"code"] intValue] == 200) {
            
                                JGUser *user = [JGUser user];
                                user.resume = @"1";
            //                    user.nickname = self.nameTF.text;
            //                    user.gender = self.sex;
            //                    user.schoolId = self.schoolId;
            //                    user.iconUrl = url;
            //                    user.is_student = @"1";//1==是,2==不是
            //                    user.birthDay = self.birthDateTF.text;
                                [JGUser saveUser:user WithDictionary:nil loginType:0];
            //
            //                    [NotificationCenter postNotificationName:kNotificationLoginSuccessed object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];
}

#pragma mark TZImagePickerController Delegate
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    self.iconView.image = photos.firstObject;
    isSelectNewPicture = YES;
}

@end
