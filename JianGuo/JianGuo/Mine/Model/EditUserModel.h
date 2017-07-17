//
//  EditUserModel.h
//  JianGuo
//
//  Created by apple on 17/6/24.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditUserModel : NSObject


/** 学校id */
@property (nonatomic, copy) NSString*  schoolId;

/** 性别 */
@property (nonatomic, copy) NSString*  sex;

/** 生日 */
@property (nonatomic, copy) NSString* birthDate;

/** 入学日期 */
@property (nonatomic, copy) NSString* intoSchoolDate;

/** 家乡名称 */
@property (nonatomic, copy) NSString*  hometown;

/** 家乡code */
@property (nonatomic, copy) NSString*  hometownCode;

/** 学校名称 */
@property (nonatomic, copy) NSString* schoolName;

/** 昵称 */
@property (nonatomic, copy) NSString* nickname;

/** 头像 */
@property (nonatomic, copy) NSString* headImg;

/** 简介 */
@property (nonatomic, copy) NSString* introduce;

@end
