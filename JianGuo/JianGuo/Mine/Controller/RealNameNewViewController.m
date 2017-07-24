//
//  RealNameNewViewController.m
//  JianGuo
//
//  Created by apple on 17/6/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "RealNameNewViewController.h"
#import "SearchSchoolViewController.h"

#import "SchoolModel.h"
#import "RealNameModel.h"

#import "JGHTTPClient+Mine.h"

#import "TextFieldCell.h"
#import "MineCell.h"
#import "TZImagePickerController.h"
#import "QiniuSDK.h"
#import "UIImageView+WebCache.h"
#import "QLAlertView.h"
#import <UIButton+AFNetworking.h>

static CGFloat const imageB_Left = 100*2;
static CGFloat const footerViewHeigh = 200;

typedef enum : NSUInteger {
    PictureIDCardFront,
    PictureIDCardBack,
    PictureStudentCard,
} PictureType;


@interface RealNameNewViewController ()<UITableViewDataSource,UITextFieldDelegate,UITableViewDelegate,TZImagePickerControllerDelegate,TextChangedDelegate>
{
    PictureType pictureType;
    UIImage *_imgPickedLeft;
    UIImage *_imgPickedRight;
    NSInteger  imageRighr_left;
    UITextField *realNameTf;
    UITextField *cardIdTf;
    UITextField *schoolTf;
    UITextField *studentNumTf;
    RealNameModel *model;
    CGFloat cellHeight;
    
    UIView *cellView;
    NSString *frontUrl;
    NSString *behindUrl;
    
    BOOL isSelectStudentCard;
    BOOL isSelectIDCardFront;
    BOOL isSelectIDCardBack;
    
    NSMutableDictionary *mutableDict;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (nonatomic,weak) UIImageView *cardImgLeft;

@property (nonatomic,weak) UIImageView *cardImgRight;

@property (nonatomic,copy) NSString *QNtoken;

@property (nonatomic,strong) UILabel *sexLabel;

@property (nonatomic,copy) NSString *frontCardIdUrl;

@property (nonatomic,copy) NSString *backCardIdUrl;

@property (nonatomic,copy) NSString *studentUrl;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,strong) UIView *screenView;

/** 学生证button */
@property (nonatomic,strong) UIButton *studentCardB;

/** 学校所属的城市ID */
@property (nonatomic,copy) NSString *schoolId;

/** 学校名称 */
@property (nonatomic,copy) NSString *schoolName;
;




@end

@implementation RealNameNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";
    mutableDict = @{}.mutableCopy;
    
    [self requestRealNameInfo];
    
}

