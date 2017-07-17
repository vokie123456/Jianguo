//
//  JianliCell.m
//  JianGuo
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JianliCell.h"

@implementation JianliCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
//    JianliCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
        JianliCell *cell = [[JianliCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubViews];
    }
    return self;
}

-(void)setSubViews
{
    UILabel *labelL = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 100, 20)];
    labelL.center = CGPointMake(labelL.center.x, self.contentView.center.y);
    labelL.font = FONT(16);
    labelL.text = @"姓名";
    labelL.textColor = LIGHTGRAYTEXT;
    [self.contentView addSubview:labelL];
    self.labelLeft = labelL;
    
    UITextField *rightTf = [[UITextField alloc] initWithFrame:CGRectMake(labelL.right, 11, SCREEN_W-labelL.right-10, self.contentView.height-20)];
    rightTf.center = CGPointMake(rightTf.center.x, self.contentView.center.y);
    rightTf.placeholder = @"请填写您的真实姓名";
    rightTf.textAlignment = NSTextAlignmentLeft;
    rightTf.borderStyle = UITextBorderStyleNone;
    [rightTf addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:rightTf];
    rightTf.font = FONT(15);
    rightTf.textColor = LIGHTGRAYTEXT;
    rightTf.userInteractionEnabled = NO;
    self.rightTf = rightTf;
    
    UIImageView *jiantouView = [[UIImageView alloc] initWithFrame:CGRectMake(rightTf.right+10, 11, 11, 19)];
    jiantouView.image = [UIImage imageNamed:@"icon_back"];
    [self.contentView addSubview:jiantouView];
    self.jiantouView = jiantouView;
    
//    CheckBox *boxYes = [CheckBox aCheckBox];
//    boxYes.frame = CGRectMake(labelL.right, 0, 100, 44);
//    boxYes.hidden = YES;
//    boxYes.labeYysOrNo.text = @"是";
//    boxYes.Btn.tag = 1000;
//    [boxYes.Btn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:boxYes];
//    self.selectYes = boxYes;
//    
//    CheckBox *boxNo = [CheckBox aCheckBox];
//    boxNo.frame = CGRectMake(boxYes.right, 0, 100, 44);
//    boxNo.hidden = YES;
//    boxNo.labeYysOrNo.text = @"否";
//    boxNo.Btn.tag = 1001;
//    [boxNo.Btn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:boxNo];
//    self.selectNo = boxNo;
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.contentView.frame.size.height-1, SCREEN_W-20, 1)];
    self.lineView.backgroundColor = BACKCOLORGRAY;
    [self.contentView addSubview:self.lineView];
    
    self.lineViewTop = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_W-20, 1)];
    self.lineViewTop.backgroundColor = BACKCOLORGRAY;
    self.lineViewTop.hidden = YES;
    [self.contentView addSubview:self.lineViewTop];
}

//- (void)select:(UIButton *)sender {
//    
//    if (sender.tag == 1000) {
//        self.selectYes.selectImg.image = [UIImage imageNamed:@"buttonn"];
//        self.selectNo.selectImg.image = [UIImage imageNamed:@"button"];
//        if(self.seletIsStudentBlock){
//            self.seletIsStudentBlock(@"1");//是
//        }
//    }else if (sender.tag == 1001){
//        self.selectYes.selectImg.image = [UIImage imageNamed:@"button"];
//        self.selectNo.selectImg.image = [UIImage imageNamed:@"buttonn"];
//        if (self.seletIsStudentBlock) {
//            self.seletIsStudentBlock(@"2");//否
//        }
//    }
//    
//}

-(void)textChanged:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textChanged:)]) {
        [self.delegate textChanged:textField];
    }
}

@end
