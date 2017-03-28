//
//  RealNameViewController.m
//  JianGuo
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "RealNameViewController.h"
#import "CodeLoginViewController.h"
#import "JGHTTPClient+Mine.h"
#import "MineCell.h"
#import "TextFieldCell.h"
#import "QiniuSDK.h"
#import "XLPhotoBrowser.h"
#import "PickerView.h"
#import "QiniuSDK.h"
#import "RealNameModel.h"
#import "UIImageView+WebCache.h"
#import "UILabel+Additions.h"
#import "MyImagePickerController.h"


#define CARDIDFRONTIMAGE [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cardIdFront.data"]
#define CARDIDBACKIMAGE [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cardIdBack.data"]

@interface RealNameViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIImage *_imgPickedLeft;
    UIImage *_imgPickedRight;
    NSInteger  imageRighr_left;
    UITextField *realNameTf;
    UITextField *cardIdTf;
    RealNameModel *model;
    CGFloat cellHeight;
    
    UIView *cellView;
    NSString *frontUrl;
    NSString *behindUrl;
}
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,weak) UIImageView *cardImgLeft;

@property (nonatomic,weak) UIImageView *cardImgRight;

@property (nonatomic,copy) NSString *QNtoken;

@property (nonatomic,strong) UILabel *sexLabel;

@property (nonatomic,copy) NSString *frontCardIdUrl;

@property (nonatomic,copy) NSString *backCardIdUrl;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,strong) UIView *screenView;

@end

@implementation RealNameViewController

-(NSMutableArray *)dataArr
{
    if (!_dataArr ) {
        _dataArr = [[NSMutableArray alloc] init];
        
    }
    return _dataArr;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BACKCOLORGRAY;
        _tableView.bounces = YES;
//        _tableView.tableFooterView = [self setHeaderView];
        _tableView.tableHeaderView = [self customHeaderView];
        
    }
    return _tableView;
}

