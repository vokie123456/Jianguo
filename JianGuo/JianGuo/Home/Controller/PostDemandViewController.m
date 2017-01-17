//
//  PostDemandViewController.m
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PostDemandViewController.h"
#import "JianliCell.h"
#import "QLTakePictures.h"
#import "UITextView+placeholder.h"
#import "DemandCell.h"
#import "DemandTypeView.h"
#import "QNUploadManager.h"
#import "JGHTTPClient+Demand.h"
#import "PickerView.h"
#import "CityModel.h"

@interface PostDemandViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    QLTakePictures *takePic;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,strong) UIButton *photoBtn;
@property (nonatomic,strong) UIButton *hideNameBtn;
@property (nonatomic,strong) UITextView *descriptionTV;
@property (nonatomic,strong) UITextField *titleTF;
@property (nonatomic,strong) UITextField *moneyTF;
@property (nonatomic,strong) UITextField *demandTypeTF;
@property (nonatomic,strong) UITextField *addressTF;
@property (nonatomic,copy) NSString *demandType;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *areaId;
@end

@implementation PostDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布需求";
    
    self.tableView.tableHeaderView = [self customHeaderView];
    
    
}

-(UIView *)customHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 120)];
    view.backgroundColor = WHITECOLOR;
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    photoBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentFill;
    
    photoBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentFill;
    
    photoBtn.frame = CGRectMake(0, 0, 60, 60);
    photoBtn.center = CGPointMake(view.center.x, view.center.y-10);
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:photoBtn];
    self.photoBtn = photoBtn;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, photoBtn.bottom+5, SCREEN_W, 25)];
    label.text = @"请上传一张描述图片";
    label.font = FONT(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = LIGHTGRAYTEXT;
    [view addSubview:label];
    
    return view;
}

-(void)takePhoto
{
    takePic = [QLTakePictures aTakePhotoAToolWithComplectionBlock:^(UIImage *image) {
        [self.photoBtn setBackgroundImage:image forState:UIControlStateNormal];
        takePic = nil;//防止循环引用,导致 takePic 释放不了
    }];
    takePic.VC = self;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return !section?5:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&&indexPath.row == 1) {
        return 80;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JianliCell *cell = [JianliCell cellWithTableView:tableView];
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:{
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.labelLeft.text = @"我想";
                    cell.rightTf.placeholder = @"想干啥?";
                    cell.jiantouView.hidden = YES;
                    
                    cell.rightTf.userInteractionEnabled = YES;
                    self.titleTF = cell.rightTf;

                    
                    break;
                } case 1:{
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.labelLeft.text = @"描述";
                    cell.jiantouView.hidden = YES;
                    [cell.rightTf removeFromSuperview];
                    [cell.lineView removeFromSuperview];
                    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(cell.labelLeft.right-5, 5, SCREEN_W-cell.labelLeft.right-10, 60)];
                    textV.backgroundColor = BACKCOLORGRAY;
                    textV.font = FONT(15);
                    textV.textColor  =LIGHTGRAYTEXT;
                    textV.placeholder = @"您具体想让别人干点儿啥?";
                    [cell.contentView addSubview:textV];
                    self.descriptionTV = textV;
                    
                    break;
                } case 2:{
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.labelLeft.text = @"赏金";
                    cell.rightTf.placeholder = @"打算怎么打赏?";
                    cell.jiantouView.hidden = YES;
                    cell.rightTf.userInteractionEnabled = YES;
                    self.moneyTF = cell.rightTf;
                    
                    break;
                } case 3:{
                    
                    
                    cell.labelLeft.text = @"分类";
                    cell.rightTf.placeholder = @"学习,情感,还是娱乐呢?";
                    cell.jiantouView.hidden = YES;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    self.demandTypeTF = cell.rightTf;
                    
                    break;
                } case 4:{
                    
                    cell.labelLeft.text = @"工作地点";
                    cell.rightTf.placeholder = @"在哪块儿地盘儿办事儿?";
                    cell.jiantouView.hidden = YES;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    self.addressTF = cell.rightTf;
                    
                    break;
                }
                default:
                    break;
            }

        }
        if (indexPath.section == 1) {
        DemandCell *cell = [DemandCell cellWithTableView:tableView];
        self.hideNameBtn = cell.hideNameBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [DemandTypeView demandTypeViewselectBlock:^(NSInteger index, NSString *title) {
                JianliCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.rightTf.text = title;
                self.demandType = [NSString stringWithFormat:@"%ld",index];
            }];
        }else if (indexPath.row == 4) {
            PickerView *pickerView = [PickerView aPickerView:^(NSString *areaIdAndname) {
                self.cityId = [CityModel city].id;
                self.areaId = [areaIdAndname componentsSeparatedByString:@"="].firstObject;
                self.addressTF.text = [areaIdAndname componentsSeparatedByString:@"="].lastObject;
            }];
            pickerView.isAreaPicker = YES;
            pickerView.arrayData = [CityModel city].areaList;
            [pickerView show];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)surePostDemand:(UIButton *)sender {
    
    
    if(self.titleTF.text.length == 0){
        [self showAlertViewWithText:@"您还没告诉我您要干啥呢?" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if (self.descriptionTV.text.length==0){
        [self showAlertViewWithText:@"需求能再具体点儿吗?" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if (self.moneyTF.text.length==0){
        [self showAlertViewWithText:@"您还没给赏钱呢" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if (self.demandTypeTF.text.length==0){
        [self showAlertViewWithText:@"给您的需求归下类吧" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if (self.addressTF.text.length==0){
        [self showAlertViewWithText:@"需求地盘儿在哪儿" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }
    
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    
    NSData *data = UIImageJPEGRepresentation(self.photoBtn.currentBackgroundImage, 0.5);
    
    [manager putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp == nil) {
            [self showAlertViewWithText:@"上传图片失败" duration:1];
            [SVProgressHUD dismiss];
            return ;
        }else{//上传图片成功后再上传个人资料
            
            NSString *url = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
            
            NSString *isAnonymous = self.hideNameBtn.selected ? @"1":@"2";
            
            
            [JGHTTPClient PostDemandWithMoney:self.moneyTF.text imageUrl:url title:self.titleTF.text description:self.descriptionTV.text type:self.demandType city:self.cityId area:self.areaId schoolId:USER.schoolId sex:USER.gender anonymous:isAnonymous Success:^(id responseObject) {
                
                [self showAlertViewWithText:responseObject[@"message"] duration:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            } failure:^(NSError *error) {
                
            }];
            
        }
        
    } option:nil];
    
}


@end
