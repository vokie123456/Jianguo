//
//  CommentView.m
//  JianGuo
//
//  Created by apple on 17/1/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CommentView.h"
#import "UITextView+placeholder.h"

@interface CommentView()
{
    void(^block)(NSString *);
}
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UITextView *textV;
@end

@implementation CommentView


+(instancetype)aReplyCommentView:(void(^)(NSString *))completionBlock
{
    CommentView *view = [[CommentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    view.center = APPLICATION.keyWindow.center;
    view -> block = completionBlock;
    return view;
}
-(void)dismiss
{
    
}
-(void)show
{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    self.bgView.layer.cornerRadius = 5;
    

}

@end
