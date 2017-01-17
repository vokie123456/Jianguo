//
//  AvatarBrowser.m
//  butler_iOS
//
//  Created by MrChenMj on 15/7/15.
//  Copyright (c) 2015年 dasmaster. All rights reserved.
//

#import "AvatarBrowser.h"
static CGRect oldframe;
@interface AvatarBrowser()
@property (nonatomic,strong) UIImageView *iconView;
@end
@implementation AvatarBrowser

+(instancetype)shareAvartView
{
    static AvatarBrowser *avartView=nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        avartView = [[AvatarBrowser alloc] init];
    });
    return avartView;
}

+(void)showImage:(UIImageView *)avatarImageView{
//    AvatarBrowser *avartView = [AvatarBrowser shareAvartView];
//    avartView.iconView = avatarImageView;
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    //添加一个保存按钮
//    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    saveBtn.showsTouchWhenHighlighted = YES;
//    saveBtn.layer.cornerRadius = 3;
//    saveBtn.layer.masksToBounds = YES;
//    saveBtn.frame = CGRectMake(SCREEN_W/2-30, SCREEN_H-50, 60, 25);
//    saveBtn.titleLabel.font = FONT(14);
//    saveBtn.layer.borderWidth = 1;
//    saveBtn.layer.borderColor = RedColor.CGColor;
//    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
//    [saveBtn setTitleColor:RedColor forState:UIControlStateNormal];
//    [saveBtn addTarget:avartView action:@selector(tapSaveImageToIphone) forControlEvents:UIControlEventTouchUpInside];
//    [backgroundView addSubview:saveBtn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}


- (void)tapSaveImageToIphone{
    
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    UIImageWriteToSavedPhotosAlbum(self.iconView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

@end
