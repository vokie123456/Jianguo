//
//  ChatNoticeOrMetionView.m
//  JianGuo
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "ChatNoticeOrMetionView.h"

@interface ChatNoticeOrMetionView()
{
    
}
@property (nonatomic,strong) UIButton *noticeBtn;
@property (nonatomic,strong) UIButton *metionBtn;
@end

@implementation ChatNoticeOrMetionView

+(instancetype)aNoticeOrMetionView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ChatNoticeOrMetionView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib
{
    CGRect rect = self.frame;
    rect.size.width = SCREEN_W;
    self.frame = rect;
    
    self.noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.noticeBtn.frame = self.noticeView.bounds;
    [self.noticeBtn addTarget:self action:@selector(clickNotice:) forControlEvents:UIControlEventTouchUpInside];
    [self.noticeView addSubview:self.noticeBtn];
    
    self.metionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.metionBtn.frame = self.metionView.bounds;
    [self.metionBtn addTarget:self action:@selector(clickMetion:) forControlEvents:UIControlEventTouchUpInside];
    [self.metionView addSubview:self.metionBtn];
}

-(void)clickNotice:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(clickNotice:)]) {
        [self.delegate clickNotice:btn];
    }
}

-(void)clickMetion:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(clickMetion:)]) {
        [self.delegate clickMetion:btn];
    }
}

@end
