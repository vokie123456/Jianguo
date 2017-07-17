//
//  FunsCell.m
//  JianGuo
//
//  Created by apple on 17/6/26.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "FunsCell.h"
#import "FunsModel.h"

#import "LoginNew2ViewController.h"
#import "JGHTTPClient+Demand.h"

#import "UIImageView+WebCache.h"

@implementation FunsCell

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.followB.hidden = YES;
}

- (void)awakeFromNib {
    
    self.iconView.layer.cornerRadius = self.iconView.width/2;
    
}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    FunsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[NSBundle mainBundle ]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

-(void)setModel:(FunsModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.userHeadImage] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameL.text = model.userName.length?model.userName:@"未填写";
    self.schoolL.text = model.userSchoolName.length?model.userSchoolName:@"未填写";
    self.genderView.image = [UIImage imageNamed:model.sex.integerValue==2?@"boy":@"girlsex"];
    
    if (model.isFollow.integerValue == 1) {//已关注
        
        self.followB.hidden = YES;
        
    }else{
        
        self.followB.hidden = NO;
        
    }
    if (USER.login_id.integerValue == model.userId.integerValue) {
        
        self.followB.hidden = YES;
    }
    
}


- (IBAction)follow:(id)sender {
    
//    if ([self.delegate respondsToSelector:@selector(followSomeOne:)]) {
//        [self.delegate followSomeOne:_model.userId];
//    }
    
    if (USER.tel.length!=11) {
        
        LoginNew2ViewController *loginVC= [[LoginNew2ViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        
        return;
    }

    //1==关注 , 0==取消
    [JGHTTPClient followUserWithUserId:_model.userId status:@"1" Success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showAlertViewWithText:@"关注成功" duration:1];
            [sender setHidden:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)chat:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chatSomeOne:)]) {
        [self.delegate chatSomeOne:_model.userId];
    }
}

@end
