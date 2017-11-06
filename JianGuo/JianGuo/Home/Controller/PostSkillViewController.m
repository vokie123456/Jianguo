//
//  PostSkillViewController.m
//  JianGuo
//
//  Created by apple on 17/9/13.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PostSkillViewController.h"
#import "DraftViewController.h"
#import "AddressListViewController.h"

#import "JGHTTPClient+Skill.h"

#import "AddressModel.h"
#import "SkillDetailModel.h"

#import "UITextView+placeholder.h"
#import "UIButton+AFNetworking.h"

#import "PostSkillCollectionView.h"
#import "TZImagePickerController.h"
#import "XLPhotoBrowser.h"
#import "QNUploadManager.h"
#import "TTTAttributedLabel.h"

#define leftDistance 15
#define labelWidth 80
#define buttonWidth 80

@interface PostSuccessView : NSObject<TTTAttributedLabelDelegate>


+(instancetype)shareAlertView;

-(void)showSuccessView;

@end

@implementation PostSuccessView
{
    UIView *bgView;
}

+(instancetype)shareAlertView
{
    static PostSuccessView *view;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        view = [PostSuccessView new];
    });
    return view;
}

-(void)showSuccessView
{
    bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 260)];
    alertView.center = bgView.center;
    alertView.layer.cornerRadius = 10;
    alertView.backgroundColor = WHITECOLOR;
    [bgView addSubview:alertView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(alertView.width/2-25, 20, 50, 70)];
    
    iconView.image = [UIImage imageNamed:@"cartoon"];
    [alertView addSubview:iconView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iconView.bottom, alertView.width, 30)];
    label.text = @"提交成功";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    [alertView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom, alertView.width, 20)];
    label1.text = @"[审核秘籍]";
    label1.textColor = LIGHTGRAYTEXT;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont boldSystemFontOfSize:14];
    [alertView addSubview:label1];
    
    TTTAttributedLabel *label2 = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, label1.bottom, alertView.width-40, 45)];
    label2.textColor = LIGHTGRAYTEXT;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.numberOfLines = 3;
    label2.font = [UIFont systemFontOfSize:14];
    
    [label2 setText:@"添加小果果微信 jianguoschool1 可以加快审核速度哦!" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        //        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, mutableAttributedString.length)];//这个设置方式不起作用
        
        [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
        
        return mutableAttributedString;
    }];
    UIFont *boldSystemFont = [UIFont systemFontOfSize:15];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    //添加点击事件
    label2.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    
    label2.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:RGBCOLOR(112, 167, 59)};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
    CFRelease(font);
    NSRange range= [label2.text rangeOfString:@"jianguoschool1"];
    
    [label2 addLinkToURL:nil withRange:range];
    
    label2.delegate = self;
    [alertView addSubview:label2];
    
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
    [sender setTitle:@"我知道了" forState:UIControlStateNormal];
    [sender setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [sender setBackgroundColor:GreenColor];
    sender.layer.cornerRadius = 3;
    [sender addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    sender.frame = CGRectMake(30, alertView.height-60, alertView.width-60, 40);
    [alertView addSubview:sender];
    
    [APPLICATION.keyWindow addSubview:bgView];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
}

-(void)dismiss:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        bgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [bgView removeFromSuperview];
        
    }];
}


- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url//复制小果果微信号
{
    [self showAlertViewWithText:@"已复制到剪切板" duration:1.5f];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"jianguoschool1";
    
}

@end

@interface PostSkillViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>


/** 上门 */
@property (nonatomic,strong) UIButton *comeB;
/** 线上 */
@property (nonatomic,strong) UIButton *onlineB;
/** 邮寄 */
@property (nonatomic,strong) UIButton *postB;
/** 到店 */
@property (nonatomic,strong) UIButton *storeB;
/** 技能封面 */
@property (nonatomic,strong) UIButton *coverView;
/** 学校View */
@property (nonatomic,strong) UIView *bothView;
/** 按钮View*/
@property (nonatomic,strong) UIView *buttonView;
/** 地址View*/
@property (nonatomic,strong) UIView *addressView;
/** 添加地址按钮*/
@property (nonatomic,strong) UIView *addressB;
/** 姓名Label*/
@property (nonatomic,strong) UILabel *nameL;
/** 地址Label*/
@property (nonatomic,strong) UILabel *addressL;
/** 电话Label*/
@property (nonatomic,strong) UILabel *telL;
/** 标题TF */
@property (nonatomic,strong) UITextField *titleTF;
/** 达人称谓 */
@property (nonatomic,strong) UITextField *expertTF;
/** 价格 */
@property (nonatomic,strong) UITextField *priceTF;

/** 服务描述 */
@property (nonatomic,strong) UITextView *serviceTV;

/** 技能资质描述 */
@property (nonatomic,strong) UITextView *skillTV;

/** 价格描述 */
@property (nonatomic,strong) UITextView *priceTV;

/** scrollView */
@property (nonatomic,strong) UIScrollView *bgScrollView;

@end