-(void)requestRealNameInfo
{
    [JGHTTPClient selectRealnameInfoByloginId:nil Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]== 200) {
            model = [RealNameModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
            
            
            if (model.authStatus.intValue != 4) {
                frontUrl = model.frontImg;
                behindUrl = model.behindImg;
            }
            if (model.authStatus.integerValue == 1||model.authStatus.integerValue == 4) {
                [QLAlertView showAlertTittle:@"温馨提示" message:@"为了保障您的财产安全,打款时会对您的账户信息进行验证,因此务必正确填写您的真实信息!" isOnlySureBtn:YES compeletBlock:^{}];
            }
            [self.cardImgLeft sd_setImageWithURL:[NSURL URLWithString:frontUrl ]placeholderImage:[UIImage imageNamed:@"上传身份证正面-拷贝"]];
            
            [self.cardImgRight sd_setImageWithURL:[NSURL URLWithString:behindUrl]placeholderImage:[UIImage imageNamed:@"上传身份证反面-拷贝"]];
            
        }
        
    } failure:^(NSError *error) {
        
        
        
    }];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    sectionHeaderView.backgroundColor = WHITECOLOR;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_W-20, 50-1)];
    label.textColor = LIGHTGRAYTEXT;
    label.text = section==0?@"身份信息":(section==1?@"身份证证件":@"学校认证");
    label.font = section ==1?[UIFont systemFontOfSize:16.f]:[UIFont boldSystemFontOfSize:18.f];
    [sectionHeaderView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeaderView.height-1, SCREEN_W, 1)];
    line.backgroundColor = BACKCOLORGRAY;
    [sectionHeaderView addSubview:line];
    line.hidden = section ==1;
    
    return sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, footerViewHeigh)];
        view.backgroundColor = BACKCOLORGRAY;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_W-20, 20)];
        label1.text = @"身份信息填写错误可能对提现功能产生影响,请认真填写";
        label1.textColor = LIGHTGRAYTEXT;
        label1.font = FONT(12);
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label1.bottom, SCREEN_W-20, 20)];
        label2.text = @"此实名信息仅作为兼果校园平台使用";
        label2.textColor = LIGHTGRAYTEXT;
        label2.font = FONT(12);
        [view addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label2.bottom, SCREEN_W-20, 20)];
        label3.text = @"兼果校园承诺保护用户信息安全";
        label3.textColor = LIGHTGRAYTEXT;
        label3.font = FONT(12);
        [view addSubview:label3];
        
        UIButton *sureB = [UIButton buttonWithType:UIButtonTypeCustom];
        sureB.frame = CGRectMake(15, label3.bottom+30, SCREEN_W-30, 40);
        [sureB setTitle:@"确认提交" forState:UIControlStateNormal];

        if (model.authStatus.intValue == 2) {//（0=被封号，1=可以登录，但没有实名认证，2=已实名认证 ,3=审核中, 4=审核被拒）
            sureB.backgroundColor = [UIColor lightGrayColor];
            [sureB setTitle:@"已经通过审核" forState:UIControlStateNormal];
        }else if (model.authStatus.intValue == 3){
            
            sureB.backgroundColor = [UIColor lightGrayColor];
            [sureB setTitle:@"正在审核" forState:UIControlStateNormal];
        }
        else{
            sureB.backgroundColor = GreenColor;
            [sureB setTitle:@"提交审核" forState:UIControlStateNormal];
        }
        sureB.layer.cornerRadius = 3;
        [sureB setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [sureB addTarget:self action:@selector(commitInfo:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sureB];
        
        return view;
        
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    if (section == 1) {
        return 10;
    }else if (section == 2){
        return footerViewHeigh;
    }else
        return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        
        if (indexPath.row == 2) {
            return 50+(SCREEN_W-imageB_Left)+50;
        }else if (indexPath.row == 3){
            return 0.01;
        }else{
            return 0.01;
        }
    }else if (indexPath.section == 1){
        return cellHeight;
    }else {
        return 44;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else if (section ==1){
        return 1;
    }else if (section == 2){
        return 3;
    }else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            MineCell *cell = [MineCell cellWithTableView:tableView];
            cell.iconView.image = [UIImage imageNamed:@"icon_photo"];
            cell.labelLeft.text = @"手机号码";
            if ([JGUser user].tel.length!=11) {
                cell.labelRight.text = @"未验证";
            }else{
                cell.labelRight.text = [USER.tel stringByAppendingString:@"(已验证)"];
            }
            cell.labelRight.font = FONT(14);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
                cell.contentView.userInteractionEnabled = NO;
            }
            return cell;
        }else if (indexPath.row == 0){
            TextFieldCell *cell = [TextFieldCell aTextFieldCell];
            cell.iconView.image = [UIImage imageNamed:@"icon_i"];
            cell.lblText.text = @"真实姓名";
            cell.lblText.textColor = LIGHTGRAYTEXT;
            cell.txfName.delegate = self;
            cell.delegate = self;
            cell.txfName.borderStyle = UITextBorderStyleNone;
            
            cell.txfName.font = [UIFont systemFontOfSize:14];
            cell.txfName.placeholder = @"请输入您的真实姓名";
            if (model.authStatus.integerValue>1) {
                cell.txfName.text = model.realName;
            }
            if ([mutableDict[@"name"]length]) {
                cell.txfName.text = mutableDict[@"name"];
            }
            realNameTf = cell.txfName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
                cell.contentView.userInteractionEnabled = NO;
            }
            return cell;
        }else if (indexPath.row == 1){
            TextFieldCell *cell = [TextFieldCell aTextFieldCell];
            cell.iconView.image = [UIImage imageNamed:@"icon_card"];
            cell.lblText.text = @"身份证号";
            cell.txfName.delegate = self;
            cell.delegate = self;
            cell.lblText.textColor = LIGHTGRAYTEXT;
            cell.txfName.borderStyle = UITextBorderStyleNone;
            cell.txfName.font = [UIFont systemFontOfSize:14];
            
            cell.txfName.placeholder = @"请输入您的身份证号";
            if (model.authStatus.integerValue>1) {
                if (USER.status.intValue == 4) {
                    cell.txfName.text = nil;
                }else{
                    NSString *cardId = [model.identityCard stringByReplacingCharactersInRange:NSMakeRange(model.identityCard.length-6, 6) withString:@"******"];
                    cell.txfName.text = cardId;
                }
                
            }
            
            if ([mutableDict[@"IDcardNo"]length]) {
                cell.txfName.text = mutableDict[@"IDcardNo"];
            }
            cardIdTf = cell.txfName;
            cardIdTf.delegate = self;
//            [cardIdTf addTarget:self action:@selector(limitLength:) forControlEvents:UIControlEventEditingChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
                cell.contentView.userInteractionEnabled = NO;
            }
            return cell;
        }else if (indexPath.row == 3){
            MineCell *cell = [MineCell cellWithTableView:tableView];
            cell.iconView.image = [UIImage imageNamed:@"icon_gender"];
            cell.labelLeft.text = @"性别";
            if (model.authStatus.integerValue>1) {
                if ([model.sex integerValue] == 2) {
                    cell.labelRight.text = @"男";
                }else if ([model.sex integerValue] == 1){
                    cell.labelRight.text = @"女";
                }
            }
            self.sexLabel = cell.labelRight;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
                cell.contentView.userInteractionEnabled = NO;
            }
            return cell;
        }else{
            return nil;
        }
        
    }else if(indexPath.section == 1){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (!cellView) {
//            cellView = [self setHeaderView];
//        }
        cellView = [self setHeaderView];
        [cell.contentView addSubview:cellView];
        cellHeight = cellView.height;
        
        if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
            cell.contentView.userInteractionEnabled = NO;
        }
        return cell;
        
    }else{
        
        
        if (indexPath.row == 0) {
            
            TextFieldCell *cell = [TextFieldCell  aTextFieldCell];
            
            
            if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
                cell.contentView.userInteractionEnabled = NO;
            }
            cell.txfName.delegate = self;
            cell.lblText.textColor = LIGHTGRAYTEXT;
            cell.txfName.borderStyle = UITextBorderStyleNone;
            cell.txfName.font = [UIFont systemFontOfSize:14];
            cell.iconView.image = [UIImage imageNamed:@"icon_card"];
            cell.lblText.text = @"学校全称";
            cell.txfName.placeholder = @"选择您的学校";
            cell.txfName.enabled = NO;
            cell.delegate = self;
            schoolTf = cell.txfName;
            if (model.authStatus.integerValue>1) {
                cell.txfName.text = model.schoolName;
            }
            if ([mutableDict[@"schoolName"]length]) {
                cell.txfName.text = mutableDict[@"schoolName"];
            }
            cell.contentView.hidden = YES;
            return cell;
        
        }else if (indexPath.row == 1){
            
            TextFieldCell *cell = [TextFieldCell  aTextFieldCell];
            
            if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
                cell.contentView.userInteractionEnabled = NO;
            }
            cell.txfName.delegate = self;
            cell.lblText.textColor = LIGHTGRAYTEXT;
            cell.txfName.borderStyle = UITextBorderStyleNone;
            cell.txfName.font = [UIFont systemFontOfSize:14];
            cell.iconView.image = [UIImage imageNamed:@"icon_card"];
            cell.lblText.text = @"学号";
            cell.txfName.placeholder = @"输入您的学号";
            studentNumTf = cell.txfName;
            cell.delegate = self;
            if (model.authStatus.integerValue>1) {
                cell.txfName.text = model.studentNo;
            }
            if ([mutableDict[@"studentNo"]length]) {
                cell.txfName.text = mutableDict[@"studentNo"];
            }
            cell.contentView.hidden = YES;
            return cell;
            
            
        }else if (indexPath.row == 2){
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *leftL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
            leftL.text = @"学生证";
            leftL.textColor = LIGHTGRAYTEXT;
            
            UIButton *imageB = [UIButton buttonWithType:UIButtonTypeCustom];
            imageB.frame = CGRectMake(0, 0, SCREEN_W-imageB_Left, SCREEN_W-imageB_Left);
            imageB.center = CGPointMake(SCREEN_W/2, (SCREEN_W-imageB_Left)/2+leftL.bottom+15);
            [imageB setBackgroundImage:[UIImage imageNamed:@"studentidcard"] forState:UIControlStateNormal];
            imageB.tag = 10002;
            [imageB addTarget:self action:@selector(pickAimage:) forControlEvents:UIControlEventTouchUpInside];
            self.studentCardB = imageB;
            
            if (model.authStatus.integerValue>1) {
                [self.studentCardB setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.studentNoImg] placeholderImage:[UIImage imageNamed:@"studentidcard"]];
            }
            
            UILabel *alertL = [[UILabel alloc] initWithFrame:CGRectMake(0, imageB.bottom+15, SCREEN_W, 20)];
            alertL.textAlignment = NSTextAlignmentCenter;
            alertL.font = FONT(12);
            alertL.text = @"选填 (身份证/学生证,至少上传一种证件照片)";
            alertL.textColor = RedColor;
            
            [cell.contentView addSubview:leftL];
            [cell.contentView addSubview:imageB];
            [cell.contentView addSubview:alertL];
            
            
            if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
                cell.contentView.userInteractionEnabled = NO;
            }
            return cell;
            
        }
        
        return nil;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (model.authStatus.integerValue == 2||model.authStatus.integerValue == 3) {
        return;
    }
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            TextFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            SearchSchoolViewController *searchVC = [[SearchSchoolViewController alloc] init];
            searchVC.hidesBottomBarWhenPushed = YES;
            searchVC.seletSchoolBlock = ^(SchoolModel *school){
                cell.txfName.text = school.name;
                self.schoolName = school.name;
                self.schoolId = school.id;
            };
            [self.navigationController pushViewController:searchVC animated:YES];
            
        }
        
        
    }
    
}
//选一张图片
-(void)pickAimage:(UIButton *)sender
{
    switch (sender.tag) {
        case 10000:{
            
            pictureType = PictureIDCardFront;
            
            break;
        } case 10001:{
            
            pictureType = PictureIDCardBack;
            
            break;
        } case 10002:{
            
            pictureType = PictureStudentCard;
            
            break;
        }
    }

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowCrop = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];

    
}
//确认提交
-(void)commitInfo:(UIButton *)sender
{
    
    if (model.authStatus.integerValue>1) {
        if (USER.status.intValue == 2||USER.status.intValue == 3) {
            [self showAlertViewWithText:@"您已提交过信息,不能重复提交" duration:1.5];
            return;
        }
    }
    if (realNameTf.text.length ==0) {
        [self showAlertViewWithText:@"请填写您的真实姓名" duration:1];
        return;
    }else if (![self checkIdentityCardNo:[cardIdTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [self showAlertViewWithText:@"请正确输入身份证号" duration:1];
        return;
    }
//    else if (schoolTf.text.length == 0){
//        [self showAlertViewWithText:@"请选择您的学校" duration:1];
//        return;
//    }else if (studentNumTf.text.length == 0){
//        [self showAlertViewWithText:@"请输入您的学号" duration:1];
//        return;
//    }
    else if (!(isSelectIDCardFront&&isSelectIDCardBack)&&!isSelectStudentCard){
        [self showAlertViewWithText:@"请选择上传身份证或者学生证照片" duration:1];
        return;
    }
    
    
    JGSVPROGRESSLOAD(@"正在提交信息...")
    if (isSelectIDCardFront&&isSelectIDCardBack) {
        [self uploadToQNServer];
        return;
    }
    [self uploadNext];
    
}

-(void)uploadToQNServer
{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *dataFront= UIImageJPEGRepresentation(_imgPickedLeft,0.5);
    [upManager putData:dataFront key:nil token:USER.qiniuToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  //                      NSLog(@"%@", info);
                  //                      NSLog(@"%@-------------", resp);
                  //上传图片到服务器
                  if (resp == nil) {
                      [self showAlertViewWithText:@"上传图片失败" duration:1];
                      [SVProgressHUD dismiss];
                      return ;
                  }
                  self.frontCardIdUrl = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"]];
                  NSData *dataBack = UIImageJPEGRepresentation(_imgPickedRight,0.5);
                  [upManager putData:dataBack key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      if (resp == nil) {
                          [self showAlertViewWithText:@"上传图片失败" duration:1];
                          [SVProgressHUD dismiss];
                          return ;
                      }
                      self.backCardIdUrl = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
                      
                      if (isSelectStudentCard) {
                          [self uploadNext];
                      }else{
                          [self uploadToSelfServer];
                      }
                      
                  } option:nil];
                  
    } option:nil];
}

