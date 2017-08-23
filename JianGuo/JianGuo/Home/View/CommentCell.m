//
//  CommentCell.m
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
#import "TTTAttributedLabel.h"
#import "DateOrTimeTool.h"
#import <UIImageView+WebCache.h>

static NSString*const identifier = @"CommentCell";

@interface CommentCell() <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *publisherL;



@end

@implementation CommentCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    }
    return cell;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.publisherL .hidden = YES;
}

-(void)setModel:(CommentModel *)model
{
    _model = model;
    JGLog(@"pid === %@",model.pid);
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameL.text = model.nickname.length?model.nickname:@"未填写";
    self.timeL.text = [DateOrTimeTool getDateStringBytimeStamp:[model.createTime substringToIndex:10].floatValue];
    self.contentL.text = model.content.length?model.content:@" ";
    if (model.pid.integerValue>0) {
        self.iconViewLeftCons.constant = 65;
        self.lineViewLeftCons.constant = 65;
    }else{
        self.iconViewLeftCons.constant = 20;
        self.lineViewLeftCons.constant = 20;
    }
    if (model.isPublishUser.boolValue) {
        self.publisherL.hidden = NO;
    }else{
        self.publisherL.hidden = YES;
    }
    
}

//-(void)setModel:(CommentModel *)model
//{
//    _model = model;
//    CommentModel *commentModel1 = model;
//    
//    self.timeL.text = [DateOrTimeTool getDateStringBytimeStamp:model.create_time.floatValue];
//    
//    NSString *name;
//    NSString *content;
//    NSRange range;
//    NSURL *url;
//    if (model.users.count==2) {
//        CommentUser *user1 = commentModel1.users.firstObject;
//        CommentUser *user2 = commentModel1.users.lastObject;
//        
//        if (user1.userId.integerValue == model.user_id.integerValue) {//user1是评论者
//            name = user1.nickname;
//            
//            [self.iconView sd_setImageWithURL:[NSURL URLWithString:user1.userImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
//            if (user2.userId.integerValue!=self.postUserId.integerValue) {//即 "C<自己>" 在 "A" 的任务下边回复 "B" 的评论
//                
//                content = [NSString stringWithFormat:@"回复 %@ :",user2.nickname];
//                range = [content rangeOfString:user2.nickname];
//                url = [NSURL URLWithString:user2.userId];
//                
//                [self.iconView sd_setImageWithURL:[NSURL URLWithString:user1.userImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
//            }else{// "A<自己>" 评论 "B" 的任务
//                [self.contentL setText:model.content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//                    [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
//                    
//                    return mutableAttributedString;
//                }];
//                
//                self.nameL.text = name;
//                return;
//            }
//        }else{//user2是评论者
//            name = user2.nickname;
//            [self.iconView sd_setImageWithURL:[NSURL URLWithString:user2.userImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
//            if (user1.userId.integerValue != self.postUserId.integerValue) {//即 "C<自己>" 在 "A" 的任务下边回复 "B" 的评论
//                content = [NSString stringWithFormat:@"回复 %@ :",user1.nickname];
////                content = @"";
//                range = [content rangeOfString:user1.nickname];
//                url = [NSURL URLWithString:user1.userId];
//                
//                [self.iconView sd_setImageWithURL:[NSURL URLWithString:user2.userImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
//            }else{// "A<自己>" 评论 "B" 的任务
//                [self.contentL setText:model.content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//                    [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
//                    
//                    return mutableAttributedString;
//                }];
//                self.nameL.text = name;
//                return;
//            }
//        }
//        [self.contentL setText:[content stringByAppendingString:model.content] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//            [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
//            
//            return mutableAttributedString;
//        }];
//        
//        UIFont *boldSystemFont = [UIFont systemFontOfSize:15];
//        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
//        //添加点击事件
//        self.contentL.enabledTextCheckingTypes = NSTextCheckingTypeLink;
//        
//        self.contentL.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:GreenColor};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
//        CFRelease(font);
//        
//        [self.contentL addLinkToURL:url withRange:range];
//        
//        
//    }else{//评论对象中只有一个用户,即 <自己评论自己的需求> 情况
//        
//        CommentUser *user1 = commentModel1.users.firstObject;
//        name = user1.nickname;
//        [self.contentL setText:model.content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//            [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
//            
//            return mutableAttributedString;
//        }];
//        [self.iconView sd_setImageWithURL:[NSURL URLWithString:user1.userImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
//    }
//    
//    self.nameL.text = name;
//    
//    
//    
//}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *userId = [NSString stringWithFormat:@"%@",url];
    JGLog(@"%@",userId);
    
}

- (void)awakeFromNib {

    self.contentL.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showIcon:)];
    [self.iconView addGestureRecognizer:tap];
    
}

-(void)showIcon:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(clickIcon:)]) {
        [self.delegate clickIcon:_model.userId];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
