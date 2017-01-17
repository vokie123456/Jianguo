//
//  ShowMoreView.h
//  JianGuo
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMoreView : UIView
/**
 *  显示更多view
 */
+(instancetype)aShowMoreView;
-(void)show;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