@implementation PostSkillViewController
{
    NSInteger kMaxLength;
    NSString *serviceMode;
    NSString *skillId;
    NSString *coverUrl;//技能封面图片字符串
    NSString *addressId;
    NSString *descImages;//服务详情图片数组字符串
    NSString *aptitudeImages;//技能资质图片数组字符串
    PostSkillCollectionView *serviceCollectionView;
    PostSkillCollectionView *skillCollectionView ;
    QNUploadManager *manager;
    SkillDetailModel *model;
    NSMutableArray *imageArr;
    BOOL isHaveCoverImage;
    BOOL isSavedAsDraft;
}

-(UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//        _bgScrollView.contentSize = CGSizeMake(0, 1640);
        [self.view addSubview:_bgScrollView];
    }
    return _bgScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageArr = [NSMutableArray array];
    
    self.navigationItem.title = @"发布技能";
    
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r setTitle:@"草稿箱" forState:UIControlStateNormal];
    [btn_r setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [btn_r addTarget:self action:@selector(draft:) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 60, 30);
    btn_r.titleLabel.font = FONT(15);
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    
    UIButton * btn_r1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_r1 setTitle:@"示例" forState:UIControlStateNormal];
    [btn_r1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if (SCREEN_W>320) {
        [btn_r1 setImage:[UIImage imageNamed:@"Exclamatory-mark"] forState:UIControlStateNormal];
    }
    [btn_r1 addTarget:self action:@selector(example) forControlEvents:UIControlEventTouchUpInside];
    btn_r1.frame = CGRectMake(0, 0, 60, 30);
    btn_r1.titleLabel.font = FONT(15);
    
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithCustomView:btn_r1];
    self.navigationItem.rightBarButtonItems = @[rightBtn,rightBtn1];
    
    if (self.isFromDraftVC) {
        
        JGSVPROGRESSLOAD(@"加载中...");
        [JGHTTPClient getSkillDraftDetailWithDraftId:self.draftId Success:^(id responseObject) {
        
            [SVProgressHUD dismiss];
            if ([responseObject[@"code"] integerValue] == 200) {
                model = [SkillDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                skillId = [NSString stringWithFormat:@"%ld",model.skillId];
                [self configUI];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self showAlertViewWithText:NETERROETEXT duration:2];
        }];
        
    }else{
        
        [self configUI];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)example
{
    [XLPhotoBrowser showPhotoBrowserWithImages:@[[NSURL URLWithString:@"http://img.jianguojob.com/publish_skill_example.png"]] currentImageIndex:0];
}

-(void)draft:(UIButton *)sender
{
    DraftViewController *draftVC = [[DraftViewController alloc] init];
    [self.navigationController pushViewController:draftVC animated:YES];
}

-(void)selectServiceType:(UIButton *)sender
{//tag == 1000(上门); 1001(线上); 1002(邮寄); 1003(到店)
    //后台接口: 1到店，2线上，3上门，4邮寄
    
    if (sender.tag==1003) {
        serviceMode = @"1";
    }else if(sender.tag == 1002){
        serviceMode = @"4";
    }else if(sender.tag == 1001){
        serviceMode = @"2";
    }else if(sender.tag == 1000){
        serviceMode = @"3";
    }
    
    [self.comeB setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [self.onlineB setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [self.postB setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [self.storeB setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"Selected-state"] forState:UIControlStateNormal];
    
    if (sender.tag == 1003) {//到店
        
        self.addressView.frame = CGRectMake(0, self.addressView.frame.origin.y, SCREEN_W, 120);
//        self.addressB.frame = CGRectMake(SCREEN_W/2-50, self.addressView.height/2-15, 100, 30);
        self.bothView.frame = CGRectMake(0, self.addressView.bottom, SCREEN_W, 92);
        self.coverView.frame = CGRectMake(self.coverView.frame.origin.x, self.bothView.bottom, self.coverView.frame.size.width, self.coverView.frame.size.height);
        self.buttonView.frame = CGRectMake(0, self.coverView.bottom+30, SCREEN_W, 40);
        self.bgScrollView.contentSize = CGSizeMake(0, self.buttonView.bottom+100);
        
    }else{
        
        self.addressView.frame = CGRectMake(0, self.addressView.frame.origin.y, SCREEN_W, 0);
//        self.addressB.frame = CGRectMake(SCREEN_W/2-50, self.addressView.height/2-15, 100, 30);
        self.bothView.frame = CGRectMake(0, self.addressView.bottom, SCREEN_W, 92);
        self.coverView.frame = CGRectMake(self.coverView.frame.origin.x, self.bothView.bottom, self.coverView.frame.size.width, self.coverView.frame.size.height);
        self.buttonView.frame = CGRectMake(0, self.coverView.bottom+30, SCREEN_W, 40);
        self.bgScrollView.contentSize = CGSizeMake(0, self.buttonView.bottom+100);
    }
    [self.bgScrollView layoutIfNeeded];
    
}

//上传图片
-(void)uploadImages:(NSInteger)count
{
    
    if (count==imageArr.count) {
        return;
    }
    
    if (!manager) {
        manager = [[QNUploadManager alloc] init];
    }
    
    NSData *data = UIImageJPEGRepresentation(imageArr[count], 0.7);
    
    __block NSInteger blockCount = count;
    NSString *loadingStr = [NSString stringWithFormat:@"正在发布第%ld张图片...",count+1];
    JGSVPROGRESSLOAD(loadingStr);
    [manager putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp == nil) {
            [self showAlertViewWithText:@"上传图片失败" duration:1];
            [SVProgressHUD dismiss];
            return ;
        }else{//上传图片成功后再上传个人资料
            
            NSString *url = [@"http://img.jianguojob.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
            
            if (blockCount<serviceCollectionView.imageArr.count) {
                
                descImages = [NSString stringWithFormat:@"%@%@%@",descImages?descImages:@"",(!descImages?@"":@","),url];
            }else if (blockCount<serviceCollectionView.imageArr.count+skillCollectionView.imageArr.count){
                
                aptitudeImages = [NSString stringWithFormat:@"%@%@%@",aptitudeImages?aptitudeImages:@"",(!aptitudeImages?@"":@","),url];
            }else{
                coverUrl = url;
            }
            
            blockCount++;
            
            
            [self uploadImages:blockCount];
            
            if (blockCount == imageArr.count) {//图片上传完成,调用自己服务器的接口
                
                [SVProgressHUD dismiss];
                
                [self uploadToSelfSeverWithStatus:isSavedAsDraft?@"1":@"2"];
            }
            JGLog(@"==== %ld ===== %@ ====",blockCount,url);
        }
        
    } option:nil];
}

//保存草稿
-(void)saveAsDraft:(UIButton *)sender
{
    
    if (model) {
        
        descImages = [serviceCollectionView.imageUrlArr componentsJoinedByString:@","];
        JGLog(@"%@",descImages);
        aptitudeImages = [skillCollectionView.imageUrlArr componentsJoinedByString:@","];
        JGLog(@"%@",aptitudeImages);
        [self uploadToSelfSeverWithStatus:@"1"];
        
    }else{
        [imageArr addObjectsFromArray:serviceCollectionView.imageArr];
        [imageArr addObjectsFromArray:skillCollectionView.imageArr];
        if (isHaveCoverImage) {
            [imageArr addObject:self.coverView.currentBackgroundImage];
        }
        
        isSavedAsDraft = YES;
        
        [self uploadImages:0];
    }
    
}
//提交审核
-(void)commit:(UIButton *)sender
{
    if (self.titleTF.text.length==0) {
        [self showAlertViewWithText:@"请输入技能标题" duration:1.5];
        return;
    }else if (self.expertTF.text.length==0){
        [self showAlertViewWithText:@"请输入达人称谓" duration:1.5];
        return;
    }else if (self.serviceTV.text.length==0){
        [self showAlertViewWithText:@"请输入技能服务描述" duration:1.5];
        return;
    }else if (self.skillTV.text.length == 0){
        
        [self showAlertViewWithText:@"请输入技能资质描述" duration:1.5];
        return;
    }else if (self.priceTF.text.floatValue == 0){
        
        [self showAlertViewWithText:@"请输入技能价格" duration:1.5];
        return;
    }else if (self.priceTV.text.length==0){
        
        [self showAlertViewWithText:@"请输入价格描述" duration:1.5];
        return;
    }else if (serviceMode==nil){
        
        [self showAlertViewWithText:@"请选择服务方式" duration:1.5];
        return;
    }else if (serviceMode.integerValue == 1&&addressId==nil){
        
        [self showAlertViewWithText:@"请选择一个地址" duration:1.5];
        return;
    }
    if (model) {
        
        if (serviceCollectionView.imageUrlArr.count==0){
            [self showAlertViewWithText:@"请选择一张服务详情的图片" duration:1.5];
            return;
        }
        
    }else{
        if (serviceCollectionView.imageArr.count==0){
            [self showAlertViewWithText:@"请选择一张服务详情的图片" duration:1.5];
            return;
        }
    }
    
    if (model) {
        
        descImages = [serviceCollectionView.imageUrlArr componentsJoinedByString:@","];
        JGLog(@"%@",descImages);
        aptitudeImages = [skillCollectionView.imageUrlArr componentsJoinedByString:@","];
        JGLog(@"%@",aptitudeImages);
        [self uploadToSelfSeverWithStatus:@"2"];
        
    }else{
        
        [imageArr addObjectsFromArray:serviceCollectionView.imageArr];
        [imageArr addObjectsFromArray:skillCollectionView.imageArr];
        if (isHaveCoverImage) {
            [imageArr addObject:self.coverView.currentBackgroundImage];
        }
        isSavedAsDraft = NO;
        [self uploadImages:0];
    }
    
}
//上传到自己服务器(status : 1==草稿 ,2==发布技能)
-(void)uploadToSelfSeverWithStatus:(NSString *)status
{
    JGSVPROGRESSLOAD(@"正在发布...");
    [JGHTTPClient postSkillWithMasterTitle:self.expertTF.text skillId:skillId title:self.titleTF.text cover:coverUrl skillDesc:self.serviceTV.text descImages:descImages skillAptitude:self.skillTV.text aptitudeImages:aptitudeImages price:self.priceTF.text priceDesc:self.priceTV.text serviceMode:serviceMode addressId:addressId schoolId:USER.schoolId status:status Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:responseObject[@"message"] duration:1.5];
        if ([responseObject[@"code"] integerValue] == 200) {
            
            [[PostSuccessView shareAlertView] showSuccessView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:NETERROETEXT duration:2];
    }];
}

//选择地址
-(void)address:(UIButton *)sender
{
    AddressListViewController *addressVC = [[AddressListViewController alloc] init];
    addressVC.isFromPlaceOrderVC = YES;
    addressVC.selectAddressBlock = ^(AddressModel *address,AddressListCell *cell){
        self.nameL.text = [NSString stringWithFormat:@"联系人:%@",address.consignee];
        self.telL.text =  [NSString stringWithFormat:@"电话:%@",address.mobile];;
        self.addressL.text =  [NSString stringWithFormat:@"地址:%@",address.location];;
        addressId = address.id;
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

-(void)cover:(UIButton *)sender
{
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    picker.showSelectBtn = NO;
    picker.allowCrop = YES;
    picker.cropRect = CGRectMake(0, SCREEN_H/2-(SCREEN_W*32/75)/2, SCREEN_W, SCREEN_W*32/75);
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    if (photos.count) {
        if (model) {
            
            if (!manager) {
                manager = [[QNUploadManager alloc] init];
            }
            
            NSData *data = UIImageJPEGRepresentation(photos.firstObject, 0.7);
            
            JGSVPROGRESSLOAD(@"正在上传图片...");
            [manager putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                [SVProgressHUD dismiss];
                if (resp == nil) {
                    [self showAlertViewWithText:@"上传图片失败" duration:1];
                    return ;
                }else{//上传图片成功后再上传个人资料
                    
                    coverUrl = [@"http://img.jianguojob.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
                    
                    [self.coverView setBackgroundImage:photos.firstObject forState:UIControlStateNormal];
                    
                }
                
            } option:nil];
            
        }else{
            self.coverView.frame = CGRectMake(self.coverView.frame.origin.x, self.coverView.frame.origin.y, self.coverView.frame.size.width, 160);
            self.buttonView.frame = CGRectMake(0, self.coverView.bottom+30, SCREEN_W, 40);
            self.bgScrollView.contentSize = CGSizeMake(0, self.buttonView.bottom+100);
            [self.bgScrollView layoutIfNeeded];
            [self.coverView setBackgroundImage:photos.firstObject forState:UIControlStateNormal];
            isHaveCoverImage = YES;
        }
    }
}

-(void)limitWordsLength:(UITextField *)textField
{
    
    if (self.titleTF == textField) {
        kMaxLength = 15;
    }else if (self.expertTF == textField){
        kMaxLength = 5;
    }else if (self.priceTF == textField){
        kMaxLength = 8;
    }
    
    NSString *toBeString = textField.text;
    
    NSString *lang = [textField.textInputMode primaryLanguage];
    
    if([lang isEqualToString:@"zh-Hans"]){ //简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textField markedTextRange];
        
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        
        
        if (!position){//非高亮
            
            if (toBeString.length > kMaxLength) {
                
                [self showAlertViewWithText:[NSString stringWithFormat:@"您最多可以输入%ld个字",kMaxLength] duration:1];
                
                textField.text = [toBeString substringToIndex:kMaxLength];

                
            }
            
        }
        
    }else{//中文输入法以外
        
        if (toBeString.length > kMaxLength) {
            
            [self showAlertViewWithText:[NSString stringWithFormat:@"您最多可以输入%ld个字",kMaxLength] duration:1];
            
            textField.text = [toBeString substringToIndex:kMaxLength];
            

        }
        
    }

}

#pragma mark UITextField delegate Method


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{//textField 的text内容是不包括当前输入的字符的字符串,string就是当前输入的字符<即 texgField.text+string 就是最终显示的内容>
    if (self.priceTF == textField) {
        if ([textField.text rangeOfString:@"."].location!=NSNotFound) {//包含'.'
            if ([[textField.text componentsSeparatedByString:@"."].lastObject length]>=2) {
                if ([@"0123456789." containsString:string]) {
                    return NO;
                }else
                    return YES;
            }else if ([string isEqualToString:@"."]){
                return NO;
            }
        }
    }
    return YES;
}



-(void)configUI
{
    //标题View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 45)];
    titleView.backgroundColor = WHITECOLOR;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, labelWidth, titleView.height-1)];
    titleL.text = @"技能标题";
    titleL.textColor = LIGHTGRAYTEXT;
    titleL.font = FONT(18);
    
    UITextField *titleTF = [[UITextField alloc] initWithFrame:CGRectMake(titleL.right, 0, SCREEN_W-titleL.right, titleL.height)];
    [titleTF addTarget:self action:@selector(limitWordsLength:) forControlEvents:UIControlEventEditingChanged];
    
    titleTF.placeholder = @"请勿超过15个中文字符";
    if (model) {
        titleTF.text = model.title;
    }
    titleTF.delegate = self;
    self.titleTF = titleTF;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.height-1, SCREEN_W, 1)];
    lineView1.backgroundColor = BACKCOLORGRAY;
    
    [titleView addSubview:titleL];
    [titleView addSubview:titleTF];
    [titleView addSubview:lineView1];
    [self.bgScrollView addSubview:titleView];
    //
    
    
    //达人View
    UIView *expertView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.bottom, SCREEN_W, 45)];
    expertView.backgroundColor = WHITECOLOR;
    
    UILabel *expertL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, labelWidth, expertView.height-1)];
    expertL.text = @"达人称谓";
    expertL.textColor = LIGHTGRAYTEXT;
    expertL.font = FONT(18);
    
    UITextField *expertTF = [[UITextField alloc] initWithFrame:CGRectMake(expertL.right, 0, SCREEN_W-expertL.right, expertL.height)];
    [expertTF addTarget:self action:@selector(limitWordsLength:) forControlEvents:UIControlEventEditingChanged];
    expertTF.placeholder = @"请勿超过5个字(如:陪聊小天使)";
    if (model) {
        expertTF.text = model.masterTitle;
    }
    expertTF.delegate = self;
    self.expertTF = expertTF;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, expertView.height-1, SCREEN_W, 1)];
    lineView2.backgroundColor = BACKCOLORGRAY;
    
    [expertView addSubview:expertL];
    [expertView addSubview:expertTF];
    
    [expertView addSubview:lineView2];
    [self.bgScrollView addSubview:expertView];
    //去澳洲23
    
    //服务详情
    UIView *serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, expertView.bottom, SCREEN_W, 190)];
    serviceView.backgroundColor = WHITECOLOR;
    
    UILabel *serviceL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, labelWidth, 44)];
    serviceL.text = @"服务详情";
    serviceL.font = FONT(18);
    serviceL.textColor = LIGHTGRAYTEXT;
    
    UITextView *serviceTV = [[UITextView alloc] initWithFrame:CGRectMake(leftDistance, serviceL.bottom, SCREEN_W-leftDistance*2, 50)];
    serviceTV.font = FONT(15);
