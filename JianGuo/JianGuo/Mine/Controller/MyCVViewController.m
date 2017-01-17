//
//  MyCVViewController.m
//  JianGuo
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MyCVViewController.h"
#import "JianliAccount.h"
#import "JianLiHeaderView.h"
#import "JianliCell.h"
#import "PickerView.h"
#import "JGHTTPClient+Mine.h"
#import "QiniuSDK.h"
#import "UIImageView+WebCache.h"
#import "SearchSchoolViewController.h"
#import "CheckBox.h"
#import "QLAlertView.h"
#import "GuideImageView.h"
#import "SchoolModel.h"
#import "StudentInfoCell.h"
#import "UITextView+placeholder.h"

#define ICONIMAGEDATA [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"icon.data"]

@interface MyCVViewController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    JianliAccount *account;
    BOOL isFirstViewWillAppear;
    BOOL isLoadDataFromNet;
    UIButton *editBtn;
    UIView *bigView;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *heightArr;

@property (nonatomic,strong) UITextField *nameTf;

@property (nonatomic,strong) UITextField *nickNameTf;

@property (nonatomic,strong) CheckBox *selectNo;

@property (nonatomic,strong) CheckBox *selectYes;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,copy) NSString *birthDay;

@property (nonatomic,copy) NSString *shoeSize;

@property (nonatomic,copy) NSString *clothSize;

@property (nonatomic,copy) NSString *height;

@property (nonatomic,copy) NSString *isStudent;

@property (nonatomic,copy) NSString *school;

@property (nonatomic,copy) NSString *intoSchoolTime;

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UITextField *sexTf;
@property (nonatomic,strong) UITextField *birthTf;
@property (nonatomic,strong) UITextField *shoeSizeTf;
@property (nonatomic,strong) UITextField *clothSizeTf;;
@property (nonatomic,strong) UITextField *heightTf;;
@property (nonatomic,strong) UITextField *schoolTf;
@property (nonatomic,strong) UITextField *inSchoolTiemTf;
@property (nonatomic,strong) NSDateFormatter *formatter;
@property (nonatomic,strong) UITextField *emailTf;;
@property (nonatomic,strong) UITextField *qqTf;
@property (nonatomic,strong) UITextView *introduceTF;

@end
@implementation MyCVViewController

-(UITextField *)schoolTf
{
    if (!_schoolTf) {
        _schoolTf = [[UITextField alloc] init];
        if (account) {
            _schoolTf.text = account.school_name;
        }
    }
    return _schoolTf;
}
-(UITextField *)inSchoolTiemTf
{
    if (!_inSchoolTiemTf) {
        _inSchoolTiemTf = [[UITextField alloc] init];
        if (account) {
            _inSchoolTiemTf.text = account.intoschool_date;
        }
    }
    return _inSchoolTiemTf;
}

-(NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}

-(NSMutableArray *)heightArr
{
    if (!_heightArr) {
        _heightArr = [[NSMutableArray alloc] init];
        for (int i=150; i<200; i++) {
            [_heightArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
    }
    return _heightArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self setHeaderView];
        _tableView.tableFooterView = nil;
        
    }
    return _tableView;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的资料";
    
    [self removeSwipeGestureRecognizer];
    
    [self customBackBtn];

    [self.view addSubview:self.tableView];
    
    self.isStudent = @"1";
    
//显示引导图片
    // 当前软件的版本号（从Info.plist中获得）
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
//    if (![[USERDEFAULTS objectForKey:NSStringFromClass([self class])]isEqualToString:currentVersion]) {
//
//        GuideImageView *imgView = [[GuideImageView alloc] initWithFrame:APPLICATION.keyWindow.bounds];
//        imgView.image = [UIImage imageNamed:@"img_Ziliao"];
//        imgView.userInteractionEnabled = YES;
//        imgView.count = 6;
//        [self.tabBarController.view addSubview:imgView];
//        
//        [USERDEFAULTS setObject:currentVersion forKey:NSStringFromClass([self class])];
//        [USERDEFAULTS synchronize];
//    }
    
    
}


