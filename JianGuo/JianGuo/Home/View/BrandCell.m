//
//  BrandCell.m
//  CarPrice
//
//  Created by jun on 5/12/14.
//  Copyright (c) 2014 ATHM. All rights reserved.
//

#import "BrandCell.h"

#import "UIImageView+WebCache.h"
#import "POP.h"

@implementation BrandCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.font = FONT(15);
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.textColor =RGBCOLOR(102, 102, 102);
    self.detailLabel.font = FONT(16);
    self.detailLabel.textColor = LIGHTGRAYTEXT;
}

//- (void) resetDataWith:(MBrand *)brand
//{
//    // 重置title
//    self.titleLabel.text = [NSString stringWithFormat:@" %@", brand.name];
//    self.detailLabel.hidden = YES;
//    NSURL *url = [NSURL URLWithString:brand.logo];
//    [self.imgView sd_setImageWithURL:url
//                    placeholderImage:[UIImage imageNamed:@"loding2"]];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.selected) {
        return;
    }
//    if (kSystemVersion>=6) {
        if (animated) {
            if (self.highlighted) {
                POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                scaleAnimation.duration = 0.1;
                scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
                [self.textLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            } else {
                POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
                scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
                scaleAnimation.springBounciness = 20.f;
                [self.contentView pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            }
        }
//    }
}


@end
