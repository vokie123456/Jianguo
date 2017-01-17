//
//  UpdateView.m
//  JianGuo
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "UpdateView.h"
@interface UpdateView()
{
    
    __weak IBOutlet UIView *bgView;
    void (^cancelBlock)();
    void (^sureBlock)();
}

@end
@implementation UpdateView

+(instancetype)aUpdateViewCancelBlock:(void(^)())cancelBlock sureBlock:(void(^)())sureBlock
{
    UpdateView *view = [[[NSBundle mainBundle] loadNibNamed:@"UpdateView" owner:nil options:nil]lastObject];
    
    view -> cancelBlock = cancelBlock;
    view -> sureBlock = sureBlock;
    
    return view;
    
}

-(void)show
{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0f];
    self.frame = APPLICATION.keyWindow.bounds;
    [APPLICATION.keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)cancel:(UIButton *)sender {
    
    if (cancelBlock) {
        cancelBlock();
    }
    [self dismiss];
}
- (IBAction)sureToUpdate:(UIButton *)sender {
    
    if (sureBlock) {
        sureBlock();
    }
    [self dismiss];
}


@end
