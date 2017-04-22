//
//  NotiNewsModel.h
//  JianGuo
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotiNewsModel : NSObject

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 用户的登录ID */
@property (nonatomic, copy) NSString*  b_user_id;

/** 兼职id */
@property (nonatomic, copy) NSString* job_id;

/** 兼职名称 */
@property (nonatomic, copy) NSString* job_name;

/** 通知消息的内容 */
@property (nonatomic, copy) NSString* content;

/** 通知消息ID */
@property (nonatomic, copy) NSString*  id;

/** 推送时间 */
@property (nonatomic, copy) NSString* time;

/** 消息标题 */
@property (nonatomic, copy) NSString* title;

/** 消息类别  */
@property (nonatomic, copy) NSString*  type;

/** 跳转的Url  */
@property (nonatomic, copy) NSString*  html_url;

@end
