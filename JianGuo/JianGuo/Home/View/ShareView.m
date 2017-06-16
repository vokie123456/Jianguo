//
//  ShareView.m
//  JianGuo
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "UIView+AlertView.h"

#import "DiscoveryModel.h"
#import "DetailModel.h"
#import "JianzhiModel.h"
#import "DemandModel.h"

#define INSTANCE_Y 30

@implementation ShareView

+(instancetype)aShareView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib
{
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
    self.bgView.frame = CGRectMake(0, SCREEN_H-90, SCREEN_W, 90);
    self.shareToL.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.labelBtn.frame = self.shareToL.bounds;
    
    self.QQView.frame = CGRectMake(0, INSTANCE_Y, SCREEN_W/4, 50);
    self.QQimgView.frame = CGRectMake(self.QQView.center.x - 16, 0, 32, 32);
    self.QQLabel.frame = CGRectMake(0, self.QQimgView.bottom, self.QQView.width, 20);
    self.QQBtn.frame = self.QQView.bounds;
    
    self.weChatView.frame = CGRectMake(self.QQView.right, INSTANCE_Y, SCREEN_W/4, 50);
    self.wxImgView.frame = CGRectMake(self.weChatView.width/2 - 16, 0, 32, 32);
    self.wxLabel.frame = CGRectMake(0, self.wxImgView.bottom, self.weChatView.width, 20);
    self.wxBtn.frame = self.weChatView.bounds;
    
    self.QQZoneView.frame = CGRectMake(self.weChatView.right, INSTANCE_Y, SCREEN_W/4, 50);
    self.QZoneImgView.frame = CGRectMake(self.QQZoneView.width/2 - 16, 0, 32, 32);
    self.QzoneL.frame = CGRectMake(0, self.QZoneImgView.bottom, self.QQZoneView.width, 20);
    self.QzoneBtn.frame = self.QQZoneView.bounds;
    
    self.friendCircleView.frame = CGRectMake(self.QQZoneView.right, INSTANCE_Y, SCREEN_W/4, 50);
    self.friendImgView.frame = CGRectMake(self.friendCircleView.width/2 - 16, 0, 32, 32);
    self.frienfLabel.frame = CGRectMake(0, self.friendImgView.bottom, self.friendCircleView.width, 20);
    self.friendBtn.frame = self.friendCircleView.bounds;
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}

-(void)layoutSubviews
{
  
    
}

-(void)show
{
    self.frame = [UIScreen mainScreen].bounds;
    self.bgView.transform = CGAffineTransformMakeTranslation(0, self.bgView.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        self.bgView.transform = CGAffineTransformIdentity;
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.bgView.transform = CGAffineTransformMakeTranslation(0, self.bgView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)shareToQQ:(UIButton *)sender {
    [self dismiss];
    [self goShare:SSDKPlatformSubTypeQQFriend];
}

- (IBAction)shareToWX:(id)sender {
    [self dismiss];
    [self goShare:SSDKPlatformSubTypeWechatSession];
    
}
- (IBAction)shareToQzone:(id)sender {
    [self dismiss];
    [self goShare:SSDKPlatformSubTypeQZone];
    
}
- (IBAction)shareToFriendCircle:(id)sender {
    [self dismiss];
    [self goShare:SSDKPlatformSubTypeWechatTimeline];
    
}

-(void)goShare:(SSDKPlatformType)type{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (self.isDiscvoeryVC) {
        
        NSString *backURL = _discoverModel.linkUrl;
        NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
        NSString *text = [NSString stringWithFormat:@"%@",_discoverModel.categoryName];
        [shareParams SSDKSetupShareParamsByText:text images:imageArray url:[NSURL URLWithString:backURL] title:     _discoverModel.title type:SSDKContentTypeAuto];
        
    }else{
        
        NSString *backURL = [NSString stringWithFormat:@"%@detaila?id=%@",@"http://www.woniukeji.com.cn:8888/",self.demandModel.id];
        NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
        NSString *text = [NSString stringWithFormat:@"【%@】––> %@",self.demandModel.title,[NSString stringWithFormat:@"赏金:%@ 元",self.demandModel.money]];
        [shareParams SSDKSetupShareParamsByText:text images:imageArray url:[NSURL URLWithString:backURL] title:@"来嘛~帮帮忙，反正有大把时光" type:SSDKContentTypeAuto];
        
    }
    
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [self showAlertViewWithText:@"分享成功" duration:1];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [self showAlertViewWithText:@"分享失败" duration:1];
                 break;
             }
                 
             default:
                 break;
         }
     }];
    
}

- (IBAction)cancel:(UIButton *)sender {
    
    [self dismiss];
    
}




@end
