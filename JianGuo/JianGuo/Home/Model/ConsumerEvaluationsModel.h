//
//  ConsumerEvaluationsModel.h
//  JianGuo
//
//  Created by apple on 17/8/11.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumerEvaluationsModel : NSObject

/** 评价分数 */
@property (nonatomic, assign) CGFloat  score;

/** 用户id */
@property (nonatomic, assign) NSInteger  uid;

/** 用户昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 评价内容 */
@property (nonatomic, copy) NSString* content;

/** 用户学校名称 */
@property (nonatomic, copy) NSString* schoolName;

/** 评价时间字符串 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 头像 */
@property (nonatomic, copy) NSString* headImg;

/** 评价时间戳 */
@property (nonatomic, assign) NSInteger  createTime;

@end
