//
//  CommentView.h
//  JianGuo
//
//  Created by apple on 17/1/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView

+(instancetype)aReplyCommentView:(void(^)(NSString *))completionBlock;
-(void)dismiss;
-(void)show;

@end
