//
//  MerCntHeaderView.m
//  JianGuo
//
//  Created by apple on 16/3/18.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "MerCntHeaderView.h"
#import "UIImageView+WebCache.h"
#import "JGHTTPClient+Home.h"
#import "UIView+AlertView.h"

#define IconViewHeightWidth 60
#define LabelWith 50
#define BottomCountViewWidth (SCREEN_W-4)/3

@implementation MerCntHeaderView


+(instancetype)aMerchantHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MerCntHeaderView" owner:nil options:nil]lastObject];
}

-(void)layoutSubviews
{
    CGFloat height;
    if (SCREEN_W == 320) {
        height = 210*(SCREEN_W/375)+32;
    }else if (SCREEN_W == 375){
        height = 210*(SCREEN_W/375);
    }else if (SCREEN_W == 414){
        height = 210*(SCREEN_W/375)-20;
    }
    
    
    self.bgImageView.frame = CGRectMake(0, 0, SCREEN_W, height);
    
    self.merchentNameL.frame = CGRectMake(0, 30, SCREEN_W, 30);
    
    self.certifyLabel.layer.masksToBounds = YES;
    self.certifyLabel.layer.cornerRadius = 8;
    
    self.iconView.frame = CGRectMake(20, self.merchentNameL.bottom+20, IconViewHeightWidth, IconViewHeightWidth);
    self.certifyLabel.frame = CGRectMake(self.iconView.left+4, self.iconView.bottom-10, self.iconView.width-8, 15);
    self.commonLabel.frame = CGRectMake(self.iconView.right+10, self.iconView.top+10, 40, 20);
    self.starView.frame = CGRectMake(self.commonLabel.right, self.commonLabel.top, 80, 20);
    self.commonScoreL.frame = CGRectMake(self.starView.right, self.commonLabel.top, 30, 20);
    self.label1.frame = CGRectMake(self.iconView.right+10, self.commonLabel.bottom+10, LabelWith, 15);
    self.label2.frame = CGRectMake(self.label1.right+10, self.commonLabel.bottom+10, LabelWith, 15);
    self.label3.frame = CGRectMake(self.label2.right+10, self.commonLabel.bottom+10, LabelWith, 15);
    self.attentionBtn.frame = CGRectMake(SCREEN_W-80, self.commonLabel.bottom-20, 60, 20);
    self.jobCountView.frame = CGRectMake(0, self.iconView.bottom+20, BottomCountViewWidth, 50);
    self.peopleCountView.frame = CGRectMake(self.jobCountView.right+2, self.iconView.bottom+20, BottomCountViewWidth, 50);
    self.funsCountView.frame = CGRectMake(self.peopleCountView.right+2, self.iconView.bottom+20, BottomCountViewWidth, 50);
    
    self.merIntroduceView.frame = CGRectMake(0, self.bgImageView.bottom+3, SCREEN_W, 30);
    self.merContentView.frame = CGRectMake(0, self.merIntroduceView.bottom+3, SCREEN_W, 100);
    self.jobCountL.frame = CGRectMake(0, 2, BottomCountViewWidth, 20);
    self.jobCntNameL.frame = CGRectMake(0, 24, BottomCountViewWidth, 20);
    
    self.peopleCountL.frame = CGRectMake(0, 2, BottomCountViewWidth, 20);
    self.peopleCntNameL.frame = CGRectMake(0, 24, BottomCountViewWidth, 20);
    
    self.funsCountL.frame = CGRectMake(0, 2, BottomCountViewWidth, 20);
    self.funsNameL.frame = CGRectMake(0, 24, BottomCountViewWidth, 20);
    
    UIButton *jobCntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jobCntBtn.frame = self.jobCountView.bounds;
    [jobCntBtn setBackgroundImage:[UIImage imageNamed:@"img_xuanxiang"] forState:UIControlStateNormal];
    jobCntBtn.tag = 10000;
    [jobCntBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.jobCountView addSubview:jobCntBtn];
    
    UIButton *peoCntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    peoCntBtn.frame = self.peopleCountView.bounds;
    [peoCntBtn setBackgroundImage:[UIImage imageNamed:@"img_xuanxiang"] forState:UIControlStateNormal];
    peoCntBtn.tag = 10000;
    [peoCntBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.peopleCountView addSubview:peoCntBtn];
    
    UIButton *funsCntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    funsCntBtn.frame = self.funsCountView.bounds;
    [funsCntBtn setBackgroundImage:[UIImage imageNamed:@"img_xuanxiang"] forState:UIControlStateNormal];
    funsCntBtn.tag = 10000;
    [funsCntBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.funsCountView addSubview:funsCntBtn];
    
}

-(void)clickBtn:(UIButton *)btn
{
    
}

-(void)awakeFromNib
{
    
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 30;
    self.bounds = CGRectMake(0, 0, SCREEN_W, self.bgImageView.height+140);
    
}

-(void)setModel:(MerchantModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.name_image] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.merchentNameL.text = model.name;
    self.merchantcontentL.text = model.about;
    
    //计算简介label的大小
    CGRect rect = self.merchantcontentL.frame;
    CGSize size = [self.merchantcontentL.text boundingRectWithSize:CGSizeMake(SCREEN_W == 320?140:MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(14)} context:nil].size;
    rect.size.width = size.width;
    rect.origin.y += 10;
    rect.origin.x += 10;
    rect.size.height = size.height;
    self.merchantcontentL.frame = rect;
    
    if(model.is_follow.intValue == 1){
        [self.attentionBtn setImage:[UIImage imageNamed:@"icon_star"] forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [self.attentionBtn setImage:[UIImage imageNamed:@"icon_star2"] forState:UIControlStateNormal];
        [self.attentionBtn setTitle:@"未关注" forState:UIControlStateNormal];
    }
    
    [self.starView setScore:5];
    self.commonScoreL.text = model.score;
    self.jobCountL.text = model.job_count;
    self.peopleCountL.text = model.user_count;
    self.funsCountL.text = model.fans_count;
    NSArray *array = [model.label componentsSeparatedByString:@";"];
    self.label1.text = [array firstObject];
    if (array.count>2) {
        self.label2.text = [array objectAtIndex:1];
        self.label3.text = [array objectAtIndex:2];
    }
    
    
    
}
- (IBAction)followMerchant:(UIButton *)sender {
    
    if (self.model.is_follow.intValue ==1) {
        return;
    }else{
        [JGHTTPClient attentionMercntOrColloectionParjobByJobid:@"0" merchantId:self.model.id loginId:USER.login_id Success:^(id responseObject) {
            
            if ([responseObject[@"code"] intValue] == 200) {
                
                [self.attentionBtn setImage:[UIImage imageNamed:@"icon_star"] forState:UIControlStateNormal];
                [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [self showAlertViewWithText:@"关注成功" duration:1];
            }
            
        } failure:^(NSError *error) {
            [self showAlertViewWithText:NETERROETEXT duration:1];
        }];
    }
}

@end
