//
//  FunsModel.h
//  JianGuo
//
//  Created by apple on 17/6/26.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FunsModel : NSObject
/** 用户id */
@property (nonatomic,copy) NSString *userId;
/** 用户头像 */
@property (nonatomic,copy) NSString *userHeadImage;
/** 用户昵称 */
@property (nonatomic,copy) NSString *userName;
/** 性别 */
@property (nonatomic,copy) NSString *sex;
/** 学校名称 */
@property (nonatomic,copy) NSString *userSchoolName;
/** 是否关注< 1==已关注  0==未关注 > */
@property (nonatomic,copy) NSString *isFollow;

/** 是否关注 */
@property (nonatomic,assign) BOOL isFollowed;
/** 数据类型 < 0==关注列表数据  1==粉丝数据> */
@property (nonatomic,copy) NSString *type;



@end

