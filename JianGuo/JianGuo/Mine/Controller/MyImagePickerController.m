//
//  MyImagePickerController.m
//  JianGuo
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MyImagePickerController.h"
#import "QLAlertView.h"

@interface MyImagePickerController ()<UIImagePickerControllerDelegate>
{
    UILabel *label;
    UIImageView *imgView;
    UIButton *btn;
    BOOL _isTakedPicture;
}
@end

@implementation MyImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_W-80, 40)];
        label.text = @"请横屏拍照(屏幕右上角的 📷 图标横向过来的时候才是横屏拍照哦!)";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = BOLDFONT(15);
        label.textColor = RedColor;
        [self.view addSubview:label];
        
//        imgView = [[UIImageView alloc] init];
//        imgView.image = [UIImage imageNamed:@"metion"];
//        imgView.bounds = CGRectMake(0, 0, SCREEN_W, 132*(SCREEN_W/229));
//        CGPoint point = CGPointMake(SCREEN_W/2, SCREEN_H/2-150);
//        imgView.center = point;
//        [self.view addSubview:imgView];
        
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(100, SCREEN_H-100, SCREEN_W-200, 100);
//        [btn setBackgroundColor:[UIColor clearColor]];
//        //    [btn setTitle:@"这样拍照不行哦!" forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(showAlertStr) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [APPLICATION setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [APPLICATION setStatusBarHidden:NO];
}

-(void)showAlertStr
{
//    [QLAlertView showAlertTittle:@"为了您的证件能快速通过审核,请横屏拍照!" message:nil];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"为了您的证件能快速通过审核,请横屏拍照!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAC];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)orientChange:(NSNotification *)noti

{
    
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    
    /*
     
     UIDeviceOrientationUnknown,
     
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     
     UIDeviceOrientationFaceDown             // Device oriented flat, face down   */
    
    
    
    switch (orient)
    
    {
            
        case UIDeviceOrientationPortrait:
            
            if (_isTakedPicture) {
                label.hidden = YES;
//                imgView.hidden = YES;
                btn.hidden = YES;
            }else{
                label.hidden = NO;
//                imgView.hidden = NO;
                btn.hidden = NO;
            }
            
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            
            
            label.hidden = YES;
//            imgView.hidden = YES;
            btn.hidden = YES;
            
//            [imgView removeFromSuperview];
            
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            
            if (_isTakedPicture) {
                label.hidden = YES;
//                imgView.hidden = YES;
                btn.hidden = YES;
            }else{
                label.hidden = NO;
//                imgView.hidden = NO;
                btn.hidden = NO;
            }
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            
            
            label.hidden = YES;
            imgView.hidden = YES;
            btn.hidden = YES;
            [imgView removeFromSuperview];
            
            break;
            
            
            
        default:
            
            break;
            
    }
    
}



@end
