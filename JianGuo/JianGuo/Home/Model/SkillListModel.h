//
//  SkillListModel.h
//  JianGuo
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkillListModel : NSObject


/** 技能状态（0正常状态，1暂停接单） */
@property (nonatomic, assign) NSInteger  status;

/** 技能标题 */
@property (nonatomic, copy) NSString* title;

/** 平均评分 */
@property (nonatomic, assign) CGFloat  averageScore;

/** 学校id */
@property (nonatomic, assign) NSInteger  schoolId;

/** 分类名称 */
@property (nonatomic, copy) NSString* categoryName;

/** 分布人的昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 浏览数 */
@property (nonatomic, assign) NSInteger  viewCount;

/** 发布到的学校名称 */
@property (nonatomic, copy) NSString* schoolName;

/** 头像 */
@property (nonatomic, copy) NSString* headImg;

/** 销量 */
@property (nonatomic, assign) NSInteger  saleCount;

/** 技能id */
@property (nonatomic, assign) NSInteger  skillId;

/** 技能封面 */
@property (nonatomic, copy) NSString* cover;

/** 发布时间串 */
@property (nonatomic, copy) NSString* createTimeStr;

/** 是否收藏 */
@property (nonatomic, assign) NSInteger  isFavourite;

/** 达人称谓 */
@property (nonatomic, copy) NSString* masterTitle;

/** 是不是达人 */
@property (nonatomic, assign) NSInteger  isMaster;

/** 技能资质描述 */
@property (nonatomic, copy) NSString* skillAptitude;

/** 城市code */
@property (nonatomic, assign) NSInteger  cityCode;

/** 评论数 */
@property (nonatomic, assign) NSInteger  commentCount;

/** 创建时间戳 */
@property (nonatomic, assign) NSInteger  createTime;

/** 点赞数 */
@property (nonatomic, assign) NSInteger  likeCount;

/** 发布到城市名称 */
@property (nonatomic, copy) NSString* cityName;

/** 技能价格 */
@property (nonatomic, assign) CGFloat  price;

/** 分类id */
@property (nonatomic, assign) NSInteger  categoryId;

/** 技能描述 */
@property (nonatomic, copy) NSString* skillDesc;

@end
