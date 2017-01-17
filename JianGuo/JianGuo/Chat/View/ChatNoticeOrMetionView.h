//
//  ChatNoticeOrMetionView.h
//  JianGuo
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotiAndMetionDelegate <NSObject>

-(void)clickNotice:(UIButton *)btn;
-(void)clickMetion:(UIButton *)btn;

@end

@interface ChatNoticeOrMetionView : UIView

+(instancetype)aNoticeOrMetionView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIView *metionView;
@property (nonatomic,weak) id <NotiAndMetionDelegate> delegate;

@end
