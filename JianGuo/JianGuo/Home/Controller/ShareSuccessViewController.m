//
//  ShareSuccessViewController.m
//  JianGuo
//
//  Created by apple on 17/7/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "ShareSuccessViewController.h"

#import <ShareSDK/ShareSDK.h>


@interface ShareSuccessViewController ()

@end

@implementation ShareSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITECOLOR;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = WHITECOLOR;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = WHITECOLOR;
}

- (IBAction)share:(id)sender {
    UIButton *btn = sender;
    
    [self shareCommon:btn.tag];

    [self close:nil];
}

-(void)shareCommon:(NSInteger)platformType
{
    SSDKPlatformType type;
    switch (platformType) {
        case 1000:{//微信朋友
            
            type = SSDKPlatformSubTypeWechatSession;
            
            break;
        } case 1001:{//QQ空间
            
            type = SSDKPlatformSubTypeQZone;
            
            break;
        } case 1002:{//QQ好友
            
            type = SSDKPlatformSubTypeQQFriend;
            
            break;
        } case 1003:{//朋友圈
            
            type = SSDKPlatformSubTypeWechatTimeline;
            
            break;
        }
        default:
            break;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *backURL = [NSString stringWithFormat:@"http://www.woniukeji.com.cn:8888/share-demand?demandId=%@",self.demandId];
    NSArray* imageArray = @[[UIImage imageNamed:@"logo"]];
    NSString *text = [NSString stringWithFormat:@"【%@】––> %@",self.demandTitle,[NSString stringWithFormat:@"赏金:%@ 元",self.money]];
    [shareParams SSDKSetupShareParamsByText:text images:imageArray url:[NSURL URLWithString:backURL] title:@"来嘛~帮帮忙，反正有大把时光" type:SSDKContentTypeAuto];
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

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
