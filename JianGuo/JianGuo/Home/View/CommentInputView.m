//
//  CommetInputView.m
//  JianGuo
//
//  Created by apple on 17/1/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CommentInputView.h"

@interface CommentInputView()<UITextViewDelegate>
{
    
}

@end

@implementation CommentInputView


+(instancetype)aReplyCommentView:(void(^)(NSString *))completionBlock
{
//    CommentInputView *view = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    static CommentInputView *view;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    });
    
    view.commentTV.layer.cornerRadius = 3;
    view.commentTV.delegate = view;
    
    return view;
}


-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat lineHeight = textView.font.lineHeight;
    
    
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(textView.size.width,   MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textView.font} context:nil];
    CGRect frame = self.frame;
    
    if (rect.size.height>lineHeight && [textView.text containsString:@"\n"]) {
        self.frame = CGRectMake(frame.origin.x, self.bottom-(rect.size.height+10), frame.size.width, rect.size.height+10);
    }
    JGLog(@"––––––––––>>>>>>>>%@",textView.text);
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if ([self.delegate respondsToSelector:@selector(finishEdit)]) {
            [self.delegate finishEdit];
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}



- (IBAction)finishEdit:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(finishEdit)]) {
        [self.delegate finishEdit];
    }
    
}

@end
