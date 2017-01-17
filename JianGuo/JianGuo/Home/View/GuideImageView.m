//
//  GuideImageView.m
//  JianGuo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "GuideImageView.h"

@implementation GuideImageView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.count++;
    if (self.count > 5) {
        [self removeFromSuperview];
    }else{
        self.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_guide%ld",(long)self.count]];
        if (self.count ==1||self.count == 2) {
            if (SCREEN_W==375||SCREEN_W == 414) {
                self.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_guide6s%ld",(long)self.count]];
            }
//            else if (SCREEN_W == 414){
//                self.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_guide6p%ld",(long)self.count]];
//            }
        }
    }
}

@end
