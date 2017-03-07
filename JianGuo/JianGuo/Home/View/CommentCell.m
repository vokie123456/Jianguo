//
//  CommentCell.m
//  JianGuo
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
#import "CommentUser.h"
#import "TTTAttributedLabel.h"
#import "DateOrTimeTool.h"
#import <UIImageView+WebCache.h>

static NSString*const identifier = @"CommentCell";

@interface CommentCell() <TTTAttributedLabelDelegate>


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

-(void)setModel:(CommentModel *)model
{
    _model = model;
    CommentModel *commentModel1 = model;
    
    self.timeL.text = [DateOrTimeTool getDateStringBytimeStamp:model.create_time.floatValue];
    
    NSString *name;
    NSString *content;
    NSRange range;
    NSURL *url;
    if (model.users.count==2) {
        CommentUser *user1 = commentModel1.users.firstObject;
        CommentUser *user2 = commentModel1.users.lastObject;
        
        if (user1.userId.integerValue == model.user_id.integerValue) {//user1是评论者
            name = user1.nickname;
            content = [NSString stringWithFormat:@"回复 %@ :",user2.nickname];
            range = [content rangeOfString:user2.nickname];
            url = [NSURL URLWithString:user2.userId];
            
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:user1.userImage] placeholderImage:[UIImage imageNamed:@"wechat"]];
        }else{//user2是评论者
            name = user2.nickname;
//            content = [NSString stringWithFormat:@"回复 %@ :",user1.nickname];
            content = @"";
            range = [content rangeOfString:user1.nickname];
            url = [NSURL URLWithString:user1.userId];
            
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:user2.userImage] placeholderImage:[UIImage imageNamed:@"wechat"]];
        }
        [self.contentL setText:[content stringByAppendingString:model.content] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
            
            return mutableAttributedString;
        }];
        
        UIFont *boldSystemFont = [UIFont systemFontOfSize:15];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        //添加点击事件
        self.contentL.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        
        self.contentL.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:GreenColor};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
        CFRelease(font);
        
        [self.contentL addLinkToURL:url withRange:range];
        
        
    }else{//评论对象中只有一个用户,即 <自己评论自己的需求> 情况
        
        CommentUser *user1 = commentModel1.users.firstObject;
        name = user1.nickname;
        [self.contentL setText:model.content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
            
            return mutableAttributedString;
        }];
    }
    
    self.nameL.text = name;
    
    
    
    
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *userId = [NSString stringWithFormat:@"%@",url];
    JGLog(@"%@",userId);
    
}

- (void)awakeFromNib {

    self.contentL.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