-(UIView *)customHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
    headerView.backgroundColor = BACKCOLORGRAY;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 50)];
    imgView.center = headerView.center;
    imgView.image = [UIImage imageNamed:@"authentication"];
    [headerView addSubview:imgView];
    return headerView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"实名认证";
    
    //监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [self.view addSubview:self.tableView];
    
    IMP_BLOCK_SELF(RealNameViewController)
    [JGHTTPClient selectRealnameInfoByloginId:[JGUser user].login_id Success:^(id responseObject) {
        
        JGLog(@"%@",responseObject);
        if ([responseObject[@"code"]integerValue] == 200&& [[responseObject[@"data"] allKeys] count]) {
            model = [RealNameModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.sex = model.sex;
            JGUser *user = [JGUser user];
            user.status = model.auth_status;
            [JGUser saveUser:user WithDictionary:nil loginType:0];
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [block_self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (model.auth_status.intValue != 4) {
                frontUrl = model.front_img_url;
                behindUrl = model.behind_img_url;
            }
            [block_self.cardImgLeft sd_setImageWithURL:[NSURL URLWithString:frontUrl ]placeholderImage:[UIImage imageNamed:@"上传身份证正面-拷贝"]];
            
            [block_self.cardImgRight sd_setImageWithURL:[NSURL URLWithString:behindUrl]placeholderImage:[UIImage imageNamed:@"上传身份证反面-拷贝"]];
        }
        
    } failure:^(NSError *error) {
        [self showAlertViewWithText:NETERROETEXT duration:1];
    }];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    APPLICATION.keyWindow.backgroundColor = BLUECOLOR;
}


#pragma mark   tableview 的代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return cellHeight;
    }
    else{
    
        return 200;
    
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==1?15:0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 20)];
    view.backgroundColor = BACKCOLORGRAY;
    return view;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
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
            return cell;
        }else if (indexPath.row == 1){
            TextFieldCell *cell = [TextFieldCell aTextFieldCell];
            cell.iconView.image = [UIImage imageNamed:@"icon_i"];
            cell.lblText.text = @"姓名";
            cell.lblText.textColor = [UIColor darkTextColor];
            cell.txfName.delegate = self;
            cell.txfName.borderStyle = UITextBorderStyleNone;
            
            cell.txfName.font = [UIFont systemFontOfSize:14];
            cell.txfName.placeholder = @"请输入您的真实姓名";
            if (model) {
                cell.txfName.text = model.realname;
            }
            realNameTf = cell.txfName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 2){
            TextFieldCell *cell = [TextFieldCell aTextFieldCell];
            cell.iconView.image = [UIImage imageNamed:@"icon_card"];
            cell.lblText.text = @"身份证号";
            cell.txfName.delegate = self;
            cell.lblText.textColor = [UIColor darkTextColor];
            cell.txfName.borderStyle = UITextBorderStyleNone;
            cell.txfName.font = [UIFont systemFontOfSize:14];
          
            cell.txfName.placeholder = @"请输入您的身份证号";
            if (model) {
                if (USER.status.intValue == 4) {
                    cell.txfName.text = nil;
                }else{
                    NSString *cardId = [model.IDcard stringByReplacingCharactersInRange:NSMakeRange(model.IDcard.length-6, 6) withString:@"******"];
                    cell.txfName.text = cardId;
                }
                
            }
            cardIdTf = cell.txfName;
            cardIdTf.delegate = self;
            [cardIdTf addTarget:self action:@selector(limitLength:) forControlEvents:UIControlEventEditingChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 3){
            MineCell *cell = [MineCell cellWithTableView:tableView];
            cell.iconView.image = [UIImage imageNamed:@"icon_gender"];
            cell.labelLeft.text = @"性别";
            if (model) {
                if ([model.sex integerValue] == 2) {
                    cell.labelRight.text = @"男";
                }else if ([model.sex integerValue] == 1){
                    cell.labelRight.text = @"女";
                }
            }
            self.sexLabel = cell.labelRight;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            return nil;
        }

    }else if(indexPath.section == 1){
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cellView) {
            cellView = [self setHeaderView];
        }
        [cell.contentView addSubview:cellView];
        cellHeight = cellView.height;
        
        return cell;
        
    }else{
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *commitCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commitCheckBtn.frame = CGRectMake(30, 30, SCREEN_W-60, 40);
        if (USER.status.intValue == 2) {//（0=被封号，1=可以登录，但没有实名认证，2=已实名认证 ,3=审核中, 4=审核被拒）
            commitCheckBtn.backgroundColor = [UIColor lightGrayColor];
            [commitCheckBtn setTitle:@"已经通过审核" forState:UIControlStateNormal];
        }else if (USER.status.intValue == 3){
            
            commitCheckBtn.backgroundColor = [UIColor lightGrayColor];
            [commitCheckBtn setTitle:@"正在审核" forState:UIControlStateNormal];
        }
        else{
            commitCheckBtn.backgroundColor = GreenColor;
            [commitCheckBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        }
        commitCheckBtn.layer.cornerRadius = 15;
        commitCheckBtn.layer.masksToBounds = YES;
        [commitCheckBtn addTarget:self action:@selector(commitCheck) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:commitCheckBtn];
        cell.contentView.backgroundColor = BACKCOLORGRAY;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, commitCheckBtn.bottom+20, SCREEN_W, 20)];
        label1.text = @"此实名信息仅作为兼果平台使用确保用户信息安全";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = LIGHTGRAYTEXT;
        label1.font = FONT(12);
        [cell.contentView addSubview:label1];
    
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == 0) {
        if ([JGUser user].tel.length!=11) {
            
            CodeLoginViewController *codeVc = [[CodeLoginViewController alloc] init];
            codeVc.isFromRealName = YES;
            codeVc.title = @"绑定手机";
            [self.navigationController pushViewController:codeVc animated:YES];
        }
        
    }else if (indexPath.row == 3){
        PickerView *pickerView = [PickerView aPickerView:^(NSString *sex) {
            if ([sex isEqualToString:@"男"]) {
                self.sex = @"2";
            }else if ([sex isEqualToString:@"女"]){
                self.sex = @"1";
            }
            self.sexLabel.text = sex;
        }];
        pickerView.arrayData = @[@"男",@"女"];
        [pickerView show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/**
 *  拍照
 */
-(void)takePhoto:(UIButton *)btn
{
    
    imageRighr_left = btn.tag;
    if (btn.tag == 10000) {
        if (_imgPickedLeft) {
            [self clickCardIdView:btn];
            return;
        }
    }else if (btn.tag == 10001){
        if (_imgPickedRight) {
            [self clickCardIdView:btn];
            return;
        }
    }
    if (model) {
        if (btn.tag == 10000) {
            
            if ([JGUser user].status.intValue != 3) {
                [self showAalertView];
            }else{
                [XLPhotoBrowser showPhotoBrowserWithImages:@[self.cardImgLeft] currentImageIndex:0];
            }
            
        }else if (btn.tag == 10001){
            if ([JGUser user].status.intValue != 3) {
                [self showAalertView];
            }else{
                [XLPhotoBrowser showPhotoBrowserWithImages:@[self.cardImgRight] currentImageIndex:0];
            }
        }
    }else{
        [self showAalertView];
    }
}

-(void)createScreenView
{
    UIView *screenView = [[UIView alloc] initWithFrame:APPLICATION.keyWindow.bounds];
    screenView.backgroundColor = [UIColor blackColor];
    screenView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        screenView.alpha = 0.9;
    }];
    [APPLICATION.keyWindow addSubview:screenView];
    self.screenView = screenView;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"metion"];
    imgView.bounds = CGRectMake(0, 0, SCREEN_W, 132*(SCREEN_W/229));
    CGPoint point = CGPointMake(SCREEN_W/2, SCREEN_H/2-150);
    imgView.center = point;
    [screenView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+10, SCREEN_W, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = WHITECOLOR;
    label.font = FONT(18);
    label.text = @"为了提高照片的分辨率,请横屏拍照";
    [screenView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, label.bottom+30, SCREEN_W-200, 40);
    btn.backgroundColor = YELLOWCOLOR;
    [btn addTarget:self action:@selector(showAalertView) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 10;
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    [screenView addSubview:btn];
}


-(void)showAalertView
{
    if (self.screenView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.screenView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [self.screenView removeFromSuperview];
            self.screenView = nil;
        }];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
        [sheet showInView:self.view];
    }else{
        [self createScreenView];
    }
}

