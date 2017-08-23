//
//  DDUserInfoCell.m
//  JianGuo
//
//  Created by apple on 17/6/13.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DDUserInfoCell.h"

#import "LoginNew2ViewController.h"
#import "JGHTTPClient+Demand.h"
#import "JGHTTPClient+Skill.h"

#import "DemandDetailModel.h"
#import "SkillDetailModel.h"

#import "UIImageView+WebCache.h"
#import "DateOrTimeTool.h"

@implementation DDUserInfoCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setSkillDetailM:(SkillDetailModel *)skillDetailM
{
    _skillDetailM = skillDetailM;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:skillDetailM.headImg] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.schoolL.text = skillDetailM.userSchoolName;
    self.contentL.text = [self getSkillPersonInfoStr];
    self.nameL.text = skillDetailM.nickname.length?skillDetailM.nickname:@"未填写";
    self.statusView.image = [UIImage imageNamed:(skillDetailM.authStatus?@"adopt":@"authentication1")];
    self.statusL.text = skillDetailM.authStatus?@"已经通过实名认证!":@"暂未通过实名认证!";
}

-(void)setDetailModel:(DemandDetailModel *)detailModel
{
    _detailModel = detailModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:detailModel.headImg] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.schoolL.text = detailModel.schoolName;
    self.contentL.text = [self getPersonInfoStr];
    self.nameL.text = detailModel.nickname.length?detailModel.nickname:@"未填写";
    self.statusView.image = [UIImage imageNamed:(detailModel.authStatus.integerValue?@"adopt":@"authentication1")];
    self.statusL.text = detailModel.authStatus.integerValue?@"已经通过实名认证!":@"暂未通过实名认证!";
}

//获取个人信息字符串
-(NSString *)getPersonInfoStr
{
    NSString *string;
    if (_detailModel.birthDate.length>=10) {
        
        string = [NSString stringWithFormat:@"%@年%@%@孩,在兼果校园发布过%@条任务,完成过%@条任务.",[_detailModel.birthDate substringWithRange:NSMakeRange(2, 2)],[DateOrTimeTool getConstellation:_detailModel.birthDate],_detailModel.sex.integerValue==2?@"男":@"女",_detailModel.publishDemandCount,_detailModel.completedDemandCount];
    }else{
        string = [NSString stringWithFormat:@"该%@孩,在兼果发布过%@条任务,完成过%@条任务.",_detailModel.sex.integerValue==2?@"男":@"女",_detailModel.publishDemandCount,_detailModel.completedDemandCount];
    }
    return string;
}

//获取个人信息字符串
-(NSString *)getSkillPersonInfoStr
{
    NSString *string;
    if (_skillDetailM.birthDate.length>=10) {
        
        string = [NSString stringWithFormat:@"%@年%@%@孩,兼果校园技能达人,在兼果校园发布过%@条任务,完成过%@条任务.",[_skillDetailM.birthDate substringWithRange:NSMakeRange(2, 2)],[DateOrTimeTool getConstellation:_skillDetailM.birthDate],_skillDetailM.sex==2?@"男":@"女",[NSString stringWithFormat:@"%ld",_skillDetailM.publishDemandCount],[NSString stringWithFormat:@"%ld",_skillDetailM.completedDemandCount]];
    }else{
        string = [NSString stringWithFormat:@"该%@孩,兼果校园技能达人,在兼果发布过%@条任务,完成过%@条任务.",_skillDetailM.sex==2?@"男":@"女",[NSString stringWithFormat:@"%ld",_skillDetailM.publishDemandCount],[NSString stringWithFormat:@"%ld",_skillDetailM.completedDemandCount]];
    }
    
    return string;
}

- (IBAction)follow:(id)sender {
    

    if (USER.tel.length!=11) {
        
        LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        
        return;
    }

    //1==关注 , 0==取消
    [JGHTTPClient followUserWithUserId:_detailModel.userId status:@"1" Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showAlertViewWithText:@"关注成功" duration:1];
            [sender setHidden:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
