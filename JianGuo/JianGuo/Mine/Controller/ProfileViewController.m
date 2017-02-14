//
//  ProfileViewController.m
//  JianGuo
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "ProfileViewController.h"
#import "JianliCell.h"
#import "UITextView+placeholder.h"
#import "DemandTypeView.h"
#import "PickerView.h"
#import "SearchSchoolViewController.h"
#import "SchoolModel.h"
#import "JGHTTPClient+Mine.h"
#import "CityModel.h"

#define scrollViewHeight 300

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) UITableView *tableView3;
@property (nonatomic,strong) UITextField *nameTF;
@property (nonatomic,strong) UITextField *nickNameTF;
@property (nonatomic,strong) UITextField *starTF;
@property (nonatomic,strong) UITextField *birthDateTF;
@property (nonatomic,strong) UITextField *isStudentTF;
@property (nonatomic,strong) UITextField *addressTF;
@property (nonatomic,strong) UITextField *schoolTF;
@property (nonatomic,strong) UITextField *intoSchoolTimeTF;
@property (nonatomic,strong) UITextField *QQTF;
@property (nonatomic,strong) UITextView *introduceTF;


@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *schoolId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *areaId;
@property (nonatomic,copy) NSString *starSet;
@property (nonatomic,copy) NSString *isStudent;

@end

@implementation ProfileViewController

