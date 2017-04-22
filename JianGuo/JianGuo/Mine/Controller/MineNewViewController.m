//
//  MineNewViewController.m
//  JianGuo
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "MineNewViewController.h"
#import "MineIconCell.h"
#import "MineLayout.h"
#import "MineCollectionCell.h"
#import "MineSelectCell.h"
#import "MyPostDemandViewController.h"
#import "MySignDemandsViewController.h"
#import "EditInfoViewController.h"
#import "QLTakePictures.h"
#import "UIImageView+WebCache.h"
#import "JGHTTPClient+ImageUrl.h"
#import "QNUploadManager.h"
#import "LoginNew2ViewController.h"
#import "SettingViewController.h"
#import "MyWalletNewViewController.h"

static NSString *const identifier = @"MineIconCell";
static NSString *const identifier2 = @"MineCollectionCell";
static NSString *const identifier3 = @"MineSelectCell";


@interface MineNewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    QLTakePictures *takePic;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *images;

@end

@implementation MineNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    MineLayout *layout = [[MineLayout alloc]init];
    //    layout.itemCount = 6;
    self.collectionView.collectionViewLayout = layout;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.collectionView registerNib:[UINib nibWithNibName:identifier2 bundle:nil] forCellWithReuseIdentifier:identifier2];
        [self.collectionView registerNib:[UINib nibWithNibName:identifier3 bundle:nil] forCellWithReuseIdentifier:identifier3];
    
    self.collectionView.backgroundColor = BACKCOLORGRAY;
    
    
    UIButton * btn_r = [UIButton buttonWithType:UIButtonTypeCustom];

    [btn_r addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
    btn_r.frame = CGRectMake(0, 0, 20, 20);
    [btn_r setBackgroundImage:[UIImage imageNamed:@"icon_shezhi"] forState:UIControlStateNormal];
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_r];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
}

-(void)gotoSetting
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self checkExistPhoneNum]) {
        
        [self getImages];
        
    }else{
        self.images = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@""]];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

-(void)getImages
{
    [JGHTTPClient getImagesByUserId:USER.login_id Success:^(id responseObject) {
        self.images = responseObject[@"data"];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }else{
        return 5;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MineIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (indexPath.item == 0) {
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:USER.iconUrl] placeholderImage:[UIImage imageNamed:@"jia"]];
        }else{
            if (self.images.count>=indexPath.item) {
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:self.images[indexPath.item-1]] placeholderImage:[UIImage imageNamed:@"jia"]];
            }
        }
        return cell;
    }
    else{
        if (indexPath.item == 0) {
            MineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
            return cell;
        }
        else{
            MineSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier3 forIndexPath:indexPath];
            if (indexPath.item == 1) {
                cell.label.text = @"我的钱包";
            }else if (indexPath.item == 2){
                cell.label.text = @"我发布的";
            }else if (indexPath.item == 3){
                cell.label.text = @"我报名的";
            }else if (indexPath.item == 4){
                cell.label.text = @"兼职记录";
            }
            return cell;
        }

    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGLog(@"%ld === %ld",indexPath.section,indexPath.item);
    
    if (![self checkExistPhoneNum]) {
        [self gotoLoginVC];
        return;
    }
    
    if (indexPath.section == 0) {
        
        MineIconCell *cell = (MineIconCell *)[collectionView cellForItemAtIndexPath:indexPath];
        takePic = [QLTakePictures aTakePhotoAToolWithComplectionBlock:^(UIImage *image) {
            cell.iconView.image = image;
            
            QNUploadManager *manager = [[QNUploadManager alloc] init];
            
            NSData *data = UIImageJPEGRepresentation(image, 0.6);
            
            [manager putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                if (resp == nil) {
                    [self showAlertViewWithText:@"上传图片失败" duration:1];
                    [SVProgressHUD dismiss];
                    return ;
                }else{//上传图片成功后再上传个人资料
                    
                    NSString *url = [@"http://7xlell.com2.z0.glb.qiniucdn.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
                    if (indexPath.item == 0) {//更新的主头像
                        [JGHTTPClient updateHeadImageUrlByImage:url Success:^(id responseObject) {
                            [self showAlertViewWithText:responseObject[@"message"] duration:1];
                        } failure:^(NSError *error) {
                            [self showAlertViewWithText:NETERROETEXT duration:1];
                        }];
                    }else{//更新的另外五张图片
                        [JGHTTPClient uploadImageUrlByImage:url position:[NSString stringWithFormat:@"%ld",indexPath.row+1] Success:^(id responseObject) {
                            
                            [self showAlertViewWithText:responseObject[@"message"] duration:1];
                            
                        } failure:^(NSError *error) {
                            [self showAlertViewWithText:NETERROETEXT duration:1];
                        }];
                    }
                    
                    
                }
                
            } option:nil];
            
            takePic = nil;//防止循环引用,导致 takePic 释放不了
            
        }];
        takePic.VC = self;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.item == 0) {
            
            EditInfoViewController *editVC = [[EditInfoViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editVC];
            [self presentViewController:nav animated:YES completion:nil];
            
        }else if (indexPath.item == 1) {
            
            MyWalletNewViewController *walletVC = [[MyWalletNewViewController alloc] init];
            walletVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:walletVC animated:YES];
            
        }else if (indexPath.item == 2){
            
            MyPostDemandViewController *demandVC = [[MyPostDemandViewController alloc] init];
            demandVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:demandVC animated:YES];
            
        }else if (indexPath.item == 3){
            
            MySignDemandsViewController *demandVC = [[MySignDemandsViewController alloc] init];
            demandVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:demandVC animated:YES];

        }else if (indexPath.item == 4){
            
            
            
        }
    }
    
}

/**
 *  去登录
 */
-(void)gotoLoginVC
{
    LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
    
    //    LoginNewViewController *oldLoginVC= [[LoginNewViewController alloc]init];
    //
    //    [self.navigationController pushViewController:oldLoginVC animated:YES];
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.item == 0) {
//        return CGSizeMake(self.collectionView.width*2/3-5, self.collectionView.height*2/3-5);
//    }else{
//        return CGSizeMake(self.collectionView.width/3, self.collectionView.height/3);
//    }
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5;
//}

@end