-(void)uploadNext
{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *dataBack = UIImageJPEGRepresentation(self.studentCardB.currentBackgroundImage,0.5);
    [upManager putData:dataBack key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp == nil) {
            [self showAlertViewWithText:@"上传图片失败" duration:1];
            [SVProgressHUD dismiss];
            return ;
        }
        self.studentUrl = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
        [self uploadToSelfServer];
        
    } option:nil];
}

-(void)uploadToSelfServer
{
    //把信息传给自己的服务器
    [JGHTTPClient uploadUserInfoByCardIdFront:self.frontCardIdUrl CarfIdBack:self.backCardIdUrl CardIdNum:cardIdTf.text realName:realNameTf.text schoolId:self.schoolId schoolName:self.schoolName studentNum:studentNumTf.text studentUrl:self.studentUrl Success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            JGUser *user = [JGUser user];
            user.status = @"2";
            [JGUser saveUser:user WithDictionary:nil loginType:0];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];

}


#pragma mark TZImagePickerController Delegate
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    switch (pictureType) {
        case PictureIDCardFront:{
            
            self.cardImgLeft.image = photos.firstObject;
            isSelectIDCardFront = YES;
            _imgPickedLeft = photos.firstObject;
            
            break;
        } case PictureIDCardBack:{
            
            self.cardImgRight.image = photos.firstObject;
            isSelectIDCardBack = YES;
            _imgPickedRight = photos.firstObject;
            
            break;
        } case PictureStudentCard:{
            
            [self.studentCardB setBackgroundImage:photos.firstObject forState:UIControlStateNormal];
            isSelectStudentCard = YES;
            
            break;
        }
    }
    
}


