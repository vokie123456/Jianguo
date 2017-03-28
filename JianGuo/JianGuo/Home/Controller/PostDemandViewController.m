//
//  PostDemandViewController.m
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PostDemandViewController.h"
#import "HomeSegmentViewController.h"
#import "JianliCell.h"
#import "QLTakePictures.h"
#import "UITextView+placeholder.h"
#import "DemandCell.h"
#import "DemandTypeView.h"
#import "QNUploadManager.h"
#import "JGHTTPClient+Demand.h"
#import "PickerView.h"
#import "CityModel.h"
#import "QLAlertView.h"
#import "AddMoneyViewController.h"
#import "PostSuccessViewController.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "CourseViewController.h"
#import "WebViewController.h"
#import "DemandTypeModel.h"

@class DemandListViewController;
@interface PostDemandViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIViewControllerTransitioningDelegate>
{
    QLTakePictures *takePic;
    BOOL isSelectedPicture;
    __weak IBOutlet NSLayoutConstraint *tableViewBottomCons;
    
    __weak IBOutlet NSLayoutConstraint *sureBtnBottomCons;
    
    NSMutableDictionary *keys;
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
@property (nonatomic,assign) BOOL isNeedPop;
@end

@implementation PostDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布任务";
    keys = [NSMutableDictionary dictionary];
    self.tableView.tableHeaderView = [self customHeaderView];
    
    if ([USERDEFAULTS objectForKey:@"isFirstShowCourseVC"]) {
        [self showCourseVC];
    }
    
    if (SCREEN_W == 320) {
        tableViewBottomCons.constant = 50;
        sureBtnBottomCons.constant = 10;
    }
    
}

