//
//  SignersCell.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SignersCell.h"
#import "SignUsers.h"
#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"

@implementation SignersCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    SignersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(SignUsers *)model
{
    _model= model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.head_img_url] placeholderImage:[UIImage imageNamed:@"img_renwu"]];
    self.nameL.text = model.nickname;
    self.timeL.text = [[DateOrTimeTool getDateStringBytimeStamp:model.create_time.floatValue] substringFromIndex:5];
    self.schoolL.text = model.name;
    
}
- (IBAction)acceptSomeOne:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(userSomeOne:)]) {
        [self.delegate userSomeOne:_model.user_id];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
