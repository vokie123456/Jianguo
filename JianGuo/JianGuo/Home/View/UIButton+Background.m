//
//  UIButton+Background.m
//  JianGuo
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "UIButton+Background.h"

@implementation UIButton (Background)

/**
 *  不带边框
 */
-(void) setRedBGAndWhiteTittle:(NSString*)tittle
{
    [self setTitle:tittle forState:UIControlStateNormal];
    [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [self setBackgroundColor:RGBCOLOR(255, 115, 115)];
    self.layer.borderWidth = 0;
}
/**
 *  带边框
 */
-(void) setWhiteBGAndGrayTittle:(NSString*)tittle
{
    [self setTitle:tittle forState:UIControlStateNormal];
    [self setTitleColor:LIGHTGRAYTEXT forState:UIControlStateNormal];
    [self setBackgroundColor:WHITECOLOR];
    
}

/**
 * 不带边框  灰底白字
 */
-(void) setGrayBGAndWhiteTittle:(NSString*)tittle
{
    [self setTitle:tittle forState:UIControlStateNormal];
    [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [self setBackgroundColor:RGBCOLOR(200, 200 , 200) ];
    self.layer.borderWidth = 0;
    self.userInteractionEnabled = NO;
}
/**
 * 不带边框  黄底白字
 */
-(void) setYellowBGAndWhiteTittle:(NSString*)tittle
{
    [self setTitle:tittle forState:UIControlStateNormal];
    [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [self setBackgroundColor:YELLOWCOLOR];
    self.layer.borderWidth = 0;

}
/**
 * 不带边框  灰底白字
 */
-(void) setEnableGrayAndWhite:(NSString*)tittle
{
    [self setTitle:tittle forState:UIControlStateNormal];
    [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [self setBackgroundColor:RGBCOLOR(200, 200 , 200)];
    self.layer.borderWidth = 0;
    self.userInteractionEnabled = YES;
}

@end
