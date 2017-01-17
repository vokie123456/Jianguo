//
//  JGIMClient.m
//  JianGuo
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JGIMClient.h"
#import <AVOSCloudIM.h>
@interface JGIMClient()
{
    AVIMClient *clientEnd;
}
@end
@implementation JGIMClient

+(instancetype)shareJgIm
{
    static JGIMClient *jgImclient = nil;
    static dispatch_once_t oncetoken ;
    dispatch_once(&oncetoken, ^{
        jgImclient = [[JGIMClient alloc] init];
    });
    return jgImclient;
}

//-(AVIMClient *)shareAClient
//{
//    if (![JGIMClient shareJgIm].client) {
//        [JGIMClient shareJgIm].client = [[AVIMClient alloc] initWithClientId:[NSString stringWithFormat:@"%@",USER.login_id]];
//    }
//    return [JGIMClient shareJgIm].client;
//}

-(AVIMClient *)getAclient
{
    if (!clientEnd) {
        clientEnd = [[AVIMClient alloc] initWithClientId:[NSString stringWithFormat:@"%@",USER.login_id]];
    }
    return clientEnd;
}

-(void)setNull
{
    clientEnd  = nil;
    JGLog(@"%@",clientEnd);
}


@end