-(void)showCourseVC
{
    [USERDEFAULTS setObject:@(YES) forKey:@"isFirstShowCourseVC"];
    CourseViewController *courseVC = [[CourseViewController alloc] init];
    courseVC.transitioningDelegate = self;//代理必须遵守这个专场协议
    courseVC.callBackBlock = ^(){//点击按钮的一个回调
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//去兼职学堂
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.title = @"兼果学堂";
            webVC.url = @"http://101.200.195.147:8888/school.html";
            [self.navigationController pushViewController:webVC animated:YES];
        });
    };
    courseVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:courseVC animated:YES completion:nil];
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
        isSelectedPicture = YES;
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
        return 70;
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
                    cell.labelLeft.text = @"任务名称";
                    cell.rightTf.placeholder = @"给你的任务起个名(如:求陪跑)";
                    cell.jiantouView.hidden = YES;
                    [cell.rightTf addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
                    cell.rightTf.text = keys[@"title"];
                    cell.rightTf.userInteractionEnabled = YES;
                    self.titleTF = cell.rightTf;
                    
                    
                    break;
                } case 1:{
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.labelLeft.text = @"任务详情";
                    cell.jiantouView.hidden = YES;
                    [cell.rightTf removeFromSuperview];
                    [cell.lineView removeFromSuperview];
                    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(cell.labelLeft.right-5, 5, SCREEN_W-cell.labelLeft.right-10, 60)];
                    textV.backgroundColor = WHITECOLOR;
                    textV.font = FONT(15);
                    textV.delegate = self;
                    textV.textColor  =LIGHTGRAYTEXT;
                    if (!keys[@"detail"]) {
                        textV.placeholder = @"详细描述你的任务需求!";
                    }
                    textV.text = keys[@"detail"];
                    [cell.contentView addSubview:textV];
                    self.descriptionTV = textV;
                    
                    break;
                } case 2:{
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.labelLeft.text = @"任务赏金";
                    cell.rightTf.placeholder = @"赏金越高,任你的关注度越高哦!";
                    cell.rightTf.keyboardType = UIKeyboardTypeDecimalPad;
                    [cell.rightTf addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
                    cell.rightTf.delegate = self;
                    cell.jiantouView.hidden = YES;
                    cell.rightTf.userInteractionEnabled = YES;
                    self.moneyTF = cell.rightTf;
                    
                    break;
                } case 3:{
                    
                    
                    cell.labelLeft.text = @"任务分类";
                    cell.rightTf.placeholder = @"给您的任务选个分类";
                    cell.jiantouView.hidden = YES;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    self.demandTypeTF = cell.rightTf;
                    
                    break;
                } case 4:{
                    
                    cell.labelLeft.text = @"工作地点";
                    cell.rightTf.placeholder = @"告诉你的同学你们约在哪里?";
                    cell.jiantouView.hidden = YES;
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    self.addressTF = cell.rightTf;
                    cell.rightTf.userInteractionEnabled = YES;
                    
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
            DemandTypeView *view = [DemandTypeView demandTypeViewselectBlock:^(NSInteger index, NSString *title) {
                JianliCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.rightTf.text = title;
                self.demandType = [NSString stringWithFormat:@"%ld",index];
            }];
            NSArray *demandTypeArr= JGKeyedUnarchiver(JGDemandTypeArr);
            NSMutableArray *arr = @[].mutableCopy;
            for (DemandTypeModel *model in demandTypeArr) {
                if (model.type_id.integerValue == 0) {
                    continue;
                }
                [arr addObject:model.type_name];
            }
            view.titleArr = arr;
            
        }else if (indexPath.row == 4) {//改成输入了
//            PickerView *pickerView = [PickerView aPickerView:^(NSString *areaIdAndname) {
//                self.cityId = [CityModel city].code;
//                self.areaId = [areaIdAndname componentsSeparatedByString:@"="].firstObject;
//                self.addressTF.text = [areaIdAndname componentsSeparatedByString:@"="].lastObject;
//            }];
//            pickerView.isAreaPicker = YES;
//            pickerView.arrayData = [CityModel city].areaList;
//            [pickerView show];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)surePostDemand:(UIButton *)sender {
    
    
    if(!isSelectedPicture){
        [self showAlertViewWithText:@"请选择一张照片" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if(self.titleTF.text.length == 0){
        [self showAlertViewWithText:@"您还没告诉我您要干啥呢?" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if (self.descriptionTV.text.length==0){
        [self showAlertViewWithText:@"任务能再具体点儿吗?" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if (self.moneyTF.text.length==0||self.moneyTF.text.floatValue == 0){
        [self showAlertViewWithText:@"您还没给赏钱呢" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if (self.demandTypeTF.text.length==0){
        [self showAlertViewWithText:@"给您的任务归下类吧" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }else if (self.addressTF.text.length==0){
        [self showAlertViewWithText:@"任务地盘儿在哪儿" duration:1];
        [self addShakeAnimation:self.sureBtn];
        return;
    }
    
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    
    NSData *data = UIImageJPEGRepresentation(self.photoBtn.currentBackgroundImage, 0.6);

    
    JGSVPROGRESSLOAD(@"正在发布...");
    [manager putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp == nil) {
            [self showAlertViewWithText:@"上传图片失败" duration:1];
            [SVProgressHUD dismiss];
            return ;
        }else{//上传图片成功后再上传个人资料
            
            NSString *url = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
            
            NSString *isAnonymous = self.hideNameBtn.selected ? @"1":@"2";
            
            
            [JGHTTPClient PostDemandWithMoney:self.moneyTF.text imageUrl:url title:self.titleTF.text description:self.descriptionTV.text type:self.demandType city:[CityModel city].code area:self.addressTF.text schoolId:USER.schoolId sex:USER.gender anonymous:isAnonymous Success:^(id responseObject) {
                [SVProgressHUD dismiss];
                if ([responseObject[@"code"] integerValue] == 603) {
                    [QLAlertView showAlertTittle:@"余额不足,是否充值?" message:nil isOnlySureBtn:NO compeletBlock:^{//去充值
                        
                        AddMoneyViewController *addMoneyVC = [[AddMoneyViewController alloc] init];
                        addMoneyVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:addMoneyVC animated:YES];
                        
                    }];
                }else{
//                    [self showAlertViewWithText:responseObject[@"message"] duration:1];
                    if ([responseObject[@"code"] integerValue] == 200) {
                        
                        HomeSegmentViewController *vc = (HomeSegmentViewController *)self.navigationController.viewControllers.firstObject;
                        [vc refreshData];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        PostSuccessViewController *postVC = [[PostSuccessViewController alloc] init];
                        postVC.labelStr = @"Issued";
                        postVC.transitioningDelegate = vc;//代理必须遵守这个专场协议
                        postVC.modalPresentationStyle = UIModalPresentationCustom;
                        [self.navigationController.viewControllers.firstObject presentViewController:postVC animated:YES completion:nil];
                    }
                }
                
                
            } failure:^(NSError *error) {
                [self showAlertViewWithText:NETERROETEXT duration:1];
                [SVProgressHUD dismiss];
            }];
            
        }
        
    } option:nil];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//textField 的text内容是不包括当前输入的字符的字符串,string就是当前输入的字符<即 texgField.text+string 就是最终显示的内容>
    if ([textField.text rangeOfString:@"."].location!=NSNotFound) {//包含'.'
        if ([[textField.text componentsSeparatedByString:@"."].lastObject length]>=2) {
            if ([@"0123456789." containsString:string]) {
                return NO;
            }else
                return YES;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    !textView.text?:[keys setObject:textView.text forKey:@"detail"];
}


- (void)textChange:(UITextField *)sender {
    
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
    }else if (sender == self.titleTF){
        !sender.text?:[keys setObject:sender.text forKey:@"title"];
    }
    
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    PresentingAnimator *animator = [PresentingAnimator new];
    
    animator.scale=1.15;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

@end