#pragma 正则匹配用户身份证号15或18位
-(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == cardIdTf) {
        return [self validateNumber:string];
    }else{
        return YES;
    }
    
}


-(void)limitLength:(UITextField *)textField
{
    if (textField == cardIdTf) {
        if (textField.text.length>18) {
            textField.text = [textField.text substringToIndex:18];
        }
        textField.text = [textField.text uppercaseString];
    }
}


/**
 *  限制输入身份证号
 */
- (BOOL)validateNumber:(NSString*)number{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx"];
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


-(void)textChanged:(UITextField *)textField
{
    if (textField == realNameTf) {
        [mutableDict setObject:textField.text forKey:@"name"];
    }else if (textField == cardIdTf){
        if (textField.text.length>18) {
            textField.text = [textField.text substringToIndex:18];
        }
        textField.text = [textField.text uppercaseString];
        [mutableDict setObject:textField.text forKey:@"IDcardNo"];
    }else if (textField == schoolTf){
        [mutableDict setObject:textField.text forKey:@"schoolName"];
    }else if (textField == studentNumTf){
        [mutableDict setObject:textField.text forKey:@"studentNo"];
    }
}



#pragma mark UI====方法
-(UIView *)setHeaderView
{
    CGFloat height;
    if (SCREEN_W == 320) {
        height = 220*(SCREEN_W/375)-10;
    }else if (SCREEN_W == 375){
        height = 220*(SCREEN_W/375);
    }else if (SCREEN_W == 414){
        height = 220*(SCREEN_W/375)-20;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
    bgView.backgroundColor = WHITECOLOR;
    
    if(model.authStatus.intValue != 2){
        CGFloat height2;
        if (SCREEN_W == 320) {
            height2 = 220*(SCREEN_W/375);
        }else if (SCREEN_W == 375){
            height2 = 220*(SCREEN_W/375);
        }else if (SCREEN_W == 414){
            height2 = 220*(SCREEN_W/375)-20;
        }
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];
        headerView.backgroundColor = WHITECOLOR;
        headerView.userInteractionEnabled = YES;
        [bgView addSubview:headerView];
        
        UIImageView *imageViewL = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_W/2-25, (SCREEN_W/2-25)/1.6)];
        imageViewL.userInteractionEnabled = YES;
        imageViewL.layer.cornerRadius = 5;
        imageViewL.layer.masksToBounds = YES;
        imageViewL.image = [UIImage imageNamed:@"上传身份证正面-拷贝"];
        
        [headerView addSubview:imageViewL];
        self.cardImgLeft = imageViewL;
        
        
        UIImageView *imageViewR = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2+5, 20, SCREEN_W/2-25, (SCREEN_W/2-25)/1.6)];
        imageViewR.userInteractionEnabled = YES;
        imageViewR.image = [UIImage imageNamed:@"上传身份证反面-拷贝"];
        imageViewR.layer.cornerRadius = 5;
        imageViewR.layer.masksToBounds = YES;
        
        [headerView addSubview:imageViewR];
        self.cardImgRight = imageViewR;
        
        UILabel *labelOver = [[UILabel alloc] initWithFrame:CGRectMake(headerView.center.x-130, imageViewR.bottom+20, 260, 20)];
        labelOver.font = FONT(13);
        labelOver.textColor = LIGHTGRAYTEXT;
        labelOver.textAlignment = NSTextAlignmentCenter;
        labelOver.text = @"选填 (上传后可获得兼职保险保障)";
        [headerView addSubview:labelOver];
        
        UIImageView *projectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 14)];
        projectView.image = [UIImage imageNamed:@"protect"];
        projectView.center = CGPointMake(labelOver.origin.x, labelOver.center.y);
        [headerView addSubview:projectView];
        
        UILabel *labeBottom = [[UILabel alloc] initWithFrame:CGRectMake(headerView.center.x-130, labelOver.bottom, 260, 20)];
        labeBottom.text = @"请保证您的身份证主要信息清晰可见";
        labeBottom.textAlignment = NSTextAlignmentCenter;
        labeBottom.font = FONT(12);
        labeBottom.textColor = LIGHTGRAYTEXT;
        [headerView addSubview:labeBottom];
        
        UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame = imageViewL.bounds;
        btnLeft.tag = 10000;
        [btnLeft addTarget:self action:@selector(pickAimage:) forControlEvents:UIControlEventTouchUpInside];
        btnLeft.backgroundColor = [UIColor clearColor];
        [imageViewL addSubview:btnLeft];
        
        UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        btnRight.frame = imageViewR.bounds;
        btnRight.tag = 10001;
        [btnRight addTarget:self action:@selector(pickAimage:) forControlEvents:UIControlEventTouchUpInside];
        btnRight.backgroundColor = [UIColor clearColor];
        [imageViewR addSubview:btnRight];
        /*
         UILabel *label = [UILabel createLabel:FONT(15) withColor:LIGHTGRAYTEXT];
         label.frame = CGRectMake(15, headerView.bottom+5, 100, 20);
         label.text = @"拍照示例";
         [bgView addSubview:label];
         
         NSArray *textArr = @[@"标准",@"边框缺失",@"照片模糊",@"闪光强烈"];
         
         CGFloat left = SCREEN_W==320?20:30;
         for (int i=0; i<4; i++) {
         UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(left+i*((SCREEN_W-left*5)/4+left), label.bottom+5, (SCREEN_W-left*5)/4, (SCREEN_W-left*5)/4/1.6)];
         imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"组-1%d-拷贝",i]];
         [bgView addSubview:imgView];
         UILabel *label = [UILabel createLabel:FONT(13) withColor:LIGHTGRAYTEXT];
         label.frame = CGRectMake(left+i*((SCREEN_W-left*5)/4+left), imgView.bottom, (SCREEN_W-left*5)/4, (SCREEN_W-left*5)/4/1.6);
         label.textAlignment = NSTextAlignmentCenter;
         label.text = textArr[i];
         [bgView addSubview:label];
         }
         */
    }
    
    else{
        bgView.backgroundColor = BLUECOLOR;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2-70, 10, 140, 200)];
        if (SCREEN_W == 320) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2-50, 10, 100, 160)];
        }
        imgView.image = [UIImage imageNamed:@"junmao2"];
        [bgView addSubview:imgView];
        
        //        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom, SCREEN_W, 40)];
        //        label1.textAlignment = NSTextAlignmentCenter;
        //        label1.font = FONT(20);
        //        label1.textColor = WHITECOLOR;
        //        label1.text = @"您已完成认证";
        //        [bgView addSubview:label1];
        //
        //        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom, SCREEN_W, 40)];
        //        label2.textAlignment = NSTextAlignmentCenter;
        //        label2.font = FONT(15);
        //        label2.textColor = WHITECOLOR;
        //        label2.text = @"为保证您的信息安全,兼果为您隐藏个人信息";
        //        [bgView addSubview:label2];
    }
    
    return bgView;
}



@end