/**
 *  自定义返回按钮
 */
-(void)customBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 12, 21);
    backBtn.showsTouchWhenHighlighted = YES;
    [backBtn addTarget:self action:@selector(popToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 40, 21);
    editBtn.showsTouchWhenHighlighted = YES;
    [editBtn addTarget:self action:@selector(canEditInfo:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = editItem;
}

/**
 *  返回上一级页面
 */
-(void)popToLoginVC
{
    if (editBtn.selected) {
        [QLAlertView showAlertTittle:@"资料还未保存,确定离开?" message:nil isOnlySureBtn:NO compeletBlock:^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];

        }];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

/**
 *  点击编辑按钮
 */
-(void)canEditInfo:(UIButton *)btn
{
    if (!btn.selected) { //编辑---->保存  此时可以编辑
        btn.selected = YES;
        [editBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        //使可编辑
        self.nameTf.userInteractionEnabled = YES;
        self.nickNameTf.userInteractionEnabled = YES;
        self.selectNo.userInteractionEnabled = YES;
        [self.nameTf becomeFirstResponder];
        self.selectYes.userInteractionEnabled = YES;
        self.selectNo.userInteractionEnabled = YES;
        self.introduceTF.userInteractionEnabled = YES;
        self.qqTf.userInteractionEnabled = YES;
        self.emailTf.userInteractionEnabled = YES;
        
    }else{//保存 ----> 编辑 下面的为 保存操作
        //保存请求
        [self saveBasicInfo:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    [self lookUserCVInfo];
}

-(void)lookUserCVInfo
{
    if (!isFirstViewWillAppear) {
        IMP_BLOCK_SELF(MyCVViewController)
        
        [SVProgressHUD showWithStatus:@"正在拼命加载中..." maskType:SVProgressHUDMaskTypeClear];
        [JGHTTPClient getJianliInfoByloginId:[JGUser user].login_id Success:^(id responseObject) {
            [SVProgressHUD dismiss];
            JGLog(@"%@",responseObject);
            if (responseObject) {
                account = [JianliAccount mj_objectWithKeyValues:responseObject[@"data"]];
                self.isStudent = account.is_student;
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:account.head_img_url] placeholderImage:[UIImage imageNamed:@"upload"]];
                JGUser *user = [JGUser user];
                user.gender = account.sex;
                user.iconUrl = account.head_img_url;
                [JGUser saveUser:user WithDictionary:nil loginType:0];
            }
            [block_self.tableView reloadData];
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self showAlertViewWithText:NETERROETEXT duration:1];
        }];
        isFirstViewWillAppear = YES;
    }
}

-(UIView *)setHeaderView
{
    CGFloat height;
    if (SCREEN_W == 320) {
        height = 203*(SCREEN_W/375)+35;
    }else if (SCREEN_W == 375){
        height = 203*(SCREEN_W/375);
    }else if (SCREEN_W == 414){
        height = 203*(SCREEN_W/375)-20;
    }
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_W, height-64)];
    
//    bgView.image = [UIImage imageNamed:@"img_bg"];
    bgView.backgroundColor = WHITECOLOR;
    
    bgView.userInteractionEnabled = YES;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.center.x-35, bgView.top+10, 70, 70)];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 35;
    iconView.userInteractionEnabled = YES;
    [bgView addSubview:iconView];
    [iconView sd_setImageWithURL:[NSURL URLWithString:[JGUser user].iconUrl] placeholderImage:[UIImage imageNamed:@"upload"]];
    self.iconView = iconView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iconView.bottom+10, SCREEN_W, 20)];
    label.text = @"点击上传头像";
    label.font = FONT(12);
    label.textColor = LIGHTGRAYTEXT;
    label.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:label];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = iconView.bounds;
    [iconBtn setBackgroundColor:[UIColor clearColor]];
    [iconBtn addTarget:self action:@selector(uploadIcon:) forControlEvents:UIControlEventTouchUpInside];
    [iconView addSubview:iconBtn];
    
    bigView = [[UIView alloc] initWithFrame:bgView.bounds];
    CGRect rect = bigView.frame;
    bigView.backgroundColor = BACKCOLORGRAY;
    rect.size.height += 15;
    bigView.frame = rect;
    
    [bigView addSubview:bgView];
    
    return bigView;
    
}

