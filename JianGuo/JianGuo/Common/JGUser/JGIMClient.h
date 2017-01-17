//
//  JGIMClient.h
//  JianGuo
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloudIM.h>

@interface JGIMClient : NSObject

-(void)setNull;
-(AVIMClient *)getAclient;
+(instancetype)shareJgIm;
-(AVIMClient *)shareAClient;
@property (nonatomic,strong) AVIMClient *client;

@end
