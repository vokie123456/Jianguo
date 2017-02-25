//
//  JianliAccount.h
//  JianGuo
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JianliAccount : NSObject

//单例模式
+(instancetype)shareJianLiAccount;

+(JianliAccount *)account;

+(void)saveAccountWithDictionary:(NSDictionary *)dic;



@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *head_img_url;

@property (nonatomic,copy) NSString *height;

@property (nonatomic,copy) NSString *birth_date;

@property (nonatomic,copy) NSString *is_student;

@property (nonatomic,copy) NSString *school_name;

@property (nonatomic,copy) NSString *school_id;

@property (nonatomic,copy) NSString *sex;

@property (nonatomic,copy) NSString *qq;

@property (nonatomic,copy) NSString *email;

@property (nonatomic,copy) NSString *introduce;

@property (nonatomic,copy) NSString *constellation;

/**** 以上为新接口返回的数据 *****/
@property (nonatomic,copy) NSString *login_id;

@property (nonatomic,copy) NSString *intoschool_date;

@property (nonatomic,copy) NSString *shoe_size;

@property (nonatomic,copy) NSString *clothing_size;


@end