-(void)clickCardIdView:(UIButton *)btn
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"查看"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        if (btn.tag == 10000) {
                                                            
                                                            [XLPhotoBrowser showPhotoBrowserWithImages:@[self.cardImgLeft] currentImageIndex:0];
                                                            
                                                        }else{
                                                            [XLPhotoBrowser showPhotoBrowserWithImages:@[self.cardImgRight] currentImageIndex:0];
                                                            
                                                        }
                                                        
                                                    }];
    [actionSheetController addAction:action0];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"重新上传"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self showAalertView];
                                                   }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    
    [actionSheetController addAction:action];
    [actionSheetController addAction:actionCancel];
    
//    [actionSheetController.view setTintColor:BLUECOLOR];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    MyImagePickerController *imagePickerController = [[MyImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;//不允许裁剪图片
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
//    if (imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self createScreenView];
//        });
//    }
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    JGLog(@"%@",info);
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    JGLog(@" 压缩前  width ==  %f    height === %f ",image.size.width,image.size.height);
    
    //压缩图片
    image = [self imageByScalingAndCroppingForSize:CGSizeMake(image.size.width/8, image.size.height/8) sourceImage:image];
    
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
    
    if (imageRighr_left == 10000) {
        self.cardImgLeft.image = image;
        _imgPickedLeft = image;
        NSData *data = UIImageJPEGRepresentation(_imgPickedLeft, 0.5);
        JGLog(@"%lu",(unsigned long)data.length);
        [data writeToFile:CARDIDFRONTIMAGE atomically:YES];
    }else if (imageRighr_left == 10001){
        self.cardImgRight.image = image;
        _imgPickedRight = image;
        NSData *data = UIImageJPEGRepresentation(_imgPickedRight, 0.5);
        [data writeToFile:CARDIDBACKIMAGE atomically:YES];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
/**
 *  点击提交按钮
 *
 */
-(void)commitCheck{
    
    if (model) {
        if (USER.status.intValue == 2||USER.status.intValue == 3) {
            [self showAlertViewWithText:@"您已提交过信息,不能重复提交" duration:1.5];
            return;
        }
    }
    
    if ([realNameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length  == 0) {
        [self showAlertViewWithText:@"请输入您的真实姓名" duration:1];
        return;
        //[cardIdTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
    }else if (!_imgPickedRight){
        [self showAlertViewWithText:@"请上传一张身份证正面照片" duration:1];
        return;
    }else if (!_imgPickedLeft){
        [self showAlertViewWithText:@"请上传一张身份证反面照片" duration:1];
        return;
    }else if (![self checkIdentityCardNo:[cardIdTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [self showAlertViewWithText:@"请正确输入身份证号" duration:1];
        return;
    }else if (![self.sex isEqualToString:@"2"] && ![self.sex isEqualToString:@"1"]){
        [self showAlertViewWithText:@"请您选择性别" duration:1];
        return;
    }
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定提交审核?"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            if ((!_imgPickedLeft)&&(!_imgPickedRight)) {
                                                                [self uploadToSelfService];
                                                            }else{
                                                                [self uploadToQNgetUrl];
                                                            }
                                                        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 return ;
                                                             }];
        
        [alertController addAction:action0];
        [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        
}
/**
 *  上传图片到七牛 获取url
 */
-(void)uploadToQNgetUrl
{
    //上传图片到七牛云
    [SVProgressHUD showWithStatus:@"上传中" maskType:SVProgressHUDMaskTypeClear];
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
                      
                      [self uploadToSelfService];
                      
                  } option:nil];
                  
              } option:nil];

}
/**
 *  上传实名信息到自己的服务器
 */
-(void)uploadToSelfService
{
    [JGHTTPClient uploadUserInfoByCardIdFront:self.frontCardIdUrl CarfIdBack:self.backCardIdUrl CardIdNum:cardIdTf.text loginId:[JGUser user].login_id realName:realNameTf.text sex:self.sex Success:^(id responseObject) {
        [SVProgressHUD dismiss];
        JGLog(@"%@",responseObject);
        if ([responseObject[@"code"]integerValue] == 200) {
            JGUser *user = [JGUser user];
            user.status = @"3";
            [JGUser saveUser:user WithDictionary:nil loginType:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        [self showAlertViewWithText:responseObject[@"message"] duration:1];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertViewWithText:[NSString stringWithFormat:@"%@",error] duration:1];
    }];
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

//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 键盘处理
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 取出键盘最终的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘弹出需要花费的时间
//    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.tableView.frame = CGRectMake(0, rect.origin.y!=SCREEN_H? -100: 0, SCREEN_W, SCREEN_H);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
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
    
    if(USER.status.intValue != 2){
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
        [btnLeft addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        btnLeft.backgroundColor = [UIColor clearColor];
        [imageViewL addSubview:btnLeft];
        
        UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        btnRight.frame = imageViewR.bounds;
        btnRight.tag = 10001;
        [btnRight addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
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