#pragma mark  tableView的代理函数

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0||section == 1||section == 2) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
        sectionHeaderView.backgroundColor = BACKCOLORGRAY;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        
        label.font = FONT(14);
        label.textColor = BLUECOLOR;
        [sectionHeaderView addSubview:label];
        
        if (section == 0) {
            label.text = @"基本信息";
        }else if (section == 1){
            label.text = @"个人信息";
        }else if (section == 2){
            label.text = @"联系方式";
        }
        return sectionHeaderView;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
        view.backgroundColor = BACKCOLORGRAY;
        return view;
    }
   
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 198;
    }else
        return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else if (section ==1){
        if ([self.isStudent integerValue] == 2) {
            return 1;
        }else{
            return 3;
        }
    }else{
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        JianliCell *cell = [JianliCell cellWithTableView:tableView ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:{
                if (account) {
                    cell.rightTf.text = account.name;
                }
                cell.jiantouView.hidden = YES;
                NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:@"*姓名:"];
                [nameStr addAttributes:@{NSForegroundColorAttributeName:RedColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, 1)];
                cell.labelLeft.attributedText = nameStr;
                cell.rightTf.userInteractionEnabled = YES;
                self.nameTf = cell.rightTf;
                self.nameTf.userInteractionEnabled = NO;
                cell.rightTf.delegate = self;
                cell.lineViewTop.hidden = YES;
            break;
            }
            case 1:{
                if (account) {
                    cell.rightTf.text = account.nickname;
                }
                cell.jiantouView.hidden = YES;
                NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:@"*昵称:"];
                [nameStr addAttributes:@{NSForegroundColorAttributeName:RedColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, 1)];
                cell.labelLeft.attributedText = nameStr;
                cell.rightTf.userInteractionEnabled = YES;
                cell.rightTf.placeholder = @"请输入您的昵称";
                self.nickNameTf = cell.rightTf;
                self.nickNameTf.userInteractionEnabled = NO;
                cell.rightTf.delegate = self;
                cell.lineViewTop.hidden = YES;
                break;
            }
            case 2:{
                if (account) {
                    if ([account.sex integerValue] == 0) {
                        cell.rightTf.text = @"女";
                    }else{
                        cell.rightTf.text = @"男";
                    }
                    self.sex = account.sex;
                }
                NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:@"*性别:"];
                [nameStr addAttributes:@{NSForegroundColorAttributeName:RedColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, 1)];
                cell.labelLeft.attributedText = nameStr;
                cell.rightTf.placeholder = @"请选择您的性别";
                self.sexTf = cell.rightTf;
                
                break;
            }
            case 3:{
                if (account) {
                    cell.rightTf.text = account.birth_date;
                }
                NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:@"*出生日期:"];
                [nameStr addAttributes:@{NSForegroundColorAttributeName:RedColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, 1)];
                cell.labelLeft.attributedText = nameStr;
                cell.rightTf.placeholder = @"请选择您的出生日期";
                self.birthTf = cell.rightTf;
                
                break;
            }
            case 4:
                
                if (account) {
                    if (account.height.intValue != 0) {
                        cell.rightTf.text = account.height;
                    }
                }
                cell.labelLeft.text = @"身高:";
                cell.rightTf.placeholder = @"请选择您的身高";
                self.heightTf = cell.rightTf;
                cell.lineView.hidden = YES;
                
