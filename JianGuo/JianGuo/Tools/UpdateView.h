//
//  UpdateView.h
//  JianGuo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateView : UIView

+(instancetype)aUpdateViewCancelBlock:(void(^)())cancelBlock sureBlock:(void(^)())sureBlock;

/**
 *  显示
 */
-(void)show;
/**
 *  消失
 */
-(void)dismiss;


@end