-(UITableView *)tableView1{
    if (!_tableView1) {
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, scrollViewHeight)];
        _tableView1.backgroundColor = BACKCOLORGRAY;
        _tableView1.bounces = NO;
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView1.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView1;
}
-(UITableView *)tableView2{
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_W, 0, SCREEN_W, scrollViewHeight)];
        _tableView2.backgroundColor = BACKCOLORGRAY;
        _tableView2.bounces= NO;
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView2;
}
-(UITableView *)tableView3{
    if (!_tableView3) {
        _tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_W*2, 0, SCREEN_W, scrollViewHeight)];
        _tableView3.bounces = NO;
        _tableView3.backgroundColor = BACKCOLORGRAY;
        _tableView3.delegate = self;
        _tableView3.dataSource = self;
        _tableView3.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"填写资料";
    
    self.swipeGestureRecognizer.enabled = NO;
    
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_W*3, 0);
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.scrollEnabled = NO;
    self.bgScrollView.delegate = self;
    
    [self.bgScrollView addSubview:self.tableView1];
    [self.bgScrollView addSubview:self.tableView2];
    [self.bgScrollView addSubview:self.tableView3];
    
    [self.view bringSubviewToFront:self.nextBtn];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView3 == tableView&&indexPath.row == 1) {
        return 80;
    }
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableView1 == tableView) {
        return 5;
    }else if (self.tableView2 == tableView){
        return 3;
    }else if (self.tableView3 == tableView){
        return 2;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JianliCell *cell = [JianliCell cellWithTableView:tableView];
    if (self.tableView1 == tableView) {
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
//            cell.rightTf.placeholder = @"想干啥?";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            cell.selectYes.hidden = NO;
            cell.selectNo.hidden = NO;
            cell.selectNo.labeYysOrNo.text = @"我是女神";
            cell.selectYes.labeYysOrNo.text = @"我是男神";
            //用户性别(男=2,女=1)
            cell.seletIsStudentBlock = ^(NSString *sex){
                self.sex = sex;
            };
            
        }else if (indexPath.row == 2){
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"昵称";
            cell.rightTf.placeholder = @"您的江湖名号?";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = YES;
            self.nickNameTF = cell.rightTf;
            
        }else if (indexPath.row == 3){
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"星座";
            cell.rightTf.placeholder = @"是处女座吗?";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.starTF = cell.rightTf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 4){
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"出生日期";
            cell.rightTf.placeholder = @"您出生的日子是哪天?";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.birthDateTF = cell.rightTf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    
    if (self.tableView2 == tableView) {
//        if (indexPath.row == 0) {
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.labelLeft.text = @"学生";
//            cell.rightTf.placeholder = @"您还在象牙塔里吗?";
//            cell.jiantouView.hidden = YES;
//            cell.rightTf.userInteractionEnabled = NO;
//            self.isStudentTF = cell.rightTf;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            
//        }else
            if (indexPath.row == 0){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"所在地址";
            cell.rightTf.placeholder = @"北京 朝阳";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.addressTF = cell.rightTf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"所在学校";
            cell.rightTf.placeholder = @"北京大学";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.schoolTF = cell.rightTf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2){
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"入学时间";
            cell.rightTf.placeholder = @"2014-09-01";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = NO;
            self.intoSchoolTimeTF = cell.rightTf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (self.tableView3 == tableView) {
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labelLeft.text = @"QQ";
            cell.rightTf.placeholder = @"留下您的QQ号,交到更多朋友";
            cell.jiantouView.hidden = YES;
            cell.rightTf.userInteractionEnabled = YES;
            self.QQTF = cell.rightTf;
        }else if (indexPath.row == 1){
            
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
            self.introduceTF = textV;
            
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (self.tableView1 == tableView) {
        
        if (indexPath.row == 3) {
            DemandTypeView *view = [DemandTypeView demandTypeViewselectBlock:^(NSInteger index, NSString *title) {
                self.starTF.text = title;
                self.starSet = [NSString stringWithFormat:@"%ld",index];
            }];
            view.titleArr = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
        }else if (indexPath.row == 4){
            PickerView *pickerView = [PickerView aPickerView:^(NSString *inSchoolTime) {
                self.birthDateTF.text = inSchoolTime;
            }];
            pickerView.isDatePicker = YES;
            pickerView.initalDateStr = @"1998-01-01";
            [pickerView show];
        }
        
    }else if (self.tableView2 == tableView){
        
//        if (indexPath.row == 0) {
//            PickerView *pickerView = [PickerView aPickerView:^(NSString *sex) {
//                //TODO: 写完赋值转换
//                self.isStudentTF.text = sex;
//                if ([sex isEqualToString:@"是"]) {
//                    
//                }else if ([sex isEqualToString:@"否"]){
//                    
//                    [self.tableView2 reloadData];
//                    
//                }
//            }];
//            pickerView.arrayData = @[@"是",@"否"];
//            [pickerView show];
//        }else
            if (indexPath.row == 0) {
            //选择城市
                
                PickerView *pickerView = [PickerView aPickerView:^(NSString *areaIdAndname) {
                    self.cityId = [CityModel city].id;
                    self.areaId = [areaIdAndname componentsSeparatedByString:@"="].firstObject;
                    self.addressTF.text = [areaIdAndname componentsSeparatedByString:@"="].lastObject;
                }];
                pickerView.isAreaPicker = YES;
                pickerView.arrayData = [CityModel city].areaList;
                [pickerView show];

            
            
        }else if (indexPath.row == 1){
            SearchSchoolViewController *searchVC = [[SearchSchoolViewController alloc] init];
            
            searchVC.seletSchoolBlock = ^(SchoolModel *school){
                self.schoolTF.text = school.name;
                self.schoolId = school.id;
            };
            
            [self.navigationController pushViewController:searchVC animated:YES];
            
        }else if (indexPath.row == 2) {
            PickerView *pickerView = [PickerView aPickerView:^(NSString *inSchoolTime) {
                self.intoSchoolTimeTF.text = inSchoolTime;
            }];
            pickerView.isDatePicker = YES;
            pickerView.initalDateStr = @"2016-09-01";
            [pickerView show];
        }
        
    }else if (self.tableView3 == tableView){
        
    }
}

- (IBAction)next:(UIButton *)sender {
    
    if (currentIndex == 0 || currentIndex == 1) {
        
        if (currentIndex==0) {
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
            }
        }else{
            if (self.addressTF.text.length==0) {
                [self showAlertViewWithText:@"请选择您所在的地址" duration:1];
                return;
            }else if (self.schoolTF.text.length==0){
                [self showAlertViewWithText:@"请选择您的大学" duration:1];
                return;
            }else if (self.intoSchoolTimeTF.text.length==0){
                [self showAlertViewWithText:@"请选择您的入学时间" duration:1];
                return;
            }
        }
        
        sender.userInteractionEnabled = NO;
        [self.bgScrollView setContentOffset:CGPointMake(self.bgScrollView.contentOffset.x+SCREEN_W, 0) animated:YES];
    }else{//确定提交信息
        
        if (self.QQTF.text.length==0) {
            [self showAlertViewWithText:@"留下您的QQ号吧" duration:1];
            return;
        }
        
        [self commitInfo];
        
    }
        
    
}

-(void)commitInfo
{
    

    [JGHTTPClient uploadUserJianliInfoByname:self.nameTF.text nickName:self.nickNameTF.text iconUrl:USER.iconUrl sex:self.sex schoolId:self.schoolId cityId:self.cityId areaId:self.areaId inSchoolTime:self.intoSchoolTimeTF.text birthDay:self.birthDateTF.text constellation:self.starSet introduce:self.introduceTF.text qq:self.QQTF.text isStudent:nil Success:^(id responseObject) {//是不是学生这个字段在业务上不要了
        
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject);
        if (responseObject) {
            [self showAlertViewWithText:responseObject[@"message"] duration:1];
        }
        if ([responseObject[@"code"] intValue] == 200) {
         
            JGUser *user = [JGUser user];
            user.resume = @"1";
            user.nickName = self.nickNameTF.text;
            user.name = self.nameTF.text;
            user.gender = self.sex;
            user.schoolId = self.schoolId;
            [JGUser saveUser:user WithDictionary:nil loginType:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:1];
        
    }];

}

/**
 *  返回上一级页面
 */
-(void)popToLoginVC
{
    if (currentIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.bgScrollView setContentOffset:CGPointMake(self.bgScrollView.contentOffset.x-SCREEN_W, 0) animated:YES];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.nextBtn.userInteractionEnabled = YES;
    if (self.bgScrollView == scrollView) {
        currentIndex = scrollView.contentOffset.x/SCREEN_W;
        if (currentIndex == 2) {
            [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else
            [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
}



@end
