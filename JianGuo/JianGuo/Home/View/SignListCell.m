//
//  SignListCell.m
//  JianGuo
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "SignListCell.h"
#import "UIButton+Background.h"
#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"
#import "NameIdManger.h"
@interface SignListCell()
{
    __weak IBOutlet NSLayoutConstraint *rightToright;
    int status;
}
@property (weak, nonatomic) IBOutlet UIImageView *typeView;

@end
@implementation SignListCell

-(void)prepareForReuse
{
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    self.stateRightView.hidden = YES;
    rightToright.constant = 20;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(JianzhiModel *)model
{
    _model = model;
    if (model.max.intValue==1) {
        self.typeView.hidden = NO;
    }
    status = model.status.intValue;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.job_image] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.tittleL.text = model.job_name;
    NSTimeInterval timeStart = model.start_date.longLongValue;
    NSRange range = NSMakeRange(5, 5);
    NSString *startDateStr = [[DateOrTimeTool getDateStringBytimeStamp:timeStart] substringWithRange:range];
    
    NSTimeInterval timeEnd = model.end_date.longLongValue;
    NSString *endDateStr = [[DateOrTimeTool getDateStringBytimeStamp:timeEnd] substringWithRange:range];
    self.workDateL.text = [[startDateStr stringByAppendingString:@" 至 "] stringByAppendingString:endDateStr];
    
    if (model.term.intValue == 5||model.term.intValue == 6) {
        self.moneyL.text = [NameIdManger getTermNameById:model.term];
    }else{
        self.moneyL.text = [model.money stringByAppendingString:[NameIdManger getTermNameById:model.term]];
    }
    
    if (status<=1) {//已报名,未录取
        [self updateConstraint];
        [self.leftBtn setEnableGrayAndWhite:@"取消报名"];
        self.stateImgView.image = [UIImage imageNamed:@"icon_dailuqu"];
        self.rightBtn.hidden = YES;
    }else if (status == 2){//被拒绝
        [self updateConstraint];
        //            [self.leftBtn setGrayBGAndWhiteTittle:@"未被录取"];
        self.leftBtn.hidden = YES;
        self.stateRightView.hidden = NO;
        self.stateRightView.image = [UIImage imageNamed:@"icon_weiluqu"];
        self.stateImgView.image = [UIImage imageNamed:@"icon_dailuqu"];
    }else if (status == 3){//已录用
        self.leftBtn.hidden = YES;
        //            [self.rightBtn setGrayBGAndWhiteTittle:@"已完成"];
        
        self.rightBtn.hidden = YES;
        self.stateRightView.hidden = YES;
//        self.stateRightView.image = [UIImage imageNamed:@"icon_yiluqu"];
        self.stateImgView.image = [UIImage imageNamed:@"icon_yiluqu"];
    }else if (status == 4){//已取消
        self.rightBtn.hidden = YES;
        self.stateRightView.hidden = NO;
        self.stateRightView.image = [UIImage imageNamed:@"icon_woyiquxiao"];
        self.stateImgView.image = [UIImage imageNamed:@"icon_yiluqu"];
        self.leftBtn.hidden = YES;
    }else{//已结算
        self.leftBtn.hidden = YES;
        //            [self.rightBtn setGrayBGAndWhiteTittle:@"已完成"];
        
        self.rightBtn.hidden = YES;
        self.stateRightView.hidden = NO;
        self.stateRightView.image = [UIImage imageNamed:@"icon_yiwancheng-1"];
        self.stateImgView.image = [UIImage imageNamed:@"icon_yiwancheng"];
    }
/*
    switch (status) {
        case 0:{
            
            [self updateConstraint];
            [self.leftBtn setEnableGrayAndWhite:@"取消报名"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_dailuqu"];
            self.rightBtn.hidden = YES;
            
            break;
        } case 1:{
            
            [self updateConstraint];
//            [self.leftBtn setGrayBGAndWhiteTittle:@"已取消报名"];
            self.leftBtn.hidden = YES;
            self.stateRightView.hidden = NO;
            self.stateRightView.image = [UIImage imageNamed:@"icon_woyiquxiao"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_dailuqu"];
            self.leftBtn.userInteractionEnabled = NO;
            
            break;
        } case 2:{
            
            [self updateConstraint];
//            [self.leftBtn setGrayBGAndWhiteTittle:@"未被录取"];
            self.leftBtn.hidden = YES;
            self.stateRightView.hidden = NO;
            self.stateRightView.image = [UIImage imageNamed:@"icon_weiluqu"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_dailuqu"];
            
            break;
        } case 3:{
            
            [self.leftBtn setEnableGrayAndWhite:@"取消参加"];
            [self.rightBtn setRedBGAndWhiteTittle:@"确认参加"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiluqu"];
            break;
        } case 4:{
            
//            [self.rightBtn setGrayBGAndWhiteTittle:@"我已取消"];
            
            self.rightBtn.hidden = YES;
            self.stateRightView.hidden = NO;
            self.stateRightView.image = [UIImage imageNamed:@"icon_woyiquxiao"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiluqu"];
            self.leftBtn.hidden = YES;
            
            break;
        } case 5:{
            //做一个时间的判断,如果进入8小时以内,则变为准备出发状态且不能点击
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            if (now+3600*8>model.begin_time.intValue){
//                [self.rightBtn setGrayBGAndWhiteTittle:@"准备出发"];
                self.rightBtn.hidden = YES;
                self.stateRightView.hidden = NO;
                self.stateRightView.image = [UIImage imageNamed:@"icon_zhunbei"];
            }else{
                [self.rightBtn setEnableGrayAndWhite:@"取消参加"];
            }
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiluqu"];
            self.leftBtn.hidden = YES;
            
            break;
        } case 6:{
            
//            [self.rightBtn setGrayBGAndWhiteTittle:@"我已取消"];
            
            self.rightBtn.hidden = YES;
            self.stateRightView.hidden = NO;
            self.stateRightView.image = [UIImage imageNamed:@"icon_woyiquxiao"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiluqu"];
            self.leftBtn.hidden = YES;
            
            break;
        } case 7:{
//            [self.rightBtn setGrayBGAndWhiteTittle:@"未被录取"];
            
            self.rightBtn.hidden = YES;
            self.stateRightView.hidden = NO;
            self.stateRightView.image = [UIImage imageNamed:@"icon_shangjiaquxiao"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiluqu"];
            self.leftBtn.hidden = YES;
            
            break;
        } case 8:{
            
            self.leftBtn.hidden = YES;
//            [self.rightBtn setGrayBGAndWhiteTittle:@"工作中"];
            
            self.rightBtn.hidden = YES;
            self.stateRightView.hidden = NO;
            self.stateRightView.image = [UIImage imageNamed:@"icon_gongzuozhong"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiluqu"];
            
            break;
        } case 9:{
            
            self.leftBtn.hidden = YES;
            [self.rightBtn setYellowBGAndWhiteTittle:@"催工资"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiwancheng"];
            
            break;
        } case 10:{
            
            self.leftBtn.hidden = YES;
//            [self.rightBtn setGrayBGAndWhiteTittle:@"已催"];
            
            self.rightBtn.hidden = YES;
            self.stateRightView.hidden = NO;
            self.stateRightView.image = [UIImage imageNamed:@"icon_yicuigongzi"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiwancheng"];
            
            break;
        } case 11:{
            
            self.leftBtn.hidden = YES;
            [self.rightBtn setYellowBGAndWhiteTittle:@"待评价"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiwancheng"];
            
            break;
        } case 12:{
            
            self.leftBtn.hidden = YES;
//            [self.rightBtn setGrayBGAndWhiteTittle:@"已完成"];
            
            self.rightBtn.hidden = YES;
            self.stateRightView.hidden = NO;
            self.stateRightView.image = [UIImage imageNamed:@"icon_yiwancheng-1"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiwancheng"];
            
            break;
        } case 13:{
            
            self.leftBtn.hidden = YES;
            [self.rightBtn setGrayBGAndWhiteTittle:@"已下架"];
            self.stateImgView.image = [UIImage imageNamed:@"icon_yiwancheng"];
            
            break;
        }
        default:
            break;
    }

*/
    
}
-(void)updateConstraint
{
    self.rightBtn.hidden = YES;
    rightToright.constant= -50;
}
- (IBAction)clickLeftBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickLeftBtn:)]) {
        [self.delegate clickLeftBtn:sender];
    }
}
- (IBAction)clickRightBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickRightBtn:)]) {
        [self.delegate clickRightBtn:sender];
    }
}



@end
