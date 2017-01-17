//
//  CommetInputView.h
//  JianGuo
//
//  Created by apple on 17/1/14.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinishEditDelegate <NSObject>

-(void)finishEdit;


@end

@interface CommentInputView : UIView


@property (nonatomic,weak) id<FinishEditDelegate> delegate;


@property (weak, nonatomic) IBOutlet UITextView *commentTV;

+(instancetype)aReplyCommentView:(void(^)(NSString *))completionBlock;

@end
