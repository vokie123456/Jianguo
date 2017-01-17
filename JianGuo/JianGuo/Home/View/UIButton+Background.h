//
//  UIButton+Background.h
//  JianGuo
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Background)
/**
 *  不带边框 红底白字
 */
-(void) setRedBGAndWhiteTittle:(NSString*)tittle;
/**
 *  带边框 白底灰字
 */
//-(void) setWhiteBGAndGrayTittle:(NSString*)tittle;
/**
 * 不带边框  灰底白字
 */
-(void) setGrayBGAndWhiteTittle:(NSString*)tittle;
/**
 * 不带边框  黄底白字
 */
-(void) setYellowBGAndWhiteTittle:(NSString*)tittle;
/**
 * 不带边框  灰底白字
 */
-(void) setEnableGrayAndWhite:(NSString*)tittle;

@end
