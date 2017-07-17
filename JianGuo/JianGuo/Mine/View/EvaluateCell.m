//
//  EvaluateCell.m
//  JianGuo
//
//  Created by apple on 17/6/21.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "EvaluateCell.h"

#import "UIImageView+WebCache.h"
#import "UIColor+Hex.h"

#import "EvaluateModel.h"
#import "DemandTypeModel.h"

@implementation EvaluateCell
{
    NSMutableArray *colorArr;
    NSMutableArray *titleArr;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(EvaluateModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImgUrl]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.commentTypeL.text = model.type.integerValue == 1?@"来自接单者的评价":@"来自发布者的评价";
    self.nameL.text = model.nickName?model.nickName:@"未填写";
    self.schoolL.text = model.school?model.school:@"未填写";
    self.commentContentL.text = model.comment;
    self.demandTitleL.text = model.d_title;
    self.demandDesL.text = model.d_describe;
    self.demandTypeL.backgroundColor = colorArr[model.d_type.integerValue-1];
    self.demandTypeL.text = titleArr[model.d_type.integerValue-1];
}

- (void)awakeFromNib {
    // Initialization code
    NSArray *array = @[@"#feb369",@"#70a9fc",@"#8e96e9",@"#c9a269",@"#fa7070",@"#71c268"];
    colorArr = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *color = [UIColor colorWithHexString:obj];
        [colorArr addObject:color];
    }];
    
//    NSArray *demandTypeArr= JGKeyedUnarchiver(JGDemandTypeArr);
    titleArr = @[@"学习交流",@"跑腿代劳",@"技能服务",@"娱乐生活",@"情感地带",@"易货求购"].mutableCopy;
//    for (DemandTypeModel *model in demandTypeArr) {
//        if (model.type_id.integerValue == 0) {
//            continue;
//        }
//        [titleArr addObject:model.type_name];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
