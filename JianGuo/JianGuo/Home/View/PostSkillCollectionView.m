//
//  PostSkillCollectionView.m
//  JianGuo
//
//  Created by apple on 17/9/13.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PostSkillCollectionView.h"

#import "UIImageView+WebCache.h"
#import "NSObject+HudView.h"

#import "MineIconCell.h"
#import "TZImagePickerController.h"
#import "QNUploadManager.h"

@interface PostSkillCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,DeleteCellDelegate>

@end

@implementation PostSkillCollectionView
{
    NSIndexPath *currentIndexPath;
    
}

-(QNUploadManager *)shareQNManager
{
    static QNUploadManager *manager;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        manager = [[QNUploadManager alloc] init];
    });
    return manager;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MineIconCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MineIconCell class])];
        self.backgroundColor = WHITECOLOR;
//        [self reloadData];
    }
    return self;
}

-(void)setCount:(NSInteger)count
{
    _count = count;
    [self reloadData];
}

-(void)setImageUrlArr:(NSMutableArray *)imageUrlArr
{
    _imageUrlArr = imageUrlArr;
    [self reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
//    return CGSizeMake((self.size.width-100*2)/3, (self.size.width-100*2)/3);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageUrlArr.count) {
        if (self.imageUrlArr.count<self.count) {
            return self.imageUrlArr.count+1;
        }else{
            return self.imageUrlArr.count;
        }
    }else{
        if (self.imageArr.count==0) {
            return 1;
        }else{
            if (self.imageArr.count == _count) {
                return self.imageArr.count;
            }else{
                return self.imageArr.count+1;
            }
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MineIconCell class]) forIndexPath:indexPath];
    cell.layer.cornerRadius = 3;
    cell.delegate = self;
    
    if (self.imageUrlArr.count) {
        if (self.imageUrlArr.count == self.count) {
            cell.deleteB.hidden = NO;
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",self.imageUrlArr[indexPath.item]]] placeholderImage:[UIImage imageNamed:@"placeholderPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }else{
            if (indexPath.item == self.imageUrlArr.count) {
                
                cell.iconView.image = [UIImage imageNamed:@"jia"];
                cell.deleteB.hidden = YES;
            }else{
                cell.deleteB.hidden = NO;
                [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",self.imageUrlArr[indexPath.item]]] placeholderImage:[UIImage imageNamed:@"placeholderPic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
            }
        }
    }else{
        
        if (self.imageArr.count) {
            if (indexPath.item == self.imageArr.count) {
                cell.iconView.image = [UIImage imageNamed:@"jia"];
                cell.deleteB.hidden = YES;
            }else{
                cell.iconView.image = self.imageArr[indexPath.item];
                cell.deleteB.hidden = NO;
            }
        }
        
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger maxCount;
    if (self.imageUrlArr.count) {
        maxCount = 1;
    }else{
        if (indexPath.item<self.imageArr.count) {
            maxCount = 1;
        }else{
            maxCount = _count-self.imageArr.count;
        }
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    
    [self.window.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
    currentIndexPath = indexPath;
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    if (self.imageUrlArr.count) {
        
        if (self.imageUrlArr.count==self.count) {
            
            NSData *data = UIImageJPEGRepresentation(photos.firstObject, 0.7);
            
            JGSVPROGRESSLOAD(@"正在上传图片...");
            [[self shareQNManager] putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                [SVProgressHUD dismiss];
                if (resp == nil) {
                    [self showAlertViewWithText:@"上传图片失败" duration:1];
                    return ;
                }else{//上传图片成功后再上传个人资料
                    
                    NSString *url = [@"http://img.jianguojob.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
                    [self.imageUrlArr replaceObjectAtIndex:currentIndexPath.item withObject:url];
                    [self reloadData];
                    
                }
                
            } option:nil];
            
        }else{
            
            if (self.imageUrlArr.count == currentIndexPath.item) {
                
                NSData *data = UIImageJPEGRepresentation(photos.firstObject, 0.7);
                
                JGSVPROGRESSLOAD(@"正在上传图片...");
                [[self shareQNManager] putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    
                    [SVProgressHUD dismiss];
                    if (resp == nil) {
                        [self showAlertViewWithText:@"上传图片失败" duration:1];
                        return ;
                    }else{//上传图片成功后再上传个人资料
                        
                        NSString *url = [@"http://img.jianguojob.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
                        [self.imageUrlArr addObject:url];
                        [self reloadData];
                        
                    }
                    
                } option:nil];
                
            }else{
                NSData *data = UIImageJPEGRepresentation(photos.firstObject, 0.7);
                
                JGSVPROGRESSLOAD(@"正在上传图片...");
                [[self shareQNManager] putData:data key:nil token:USER.qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    
                    [SVProgressHUD dismiss];
                    if (resp == nil) {
                        [self showAlertViewWithText:@"上传图片失败" duration:1];
                        return ;
                    }else{//上传图片成功后再上传个人资料
                        
                        NSString *url = [@"http://img.jianguojob.com/" stringByAppendingString:[resp objectForKey:@"key"] ];
                        [self.imageUrlArr replaceObjectAtIndex:currentIndexPath.item withObject:url];
                        
                    }
                    [self reloadData];
                    
                } option:nil];
            }
            
        }
        
    }else{
        
        if (self.imageArr.count) {
            if (self.imageArr.count<_count) {
                [self.imageArr addObjectsFromArray:photos];
            }else{
                [self.imageArr replaceObjectAtIndex:currentIndexPath.item withObject:photos.firstObject];
            }
        }else{
            self.imageArr = [NSMutableArray arrayWithArray:photos];
        }
        
        [self reloadData];

    }
}

-(void)deleteCell:(UIButton *)sender
{
    MineIconCell *cell = (MineIconCell *)[[sender superview] superview];
    
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    if (self.imageUrlArr.count) {
        [self.imageUrlArr removeObjectAtIndex:indexPath.item];
    }else{
        [self.imageArr removeObjectAtIndex:indexPath.item];
    }
    
    [self reloadData];
}

-(void)uploadImage{
    
    
}

@end
