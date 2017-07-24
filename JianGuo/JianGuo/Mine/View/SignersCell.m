//
//  SignersCell.m
//  JianGuo
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "SignersCell.h"
#import "SignUsers.h"
#import "UIButton+AFNetworking.h"
#import "DateOrTimeTool.h"
#import "QLAlertView.h"
#import "XLPhotoBrowser.h"


#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "TextReasonViewController.h"
@interface SignersCell()<UIViewControllerTransitioningDelegate>

@end
@implementation SignersCell

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.acceptBtn setTitle:@"录用TA" forState:UIControlStateNormal];
    [self.acceptBtn setBackgroundColor:GreenColor];
    self.acceptBtn.userInteractionEnabled = YES;
}

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
    JGLog(@"%@––––>%@",model.head_img_url,model.tel);

    [self.iconView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100x100",model.headImg]] placeholderImage:[UIImage imageNamed:@"myicon"]];
    self.nameL.text = model.nickname.length?model.nickname:@"未填写";
    
    self.schoolL.text = model.schoolName;
    
    if (model.sex.integerValue == 2) {
        self.genderView.image = [UIImage imageNamed:@"boy"];
    }else{
        self.genderView.image = [UIImage imageNamed:@"girlsex"];
    }
    
    if (model.enrollStatus.integerValue == 2) {//已录用
        
        [self.acceptBtn setTitle:@"已录用" forState:UIControlStateNormal];
        [self.acceptBtn setBackgroundColor:LIGHTGRAY1];
        self.acceptBtn.userInteractionEnabled = NO;
    }else if (model.enrollStatus.integerValue == 3){//拒绝,未录用状态
        [self.acceptBtn setTitle:@"未录用" forState:UIControlStateNormal];
        [self.acceptBtn setBackgroundColor:LIGHTGRAY1];
        self.acceptBtn.userInteractionEnabled = NO;
    }else if (model.enrollStatus.integerValue == 4){//用户取消报名
        [self.acceptBtn setTitle:@"已取消" forState:UIControlStateNormal];
        [self.acceptBtn setBackgroundColor:LIGHTGRAY1];
        self.acceptBtn.userInteractionEnabled = NO;
    }else if (model.enrollStatus.integerValue==1){
        
        if (model.demandStatus.integerValue==7) {
            
            [self.acceptBtn setTitle:@"录用TA" forState:UIControlStateNormal];
            [self.acceptBtn setBackgroundColor:LIGHTGRAY1];
            self.acceptBtn.userInteractionEnabled = NO;
            
        }else if (model.demandStatus.integerValue != 1){
            [self.acceptBtn setTitle:@"未录用" forState:UIControlStateNormal];
            [self.acceptBtn setBackgroundColor:LIGHTGRAY1];
            self.acceptBtn.userInteractionEnabled = NO;
        }
        
    }
    
//    NSArray *array = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
//    self.starL.text = [DateOrTimeTool getConstellation:model.birth_date]?[DateOrTimeTool getConstellation:model.birth_date]:@"未填写";
//    
//    if (model.enroll_status.integerValue == 1) {
//        self.stateL.text = @"待录用";
//    }else if (model.enroll_status.integerValue == 2){
//        self.stateL.text = @"已录用";
//    }else if (model.enroll_status.integerValue == 3){
//        self.stateL.text = @"已拒绝";
//    }
    
//    if (model.enroll_status.integerValue != 1) {
//        self.rightCons.constant = 15;
//        self.acceptBtn.hidden = YES;
//        self.refuseBtn.hidden = YES;
//    }
    
}
- (IBAction)acceptSomeOne:(id)sender {//录用
    
    if ([self.delegate respondsToSelector:@selector(userSomeOne: status: cell:)]) {
        [self.delegate userSomeOne:_model.user_id status:@"2" cell:self];
    }
    
}
- (IBAction)refuse:(id)sender {//拒绝
    
    TextReasonViewController *reasonVC = [[TextReasonViewController alloc] init];
    reasonVC.transitioningDelegate = self;
    reasonVC.modalPresentationStyle = UIModalPresentationCustom;
    reasonVC.userId = _model.user_id;
    reasonVC.demandId = self.demandId;
    reasonVC.callBackBlock = ^(){
        if ([self.delegate respondsToSelector:@selector(refreshData)]) {
            [self.delegate refreshData];
        }
    };
    [self.window.rootViewController presentViewController:reasonVC
                                                 animated:YES
                                               completion:NULL];
    
}
- (IBAction)call:(id)sender {
    
    [QLAlertView showAlertTittle:@"确定呼叫用户吗?" message:nil isOnlySureBtn:NO compeletBlock:^{
        [APPLICATION openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.tel]]];
    }];
    
}

- (void)showIcon:(UITapGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(clickIcon:)]) {
        [self.delegate clickIcon:_model.enrollUid];
    }
    
}

- (IBAction)chat:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chatUser:)]) {
        [self.delegate chatUser:_model.user_id];
    }
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

- (void)awakeFromNib {
    
    if (SCREEN_W!=320) {
        self.buttonWidthCons.constant = 60;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showIcon:)];
    [self.iconView addGestureRecognizer:tap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
