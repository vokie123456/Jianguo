//
//  SkillExpertModel.h
//  JianGuo
//
//  Created by apple on 17/8/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkillExpertModel : NSObject


/** 达人称谓 */
@property (nonatomic, copy) NSString* masterTitle;

/** 是否关注 */
@property (nonatomic, assign) NSInteger  isFollow;

/** 达人的用户id */
@property (nonatomic, assign) NSInteger  uid;

/** 达人头像 */
@property (nonatomic, copy) NSString* headImg;

/** 达人昵称 */
@property (nonatomic, copy) NSString* nickname;

@end
