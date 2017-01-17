//
//  ImagesModel.h
//  JianGuo
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagesModel : NSObject

/** 轮播图的id */
@property (nonatomic, copy) NSString * id;

/** 图片 */
@property (nonatomic, copy) NSString* image;

/** 跳转的url */
@property (nonatomic, copy) NSString* url;

@end
