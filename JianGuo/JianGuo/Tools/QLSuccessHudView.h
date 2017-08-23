//
//  QLSuccessHudView.h
//  CADemos
//
//  Created by apple on 17/8/18.
//  Copyright © 2017年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLSuccessHudView : UIView

+(instancetype)shareInstance;
-(void)show:(NSString *)textStr;

@end
