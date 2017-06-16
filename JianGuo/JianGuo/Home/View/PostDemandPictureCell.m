//
//  PostDemandPictureCell.m
//  JianGuo
//
//  Created by apple on 17/6/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PostDemandPictureCell.h"
#import "MineIconCell.h"

#import "TZImagePickerController.h"

#import "QLAlertView.h"

@interface PostDemandPictureCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,TZImagePickerControllerDelegate,DeleteCellDelegate>
{
    __weak IBOutlet UICollectionView *_collectionView;
    
    UILongPressGestureRecognizer *_longPress;
}
@end

@implementation PostDemandPictureCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    PostDemandPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setImagesArr:(NSArray *)imagesArr
{
    _imagesArr = imagesArr;
    [_collectionView reloadData];
}

- (void)awakeFromNib {
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MineIconCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MineIconCell class])];
    [_collectionView reloadData];
    _imagesArr = @[];
}



#pragma mark---btn的删除cell事件

-(void)deleteCell:(UIButton *)sender
{
//    NSIndexPath *indexPath  = [NSIndexPath indexPathForItem:sender.tag inSection:0];
//    MineIconCell *cell = (MineIconCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray *mutableArr = self.imagesArr.mutableCopy;
    [mutableArr removeObjectAtIndex:sender.tag];
    self.imagesArr = (NSArray *)mutableArr;
    if ([self.delegate respondsToSelector:@selector(refreshCollectionView:)]) {
        [self.delegate refreshCollectionView:self.imagesArr];
    }
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArr.count==0?1:self.imagesArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MineIconCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.deleteB.tag = indexPath.item;
    cell.deleteB.hidden = indexPath.item == self.imagesArr.count-1?YES:NO;
    if (self.imagesArr.count == 0) {
        cell.deleteB.hidden = YES;
        cell.iconView.image = [UIImage imageNamed:@"jia"];
    }else{
        cell.iconView.image = self.imagesArr[indexPath.item];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.imagesArr.count == 0 || (self.imagesArr.count!=0 && self.imagesArr.count-1 == indexPath.item)) {
        
        if (self.imagesArr.count>9) {
            
            [QLAlertView showAlertTittle:@"最多只能选择9张图片" message:nil isOnlySureBtn:YES compeletBlock:nil];
            
            return;
        }
        
        NSInteger count = self.imagesArr.count == 0?9:(10 - self.imagesArr.count);
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
        imagePickerVc.allowPickingVideo = NO;
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        //    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        //
        //    }];
        [self.window.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
    }else{//可以预览
        
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W-20-15)/4, (SCREEN_W-20-15)/4);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark TZImagePickerController Delegate
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
//    if ((self.imagesArr.count+photos.count)>9) {
//        [QLAlertView showAlertTittle:@"最多只能选择9张图片" message:nil isOnlySureBtn:YES compeletBlock:nil];
//        return;
//    }
    NSMutableArray *imgsArr = [NSMutableArray array];
    if (self.imagesArr.count) {
        imgsArr =self.imagesArr.mutableCopy;
        [imgsArr removeObject:imgsArr.lastObject];
    }
    [imgsArr addObjectsFromArray:photos];
    UIImage *image = [UIImage imageNamed:@"jia"];
    [imgsArr addObject:image];
    self.imagesArr = (NSArray *)imgsArr;
    
    if ([self.delegate respondsToSelector:@selector(refreshCollectionView:)]) {
        [self.delegate refreshCollectionView:self.imagesArr];
    }
}


@end
