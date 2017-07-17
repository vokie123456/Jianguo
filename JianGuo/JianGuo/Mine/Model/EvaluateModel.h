//
//  EvaluateModel.h
//  JianGuo
//
//  Created by apple on 17/6/23.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluateModel : NSObject

/** 数据id */
@property (nonatomic, copy) NSString*  id;

/** 创建人学校 */
@property (nonatomic, copy) NSString* school;

/** 任务图片 */
@property (nonatomic, copy) NSString* d_image;

/** 评论内容 */
@property (nonatomic, copy) NSString*  comment;

/** 评价类型(1接单者评价，2发布者评价） */
@property (nonatomic, copy) NSString*  type;

/** 创建者id */
@property (nonatomic, copy) NSString*  userId;

/** 创建时间戳 */
@property (nonatomic, copy) NSString*  createTime;

/** 创建时间串 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 创建者昵称 */
@property (nonatomic, copy) NSString* nickName;

/** 需求类型 */
@property (nonatomic, copy) NSString*  d_type;

/** 需求标题 */
@property (nonatomic, copy) NSString* d_title;

/** 需求描述 */
@property (nonatomic, copy) NSString* d_describe;

/** 需求id */
@property (nonatomic, copy) NSString*  demandId;

/** 创建者头像 */
@property (nonatomic, copy) NSString* headImgUrl;


@end