//    serviceTV.textColor = LIGHTGRAYTEXT;
    serviceTV.placeholder = @"请详细描述您的服务内容,服务时间等信息";
    if (model) {
        serviceTV.text = model.skillDesc;
        serviceTV.placeholder = nil;
    }
    serviceTV.delegate = self;
    self.serviceTV = serviceTV;
    
    /*
     UIButton *serviceB = [UIButton buttonWithType:UIButtonTypeCustom];
     serviceB.frame = CGRectMake(leftDistance, serviceTV.bottom+10, buttonWidth, buttonWidth);
     serviceB.backgroundColor = LIGHTGRAYTEXT;
     serviceB.layer.cornerRadius = 3;
     [serviceB addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    serviceCollectionView = [[PostSkillCollectionView alloc] initWithFrame:CGRectMake(leftDistance, serviceTV.bottom, SCREEN_W-leftDistance*2, 180) collectionViewLayout:layout];

    serviceCollectionView.count = 5;
    if (model.descImages.count) {
        serviceCollectionView.imageUrlArr = [NSMutableArray arrayWithArray:model.descImages];
    }
   
    
    UILabel *serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, serviceCollectionView.bottom, 200, 20)];
    serviceLabel.text = @"添加图片 (最多5张)";
    serviceLabel.textColor = LIGHTGRAY1;
    serviceLabel.font = FONT(14);
    
    [serviceView addSubview:serviceL];
    [serviceView addSubview:serviceTV];
    [serviceView addSubview:serviceCollectionView];
    [serviceView addSubview:serviceLabel];
    [self.bgScrollView addSubview:serviceView];
    
    CGRect frame1 = serviceView.frame;
    frame1.size.height = serviceCollectionView.bottom+30;
    serviceView.frame = frame1;
    //
    
    //技能资质View
    UIView *skillView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceView.bottom+10, SCREEN_W, 155)];
    skillView.backgroundColor = WHITECOLOR;
    
    UILabel *skillL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, 80, 45)];
    skillL.text = @"技能资质";
    skillL.font = FONT(18);
    skillL.textColor = LIGHTGRAYTEXT;
    
    UITextView *skillTV = [[UITextView alloc] initWithFrame:CGRectMake(leftDistance, skillL.bottom, SCREEN_W-leftDistance*2, 50)];
    skillTV.font = FONT(15);
//    skillTV.textColor = LIGHTGRAYTEXT;
    skillTV.placeholder = @"请详细描述您的技能资质,可添加证书,以往作品等内容";
    if (model) {
        skillTV.text = model.skillAptitude;
        skillTV.placeholder = nil;
    }
    skillTV.delegate = self;
    self.skillTV = skillTV;
    
    UICollectionViewFlowLayout *layout_ = [[UICollectionViewFlowLayout alloc] init];
    skillCollectionView = [[PostSkillCollectionView alloc] initWithFrame:CGRectMake(leftDistance, skillTV.bottom, SCREEN_W-leftDistance*2, 90) collectionViewLayout:layout_];

    skillCollectionView.count = 3;
    if (model.aptitudeImages.count) {
        skillCollectionView.imageUrlArr = [NSMutableArray arrayWithArray:model.aptitudeImages];
    }
    
    
    UILabel *skillLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, skillCollectionView.bottom, 200, 20)];
    skillLabel.text = @"添加图片 (最多3张)";
    skillLabel.textColor = LIGHTGRAY1;
    skillLabel.font = FONT(14);
    
    [skillView addSubview:skillL];
    [skillView addSubview:skillTV];
    [skillView addSubview:skillCollectionView];
    [skillView addSubview:skillLabel];
    [self.bgScrollView addSubview:skillView];
    
    CGRect frame2 = skillView.frame;
    frame2.size.height = skillCollectionView.bottom+30;
    skillView.frame = frame2;
    //
    
    //服务价格View
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, skillView.bottom+10, SCREEN_W, 190)];
    priceView.backgroundColor = WHITECOLOR;
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, 80, 45)];
    priceL.text = @"服务价格";
    priceL.font = FONT(18);
    priceL.textColor = LIGHTGRAYTEXT;
    
    UITextField *priceTF = [[UITextField alloc] initWithFrame:CGRectMake(0, priceL.bottom, SCREEN_W, 40)];
    [priceTF addTarget:self action:@selector(limitWordsLength:) forControlEvents:UIControlEventEditingChanged];
    priceTF.textColor = [UIColor orangeColor];
    priceTF.font = [UIFont boldSystemFontOfSize:20];
    priceTF.textAlignment = NSTextAlignmentCenter;
    priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    priceTF.delegate = self;
    if (model) {
        priceTF.text = [NSString stringWithFormat:@"%.2f",model.price.floatValue];
    }
    self.priceTF = priceTF;
    
    UIView *priceLine = [[UIView alloc] initWithFrame:CGRectMake(100, priceTF.bottom, SCREEN_W-200, 1)];
    priceLine.backgroundColor = BACKCOLORGRAY;
    
    UILabel *priceIntroduceL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, priceLine.bottom, 80, 45)];
    priceIntroduceL.text = @"价格说明";
    priceIntroduceL.font = FONT(18);
    priceIntroduceL.textColor = LIGHTGRAYTEXT;
    
    UITextView *priceTV = [[UITextView alloc] initWithFrame:CGRectMake(leftDistance, priceIntroduceL.bottom, SCREEN_W-2*leftDistance, 50)];
    priceTV.font = FONT(15);
    priceTV.placeholder = @"请详细描述服务单位,价格说明,价格调整规则等内容";
    if (model) {
        priceTV.text = model.priceDesc;
        priceTV.placeholder = nil;
    }
    
    priceView.frame = CGRectMake(0, skillView.bottom+10, SCREEN_W, priceTV.bottom+40);
    self.priceTV = priceTV;
    
    [priceView addSubview:priceL];
    [priceView addSubview:priceTF];
    [priceView addSubview:priceLine];
    [priceView addSubview:priceIntroduceL];
    [priceView addSubview:priceTV];
    [self.bgScrollView addSubview:priceView];
    //
    
    //服务方式View
    UIView *serviceTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, priceView.bottom+10, SCREEN_W, 190)];
    serviceTypeView.backgroundColor = WHITECOLOR;
    
    if (model) {
        if (model.serviceMode) {
            serviceMode = [NSString stringWithFormat:@"%ld",model.serviceMode];
        }
    }
    
    UILabel *serviceTypeL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, 80, 45)];
    serviceTypeL.text = @"服务方式";
    serviceTypeL.font = FONT(18);
    serviceTypeL.textColor = LIGHTGRAYTEXT;
    
    UIView *comeView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceTypeL.bottom, SCREEN_W, 45)];
    comeView.backgroundColor = WHITECOLOR;
    
    UIButton *comeB = [UIButton buttonWithType:UIButtonTypeCustom];
    comeB.frame = CGRectMake(leftDistance, 10, 25, 25);
    comeB.tag = 1000;
    [comeB setBackgroundImage:[UIImage imageNamed:model.serviceMode == 3?@"Selected-state":@"Unchecked"] forState:UIControlStateNormal];
    [comeB addTarget:self action:@selector(selectServiceType:) forControlEvents:UIControlEventTouchUpInside];
    self.comeB = comeB;
    
    UILabel *comeL = [[UILabel alloc] initWithFrame:CGRectMake(comeB.right+10, 0, SCREEN_W-comeB.left, comeView.height)];
    comeL.textColor = LIGHTGRAYTEXT;
    comeL.font = FONT(16);
    comeL.text = @"上门(到TA指定的地点)";
    [comeView addSubview:comeB];
    [comeView addSubview:comeL];
    
    //后台接口: 1到店，2线上，3上门，4邮寄
    UIView *onlineView = [[UIView alloc] initWithFrame:CGRectMake(0, comeView.bottom, SCREEN_W, 45)];
    onlineView.backgroundColor = WHITECOLOR;
    
    UIButton *onlineB = [UIButton buttonWithType:UIButtonTypeCustom];
    onlineB.frame = CGRectMake(leftDistance, 10, 25, 25);
    onlineB.tag = 1001;
    [onlineB setBackgroundImage:[UIImage imageNamed:model.serviceMode == 2?@"Selected-state":@"Unchecked"] forState:UIControlStateNormal];
    [onlineB addTarget:self action:@selector(selectServiceType:) forControlEvents:UIControlEventTouchUpInside];
    self.onlineB = onlineB;
    
    UILabel *onlineL = [[UILabel alloc] initWithFrame:CGRectMake(onlineB.right+10, 0, SCREEN_W-onlineB.left, onlineView.height)];
    onlineL.textColor = LIGHTGRAYTEXT;
    onlineL.font = FONT(16);
    onlineL.text = @"线上(线上全程服务)";
    [onlineView addSubview:onlineB];
    [onlineView addSubview:onlineL];
    
    
    UIView *postView = [[UIView alloc] initWithFrame:CGRectMake(0, onlineView.bottom, SCREEN_W, 45)];
    postView.backgroundColor = WHITECOLOR;
    
    UIButton *postB = [UIButton buttonWithType:UIButtonTypeCustom];
    postB.frame = CGRectMake(leftDistance, 10, 25, 25);
    postB.tag = 1002;
    [postB setBackgroundImage:[UIImage imageNamed:model.serviceMode == 4?@"Selected-state":@"Unchecked"] forState:UIControlStateNormal];
    [postB addTarget:self action:@selector(selectServiceType:) forControlEvents:UIControlEventTouchUpInside];
    self.postB = postB;
    
    UILabel *postL = [[UILabel alloc] initWithFrame:CGRectMake(comeB.right+10, 0, SCREEN_W-comeB.left, comeView.height)];
    postL.textColor = LIGHTGRAYTEXT;
    postL.font = FONT(16);
    postL.text = @"邮寄(快递寄送)";
    [postView addSubview:postB];
    [postView addSubview:postL];
    
    
    UIView *storeView = [[UIView alloc] initWithFrame:CGRectMake(0, postView.bottom, SCREEN_W, 45)];
    storeView.backgroundColor = WHITECOLOR;
    
    UIButton *storeB = [UIButton buttonWithType:UIButtonTypeCustom];
    storeB.frame = CGRectMake(leftDistance, 10, 25, 25);
    storeB.tag = 1003;
    [storeB setBackgroundImage:[UIImage imageNamed:model.serviceMode == 1?@"Selected-state":@"Unchecked"] forState:UIControlStateNormal];
    [storeB addTarget:self action:@selector(selectServiceType:) forControlEvents:UIControlEventTouchUpInside];
    self.storeB = storeB;
    
    UILabel *storeL = [[UILabel alloc] initWithFrame:CGRectMake(storeB.right+10, 0, SCREEN_W-storeB.left, comeView.height)];
    storeL.textColor = LIGHTGRAYTEXT;
    storeL.font = FONT(16);
    storeL.text = @"到店(到我指定的地点)";
    [storeView addSubview:storeB];
    [storeView addSubview:storeL];
    
    UIView *serviceLine = [[UIView alloc] initWithFrame:CGRectMake(0, serviceTypeView.bottom-1, SCREEN_W, 1)];
    serviceLine.backgroundColor = BACKCOLORGRAY;
    
    
    [serviceTypeView addSubview:serviceTypeL];
    [serviceTypeView addSubview:comeView];
    [serviceTypeView addSubview:onlineView];
    [serviceTypeView addSubview:postView];
    [serviceTypeView addSubview:storeView];
    [serviceTypeView addSubview:serviceLine];
    [self.bgScrollView addSubview:serviceTypeView];
    
    serviceTypeView.frame = CGRectMake(0, priceView.bottom+10, SCREEN_W, storeView.bottom+20);
    //
    
    //地址View
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, serviceTypeView.bottom, SCREEN_W, model.serviceMode == 1?120:0)];
    
    if (model) {
        addressId = model.addressId;
    }
    
    addressView.clipsToBounds = YES;
    addressView.backgroundColor = WHITECOLOR;
    self.addressView = addressView;
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, 100, 30)];
    addressLabel.text = @"联系地址";
    addressLabel.font = FONT(18);
    addressLabel.textColor = LIGHTGRAYTEXT;
    [addressView addSubview:addressLabel];
    
    UIButton *addressB = [UIButton buttonWithType:UIButtonTypeCustom];
    addressB.frame = CGRectMake(addressLabel.right, 5, 70, 20);
    [addressB setBackgroundColor:GreenColor];
    addressB.layer.cornerRadius = 3;
    addressB.titleLabel.font = FONT(14);
    [addressB addTarget:self action:@selector(address:) forControlEvents:UIControlEventTouchUpInside];
    [addressB setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [addressB setTitle:@"选择地址" forState:UIControlStateNormal];
    [addressView addSubview:addressB];
    self.addressB = addressB;
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, addressLabel.bottom, 100, 30)];
//    nameL.textColor = LIGHTGRAYTEXT;
    nameL.font = FONT(15);
    if (model.addressId.integerValue) {
        nameL.text = [NSString stringWithFormat:@"联系人:%@",model.consignee];
    }
    self.nameL = nameL;
    
    UILabel *telL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W-170, addressLabel.bottom, 150, 30)];
//    telL.textColor = LIGHTGRAYTEXT;
    telL.font = FONT(15);
    if (model.addressId.integerValue) {
        telL.text = [NSString stringWithFormat:@"电话:%@",model.mobile];
    }
    self.telL = telL;
    
    UILabel *addressL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, nameL.bottom, SCREEN_W-2*leftDistance, 50)];
    addressL.numberOfLines = 2;
//    addressL.textColor = LIGHTGRAYTEXT;
    addressL.font = FONT(15);
    if (model.addressId.integerValue) {
        addressL.text = [NSString stringWithFormat:@"地址:%@",model.location];
    }
    self.addressL = addressL;
    
    
    [addressView addSubview:nameL];
    [addressView addSubview:telL];
    [addressView addSubview:addressL];
    
    
    [self.bgScrollView addSubview:addressView];
    
    //发布到&技能封面View
    UIView *bothView = [[UIView alloc] initWithFrame:CGRectMake(0, addressView.bottom, SCREEN_W, 92)];
    bothView.backgroundColor = WHITECOLOR;
    self.bothView = bothView;
    
    UIView * schoolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 46)];
    schoolView.backgroundColor = WHITECOLOR;
    
    UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1)];
    lineTop.backgroundColor = BACKCOLORGRAY;
    
    UILabel *leftL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, 80, 45)];
    leftL.text = @"发布到";
    leftL.textColor = LIGHTGRAYTEXT;
    leftL.font = FONT(18);
    
    UIView *lineMiddle = [[UIView alloc] initWithFrame:CGRectMake(0, leftL.bottom-1, SCREEN_W, 1)];
    lineMiddle.backgroundColor = BACKCOLORGRAY;
    
    UILabel *schoolL = [[UILabel alloc] initWithFrame:CGRectMake(leftL.right+30, 0, SCREEN_W-leftL.right, 45)];
    schoolL.text = USER.school_name;
//    schoolL.textColor = LIGHTGRAYTEXT;
    schoolL.font = FONT(18);
    [schoolView addSubview:lineTop];
    [schoolView addSubview:lineMiddle];
    [schoolView addSubview:leftL];
    [schoolView addSubview:schoolL];
    
    UIView *skillCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, schoolView.bottom, SCREEN_W, 45)];
    skillCoverView.backgroundColor = WHITECOLOR;
    
    UILabel *skillLeftL = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance, 0, 80, 45)];
    skillLeftL.textColor = LIGHTGRAYTEXT;
    skillLeftL.text = @"技能封面";
    skillLeftL.font = FONT(18);
    
    UILabel *skillMiddleL = [[UILabel alloc] initWithFrame:CGRectMake(skillLeftL.right, 0, SCREEN_W-skillLeftL.right-55, 45)];
    skillMiddleL.textColor = RGBCOLOR(210, 210, 210);
    skillMiddleL.text = @"默认为服务详情第一张图片";
    skillMiddleL.font = FONT(14);
    
    UIButton *coverB = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverB setBackgroundImage:[UIImage imageNamed:@"Add-to"] forState:UIControlStateNormal];
    [coverB addTarget:self action:@selector(cover:) forControlEvents:UIControlEventTouchUpInside];
    coverB.frame = CGRectMake(SCREEN_W-55, 5, 35, 35);
    
    UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, skillMiddleL.bottom, SCREEN_W, 1)];
    lineBottom.backgroundColor = BACKCOLORGRAY;
    
    
    [skillCoverView addSubview:skillLeftL];
    [skillCoverView addSubview:skillMiddleL];
    [skillCoverView addSubview:lineBottom];
    [skillCoverView addSubview:coverB];
    
    [bothView addSubview:schoolView];
    [bothView addSubview:skillCoverView];
    
    [self.bgScrollView addSubview:bothView];
    //
    
    //封面图片View
    UIButton *coverView = [UIButton buttonWithType:UIButtonTypeCustom];
    coverView.frame = CGRectMake(0, bothView.bottom, SCREEN_W, 0);
    if (model&&model.cover.length) {
        coverUrl = model.cover;
        coverView.frame = CGRectMake(0, bothView.bottom, SCREEN_W, 160);
        [coverView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"placeholderPic"]];
    }
    [coverView addTarget:self action:@selector(cover:) forControlEvents:UIControlEventTouchUpInside];
    self.coverView = coverView;
    
    [self.bgScrollView addSubview:coverView];
    //
    
    //按钮
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, coverView.bottom+30, SCREEN_W, 40)];
    buttonView.backgroundColor = [UIColor clearColor];
    self.buttonView = buttonView;
    
    UIButton *draftB = [UIButton buttonWithType:UIButtonTypeCustom];
    draftB.frame = CGRectMake(40, 0, SCREEN_W/2-60, buttonView.height);
    [draftB addTarget:self action:@selector(saveAsDraft:) forControlEvents:UIControlEventTouchUpInside];
    [draftB setTitle:@"存为草稿" forState:UIControlStateNormal];
    [draftB setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    draftB.titleLabel.font = FONT(16);
    [draftB setBackgroundColor:GreenColor];
    if (model.auditStatus==2) {
        [draftB setBackgroundColor:LIGHTGRAY1];
        draftB.userInteractionEnabled = NO;
    }
    draftB.layer.cornerRadius = 5;
    
    UIButton *commitB = [UIButton buttonWithType:UIButtonTypeCustom];
    commitB.frame = CGRectMake(SCREEN_W/2+20, 0, draftB.width, buttonView.height);
    [commitB addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [commitB setTitle:@"提交审核" forState:UIControlStateNormal];
    [commitB setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    commitB.titleLabel.font = FONT(16);
    [commitB setBackgroundColor:GreenColor];
    commitB.layer.cornerRadius = 5;
    
    [buttonView addSubview:draftB];
    [buttonView addSubview:commitB];
    
    [self.bgScrollView addSubview:buttonView];
    
    self.bgScrollView.contentSize = CGSizeMake(0, self.buttonView.bottom+100);
    
    
    //    bothView.frame = CGRectMake(0, serviceTypeView.bottom, SCREEN_W, skillCoverView.bottom);
    
    //    CGRect frame = self.bgScrollView.frame;
    //    frame.size.height = collectionView.bottom+40;
    //
    //    self.bgScrollView.frame = frame;
    
}


@end
