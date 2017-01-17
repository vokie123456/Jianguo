//
//  QLTakePictures.h
//  JianGuo
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLTakePictures : NSObject

+(instancetype)aTakePhotoAToolWithComplectionBlock:(void(^)(UIImage *image))block;

@property (nonatomic,weak) UIViewController *VC;

@end