//                if (account) {
//                    cell.rightTf.text = account.shoe_size;
//                }
//                cell.labelLeft.text = @"鞋码:";
//                cell.rightTf.placeholder = @"请选择您的鞋码";
//                self.shoeSizeTf = cell.rightTf;
//                
                break;
            case 5:
                if (account) {
                    cell.rightTf.text = account.clothing_size;
                }
                cell.labelLeft.text = @"服装尺码:";
                cell.rightTf.placeholder = @"请选择您的服装尺码";
                self.clothSizeTf = cell.rightTf;
                
                break;
            case 6:
                if (account) {
                    if (account.height.intValue != 0) {
                        cell.rightTf.text = account.height;
                    }
                }
                cell.labelLeft.text = @"身高:";
                cell.rightTf.placeholder = @"请选择您的身高";
                self.heightTf = cell.rightTf;
                
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    else if (indexPath.section == 1){
        JianliCell *cell = [JianliCell cellWithTableView:tableView ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            if ([self.isStudent integerValue] == 1) {
                cell.selectYes.selectImg.image = [UIImage imageNamed:@"icon_xuanzhong"];
            }else if ([self.isStudent integerValue] == 2){
                cell.selectNo.selectImg.image = [UIImage imageNamed:@"icon_xuanzhong"];
            }
            cell.lineViewTop.hidden = NO;
            //@"1"是学生,@"2"不是
            NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:@"*学生:"];
            [nameStr addAttributes:@{NSForegroundColorAttributeName:RedColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, 1)];
            cell.labelLeft.attributedText = nameStr;
            cell.rightTf.hidden = YES;
            cell.selectNo.hidden = NO;
            self.selectNo = cell.selectNo;

            cell.selectYes.hidden = NO;
            self.selectYes = cell.selectYes;
            cell.jiantouView.hidden = YES;
            if (!editBtn.selected) {
                self.selectYes.userInteractionEnabled = NO;
                self.selectNo.userInteractionEnabled = NO;
            }else{
                self.selectYes.userInteractionEnabled = YES;
                self.selectNo.userInteractionEnabled = YES;
            }
            IMP_BLOCK_SELF(MyCVViewController);

            cell.seletIsStudentBlock = ^(NSString *isStuent){
                block_self.isStudent = isStuent;
                [block_self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            };
        }
        else if (indexPath.row == 1){
            if (!self.hadSelectedSchool) {
                if (account) {
                    cell.rightTf.text = account.school_name;
                    self.school = account.school_id;
                }
            }
            NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:@"*所在学校:"];
            [nameStr addAttributes:@{NSForegroundColorAttributeName:RedColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, 1)];
            cell.labelLeft.attributedText = nameStr;
            cell.rightTf.placeholder = @"请选择您的学校";
            self.schoolTf = cell.rightTf;
        }
        else if (indexPath.row == 2){
            if (account) {
                cell.rightTf.text = account.intoschool_date;
            }
            NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:@"*入学时间:"];
            [nameStr addAttributes:@{NSForegroundColorAttributeName:RedColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, 1)];
            cell.labelLeft.attributedText = nameStr;
            cell.rightTf.placeholder = @"请选择您的入学时间";
            self.inSchoolTiemTf = cell.rightTf;
        }
        return cell;
    }
    else{
        
        StudentInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([StudentInfoCell class]) owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (account) {
            cell.emailTF.text = account.email;
            cell.qqTF.text = account.qq.integerValue?account.qq:nil;
            cell.introduceTF.placeholder = nil;
            cell.introduceTF.text = account.introduce;
        }
        self.introduceTF = cell.introduceTF;
        self.emailTf = cell.emailTF;
        self.qqTf = cell.qqTF;
        self.introduceTF.userInteractionEnabled = NO;
        self.qqTf.userInteractionEnabled = NO;
        self.emailTf.userInteractionEnabled = NO;
        return cell;
        
    }
}

