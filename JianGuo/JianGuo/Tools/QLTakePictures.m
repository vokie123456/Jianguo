//
//  QLTakePictures.m
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "QLTakePictures.h"


@interface QLTakePictures()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    void (^completionBlock)(UIImage *);
}

@end

@implementation QLTakePictures


+(instancetype)aTakePhotoAToolWithComplectionBlock:(void(^)(UIImage *image))block
{
    QLTakePictures *tool = [[QLTakePictures alloc] init];
    tool -> completionBlock = block;
    return tool;
}

-(void)setVC:(UIViewController *)VC
{
    _VC = VC;
    [self takePhoto];
}

-(void)takePhoto
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        
                                                        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                        imagePickerController.allowsEditing = NO;//不允许裁剪图片
                                                        imagePickerController.delegate = self;
                                                        
                                                        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                            
                                                        } else {
                                                            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                        }
                                                        [self.VC presentViewController:imagePickerController animated:YES completion:nil];
                                                        
                                                    }];
    [actionSheetController addAction:action0];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"从手机相册中选择"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                                       imagePickerController.allowsEditing = NO;//不允许裁剪图片
                                                       imagePickerController.delegate = self;
                                                       
                                                       imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                       [self.VC presentViewController:imagePickerController animated:YES completion:nil];
                                                       
                                                   }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    
    [actionSheetController addAction:action];
    [actionSheetController addAction:actionCancel];
    
    [self.VC presentViewController:actionSheetController animated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.VC dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    JGLog(@"%@",info);
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //压缩图片
//    image = [self imageByScalingAndCroppingForSize:CGSizeMake(image.size.width/8, image.size.height/8) sourceImage:image];
    

//    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
//    JGLog(@"%lu",(unsigned long)data.length);
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
    
    completionBlock(image);//把图片传给block
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.VC = nil;

    
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
        JGLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)dealloc{
    JGLog(@"%@ #********** dealloc",NSStringFromClass([self class]));
}

@end
