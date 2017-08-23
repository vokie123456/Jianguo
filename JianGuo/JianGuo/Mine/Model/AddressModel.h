//
//  AddressModel.h
//  JianGuo
//
//  Created by apple on 17/8/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject


/** 地址id */
@property (nonatomic, copy) NSString*  id;

/** 电话 */
@property (nonatomic, copy) NSString*  mobile;

/** 是否是默认地址 */
@property (nonatomic, assign) NSInteger  isDefault;

/** 具体位置描述 */
@property (nonatomic, copy) NSString* location;

/** 联系人姓名 */
@property (nonatomic, copy) NSString* consignee;

@end