#pragma  mark  点击不同 cell 响应时间
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!editBtn.selected) {
        [self showAlertViewWithText:@"点击编辑按钮才可以编辑哟" duration:1];
        return;
    }
    [self.view endEditing:YES];
    JianliCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.nameTf resignFirstResponder];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            PickerView *pickerView = [PickerView aPickerView:^(NSString *sex) {
                if ([sex isEqualToString:@"男"]) {
                    self.sex = @"2";
                }else if ([sex isEqualToString:@"女"]){
                    self.sex = @"1";
                }
                cell.rightTf.text = sex;
            }];
            pickerView.arrayData = @[@"男",@"女"];
            [pickerView show];
        }else if (indexPath.row == 3){
            PickerView *pickerView = [PickerView aPickerView:^(NSString *birthDay) {
                self.birthDay = birthDay;
                cell.rightTf.text = birthDay;
            }];
            pickerView.isDatePicker = YES;
            NSString *timeString = @"1997-01-01";
            pickerView.datePickerView.date = [self.formatter dateFromString:timeString];
            [pickerView show];
        }else if (indexPath.row == 4){
            
            PickerView *pickerView = [PickerView aPickerView:^(NSString *height) {
                self.height = height;
                cell.rightTf.text = height;
            }];
            pickerView.arrayData = self.heightArr;
            [pickerView show];
            
//            PickerView *pickerView = [PickerView aPickerView:^(NSString *shoeSize) {
//                self.shoeSize = shoeSize;
//                cell.rightTf.text = shoeSize;
//            }];
//            pickerView.arrayData = @[@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47"];
//            [pickerView show];
        }else if (indexPath.row == 5){
            PickerView *pickerView = [PickerView aPickerView:^(NSString *clothSize) {
                self.clothSize = clothSize;
                cell.rightTf.text = clothSize;
            }];
            pickerView.arrayData = @[@"S",@"M",@"L",@"XL",@"XXL",@"XXXL"];
            [pickerView show];
        }else if (indexPath.row == 6){
            PickerView *pickerView = [PickerView aPickerView:^(NSString *height) {
                self.height = height;
                cell.rightTf.text = height;
            }];
            pickerView.arrayData = self.heightArr;
            [pickerView show];
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row==0) {
            
            
            
        }else if (indexPath.row == 1) {//查询学校
           
            SearchSchoolViewController *searchVC = [[SearchSchoolViewController alloc] init];
            
            searchVC.seletSchoolBlock = ^(SchoolModel *school){
                
                cell.rightTf.text = school.name;
                self.school = school.id;
                self.hadSelectedSchool = YES;
                
            };
            
            [self.navigationController pushViewController:searchVC animated:YES];
            
        }else if (indexPath.row == 2){
            PickerView *pickerView = [PickerView aPickerView:^(NSString *inSchoolTime) {
                self.intoSchoolTime = inSchoolTime;
                cell.rightTf.text = inSchoolTime;
            }];
            pickerView.isDatePicker = YES;
            NSString *timeString = @"2015-09-01";
            pickerView.datePickerView.date = [self.formatter dateFromString:timeString];
            [pickerView show];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/**
 *  上传头像点击事件
 */
-(void)uploadIcon:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (!editBtn.selected) {
        [self showAlertViewWithText:@"点击编辑按钮才可以编辑哟" duration:1];
        return;
    }
    [self showAalertView];
    
}
/**
 *  提示头像来源
 */
