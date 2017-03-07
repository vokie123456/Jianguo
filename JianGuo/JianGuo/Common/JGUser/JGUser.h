//
//  JGUser.h
//  JianGuo
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGUser : NSObject<NSCoding>

//登录类型
typedef NS_ENUM(NSUInteger,LoginType)
{
    LoginTypeByPhone = 3,
    LoginTypeByWeChat = 1,
    LoginTypeByQQ = 2
};

//单例模式
+(instancetype)shareUser;

/** token */
@property (nonatomic, copy) NSString* token;

/** 七牛token */
@property (nonatomic, copy) NSString* qiniuToken;

/**
 *  用户的手机号
 */
@property (nonatomic, copy) NSString *tel;

/**
 *  用户密码
 */
@property (nonatomic, copy) NSString *passWord;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *iconUrl;
/**
 *  QQ或者微信登录时返回的token, 存起来用于自动登录接口
 */
@property (nonatomic, copy) NSString *qqwx_token;//
/**
 *  状态（0=被封号，1=可以登录，但没有实名认证，2=已实名认证 ,3=审核中, 4=审核被拒）
 */
@property (nonatomic, copy) NSString *status;//
/**
 *  用户登录类型
 */
@property (nonatomic, assign) NSInteger loginType;
/**
 *  用户出生日期
 */
@property (nonatomic, copy) NSString* birthDay;
/**
 *  用户是否是学生(1==是,2==否)
 */
@property (nonatomic, assign) NSString* is_student;
/**
 *  用户身高
 */
@property (nonatomic, assign) NSString* height;
/**
 *  个人简介
 */
@property (nonatomic, assign) NSString* introduce;
/**
 *  用户的登录ID
 */
@property (nonatomic,copy) NSString *login_id;//
/**
 *  用户积分
 */
@property (nonatomic,copy) NSString *integral;//积分
/**
 *  注册时间
 */
@property (nonatomic,copy) NSString *regedit_time;//
/**
 *  登录时间
 */
@property (nonatomic,copy) NSString *login_time;//
/**
 *  信用值
 */
@property (nonatomic,copy) NSString *credit;//
/**
 *  实名认证（int型：0=没有认证，1=已认证）
 */
@property (nonatomic,copy) NSString *realname;//
/**
 *  用户所在学校
 */
@property (nonatomic,copy) NSString *school_name;
/**
 *  用户所在学校id
 */
@property (nonatomic,copy) NSString *schoolId;
/**
 *  用户名字
 */
@property (nonatomic,copy) NSString *name;
/**
 *  简历状态(填写=1,没填=0)
 */
@property (nonatomic,copy) NSString *resume;
/**
 *  用户性别(男=2,女=1)
 */
@property (nonatomic,copy) NSString *gender;
/**
 *  偏好设置
 */
@property (nonatomic,copy) NSString *hobby;
/**
 *  简历状态(填写=1,没填=0)
 */
//@property (nonatomic,copy) NSString *resume;



+ (instancetype)userWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+(void)saveUser:(JGUser *)user WithDictionary:(NSDictionary *)dic loginType:(LoginType)loginType;

+(void)savePassWord:(NSString *)passWord;

/**
 *  返回存储的账号信息
 */
+ (JGUser *)user;
/**
 *  删除本地的用户信息 以达到退出账号效果
 */
+ (void)deleteuser;

@end
