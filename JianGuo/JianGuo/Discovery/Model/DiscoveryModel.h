//
//  DiscoveryModel.h
//  JianGuo
//
//  Created by apple on 17/5/25.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoveryModel : NSObject

/** 评论数 */
@property (nonatomic, copy) NSString*  commentCount;

/** ??? */
@property (nonatomic, copy) NSString*  type;

/** 对应的文章链接 */
@property (nonatomic, copy) NSString* linkUrl;

/** 浏览量 */
@property (nonatomic, copy) NSString*  visitCount;

/** 文章标题 */
@property (nonatomic, copy) NSString* title;

/** 分类id */
@property (nonatomic, copy) NSString*  categoryId;

/** 文章id */
@property (nonatomic, copy) NSString*  articleId;

/** 文章配图 */
@property (nonatomic, copy) NSString* cover;

/** 点赞数量 */
@property (nonatomic, copy) NSString*  likeCount;

/** 创建时间 */
@property (nonatomic, copy) NSString*  createTime;

/** 分类名称 */
@property (nonatomic, copy) NSString* categoryName;

@end