-(void)showAalertView
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    [sheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;//允许裁剪图片
    imagePickerController.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            break;
        case 1:
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            return;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    JGLog(@"%@",info);
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    JGLog(@" 压缩前  width ==  %f    height === %f ",image.size.width,image.size.height);
    
    
    JGLog(@" 压缩后   width ==  %f    height === %f ",image.size.width,image.size.height);
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    //
    //    JGLog(@"压缩前 ======  %lf",(float)data.length/(1024*1024));
    //
    //
    //
    //    JGLog(@"压缩后 ==== %lf",(float)data.length/(1024*1024));
    JGLog(@"%lu",(unsigned long)data.length);
    if(image.imageOrientation != UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    self.iconView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 *  保存信息点击事件
 */
-(void)saveBasicInfo:(UIButton *)saveBtn
{
    if ([[self.nameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self showAlertViewWithText:@"请填写您的姓名" duration:1];
        return;
    }else if ([[self.nickNameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        [self showAlertViewWithText:@"请填写您的昵称" duration:1];
        return;
    }else if (self.sex == nil){
        [self showAlertViewWithText:@"请选择您的性别" duration:1];
        return;
    }else if (self.birthTf.text == nil){
        [self showAlertViewWithText:@"请选择您的出生日期" duration:1];
        return;
    }
//    else if (self.shoeSizeTf.text == nil){
//        [self showAlertViewWithText:@"请选择您的鞋码" duration:1];
//        return;
//    }else if (self.clothSizeTf.text == nil){
//        [self showAlertViewWithText:@"请选择您的服装尺码" duration:1];
//        return;
//    }else if (self.heightTf.text == nil){
//        [self showAlertViewWithText:@"请选择您的身高" duration:1];
//        return;
//    }
//    else if (self.isStudent == nil){
//        [self showAlertViewWithText:@"请选择您是不是学生" duration:1];
//        return;
//    }
//    else if (self.schoolTf.text == nil){
//        [self showAlertViewWithText:@"请选择您的学校" duration:1];
//        return;
//    }else if (self.inSchoolTiemTf.text == nil){
//        [self showAlertViewWithText:@"请选择您的入学时间" duration:1];
//        return;
//    }
    if (self.isStudent.intValue == 1) {
            if (!self.schoolTf.text.length){
                [self showAlertViewWithText:@"请选择您的学校" duration:1];
                return;
            }else if (!self.inSchoolTiemTf.text.length){
                [self showAlertViewWithText:@"请选择您的入学时间" duration:1];
                return;
            }
    }

    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeClear];
    [self upImageToQN];
    
}

-(void)upImageToQN
{
    //上传图片到七牛云
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *iconData = UIImageJPEGRepresentation(self.iconView.image, 0.5);
    [upManager putData:iconData key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp == nil) {
            [self showAlertViewWithText:@"上传图片失败" duration:1];
            [SVProgressHUD dismiss];
            return ;
        }else{//上传图片成功后再上传个人资料

            [iconData writeToFile:ICONIMAGEDATA atomically:YES];
            JGUser *user = [JGUser user];
            user.iconUrl = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
            [JGUser saveUser:user WithDictionary:nil loginType:0];
            
//            [JGHTTPClient uploadUserJianliInfoByname:self.nameTf.text nickName:self.nickNameTf.text sex:self.sex loginId:[JGUser user].login_id iconUrl:[JGUser user].iconUrl school:self.school inSchoolTime:self.inSchoolTiemTf.text height:self.heightTf.text isStudent:self.isStudent birthDay:self.birthTf.text shoeSize:self.shoeSizeTf.text clothSize:self.clothSizeTf.text email:self.emailTf.text qq:self.qqTf.text introduce:self.introduceTF.text Success:^(id responseObject){
//                
//                [SVProgressHUD dismiss];
//                JGLog(@"%@",responseObject);
//                if (responseObject) {
//                    [self showAlertViewWithText:responseObject[@"message"] duration:1];
//                }
//                if ([responseObject[@"code"] intValue] == 200) {
//                    
//                    editBtn.selected = NO;
//                    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
//                    self.nameTf.userInteractionEnabled = NO;
//                    self.nickNameTf.userInteractionEnabled = NO;
//                    self.selectNo.userInteractionEnabled = NO;
//                    
//                    JGUser *user = [JGUser user];
//                    user.resume = @"1";
//                    user.nickName = self.nickNameTf.text;
//                    user.name = self.nameTf.text;
//                    user.gender = self.sex;
//                    user.school = self.schoolTf.text;
//                    [JGUser saveUser:user WithDictionary:nil loginType:0];
//                    if (self.reloadView) {
//                        self.reloadView();
//                    }
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self.navigationController popViewControllerAnimated:YES];
//                    });
//                }
//                
//                
//            } failure:^(NSError *error) {
//                
//                [SVProgressHUD dismiss];
//                [self showAlertViewWithText:NETERROETEXT duration:1];
//                
//            }];

            self.iconImageBlock(self.iconView.image);
        }
        
        
    } option:nil];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:RGBACOLOR(59, 155, 255,self.tableView.contentOffset.y/100)] forBarMetrics:UIBarMetricsDefault];
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
