//
//  DemandListCell.m
//  JianGuo
//
//  Created by apple on 17/1/6.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "DemandListCell.h"
#import <UIImageView+WebCache.h>
#import "DemandModel.h"
#import "DateOrTimeTool.h"
#import "CommentModel.h"
#import "CommentUser.h"
#import "TTTAttributedLabel.h"
#import "JGHTTPClient+Demand.h"
#import "QLAlertView.h"

@interface DemandListCell()<UITextFieldDelegate,TTTAttributedLabelDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *genderView;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *commentCountL;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountL;
@property (weak, nonatomic) IBOutlet UIImageView *selfIconView;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *firstCommentL;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *secondCommentL;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *thirdCommentL;


@end
@implementation DemandListCell

-(void)prepareForReuse
{
    [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
}

-(void)setModel:(DemandModel *)model
{
    _model = model;
    if (model.like_status.integerValue == 1) {
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"xin"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.head_img_url] placeholderImage:[UIImage imageNamed:@"wechat"]];
    self.nameL.text = model.anonymous.integerValue==1?@"匿名":model.nickname;
    self.genderView.image = [UIImage imageNamed:model.sex.integerValue==2?@"man":@"girl"];
    self.titleL.text = model.title;
    self.moneyL.text = [NSString stringWithFormat:@"%@元",model.money];
    self.timeL.text = [DateOrTimeTool getDateStringBytimeStamp:model.create_time.floatValue];
    self.commentCountL.text = [NSString stringWithFormat:@"%@",model.comment_count];
    self.praiseCountL.text = model.like_count;
    self.firstCommentL.text = self.secondCommentL.text = self.thirdCommentL.text = nil;
    if (model.commentEntitys.count == 1){
        
        CommentModel *commentModel1 = model.commentEntitys.firstObject;

        [self getStrToLabel:self.firstCommentL WithCommentModel:commentModel1];
        
    }else if (model.commentEntitys.count==2){
        
        CommentModel *commentModel1 = model.commentEntitys.firstObject;
        [self getStrToLabel:self.firstCommentL WithCommentModel:commentModel1];
        
        CommentModel *commentModel2 = model.commentEntitys.lastObject;
        [self getStrToLabel:self.secondCommentL WithCommentModel:commentModel2];
    
    }else if (model.commentEntitys.count==3){
        
        CommentModel *commentModel1 = model.commentEntitys.firstObject;
        [self getStrToLabel:self.firstCommentL WithCommentModel:commentModel1];
        
        CommentModel *commentModel2 =  [model.commentEntitys objectAtIndex:1];
        [self getStrToLabel:self.secondCommentL WithCommentModel:commentModel2];
        
        CommentModel *commentModel3 = model.commentEntitys.lastObject;
        [self getStrToLabel:self.thirdCommentL WithCommentModel:commentModel3];
        
    }
    
}


-(void)getStrToLabel:(TTTAttributedLabel *)label WithCommentModel:(CommentModel *)model
{
    
    CommentModel *commentModel1 = model;
    
    CommentUser *commentUser1 = commentModel1.users.firstObject;
    
    BOOL bo1 = commentModel1.user_id.integerValue==commentUser1.userId.integerValue;
    BOOL bo2 = commentModel1.users.count==2;
    
    if (bo2) {
        NSString *str;
        CommentUser *commentUser2 = commentModel1.users.lastObject;
        if (bo1) {
            if (_model.b_user_id.integerValue == commentUser2.userId.integerValue) {
                str = [NSString stringWithFormat:@"%@ :",commentUser1.nickName];
            }else
            str = [NSString stringWithFormat:@"%@ 回复 %@ :",commentUser1.nickName,commentUser2.nickName];
        }else{
            if (_model.b_user_id.integerValue == commentUser1.userId.integerValue) {
                str = [NSString stringWithFormat:@"%@ :",commentUser2.nickName];
            }else
            str = [NSString stringWithFormat:@"%@ 回复 %@ :",commentUser2.nickName,commentUser1.nickName];
        }
        NSString *attStr = [str stringByAppendingString:commentModel1.content];
        
        [label setText:attStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            //        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, mutableAttributedString.length)];//这个设置方式不起作用
            
            [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
            
            return mutableAttributedString;
        }];
        UIFont *boldSystemFont = [UIFont systemFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        //添加点击事件
        label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        
        label.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:GreenColor};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
        CFRelease(font);

        
        NSRange range1 = [attStr rangeOfString:commentUser1.nickName];
        NSRange range2 = [attStr rangeOfString:commentUser2.nickName];
        NSURL *url1 = [NSURL URLWithString:commentUser1.userId];
        NSURL *url2 = [NSURL URLWithString:commentUser2.userId];
        [label addLinkToURL:url1 withRange:range1];
        [label addLinkToURL:url2 withRange:range2];
        
    }else{
        NSString *attStr = [NSString stringWithFormat:@"%@ : %@",commentUser1.nickName,commentModel1.content];
        
        [label setText:attStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            //        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, mutableAttributedString.length)];//这个设置方式不起作用
            
            [mutableAttributedString addAttributes:@{(id)kCTForegroundColorAttributeName:LIGHTGRAYTEXT} range:NSMakeRange(0, mutableAttributedString.length) ];//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
            
            return mutableAttributedString;
        }];
        UIFont *boldSystemFont = [UIFont systemFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        //添加点击事件
        label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        
        label.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:GreenColor};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
        CFRelease(font);
        
        
        NSRange range1 = [attStr rangeOfString:commentUser1.nickName];

        NSURL *url1 = [NSURL URLWithString:commentUser1.userId];

        [label addLinkToURL:url1 withRange:range1];

    }
}

- (void)awakeFromNib {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.commentTF.leftViewMode = UITextFieldViewModeAlways;
    self.commentTF.leftView = leftView;
    self.commentTF.layer.cornerRadius = 5;
    self.commentTF.delegate = self;

    self.iconView.layer.cornerRadius = self.iconView.width/2;
    self.iconView.layer.masksToBounds = YES;
    self.selfIconView.layer.cornerRadius = self.selfIconView.width/2;
    self.selfIconView.layer.masksToBounds = YES;
    self.firstCommentL.delegate = self;
    self.secondCommentL.delegate = self;
    self.thirdCommentL.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon)];
    [self.iconView addGestureRecognizer:tap];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    CGRect frame = {CGPointZero,CGSizeMake(40, 40)};
    likeBtn.frame = frame;
    [likeBtn addTarget:self action:@selector(likeTheDemand:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.center = CGPointMake(self.praiseBtn.width/2, self.praiseBtn.height/2);
    [self.praiseBtn addSubview:likeBtn];
    self.bigBtn=likeBtn;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentTF addSubview:editBtn];
    self.editBtn = editBtn;
    
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.commentTF.mas_leading);
        make.trailing.equalTo(self.commentTF.mas_trailing);
        make.top.equalTo(self.commentTF.mas_top);
        make.bottom.equalTo(self.commentTF.mas_bottom);
    }];
}

//点赞
-(void)likeTheDemand:(UIButton *)btn
{
    NSString *status = _model.like_status.integerValue==1?@"0":@"1";
    
    btn.userInteractionEnabled = NO;
    [JGHTTPClient praiseForDemandWithDemandId:_model.id likeStatus:status Success:^(id responseObject) {
        btn.userInteractionEnabled = YES;
        if ([responseObject[@"code"]integerValue] == 200) {
            _model.like_status = status;
            [self.praiseBtn setBackgroundImage:[UIImage imageNamed:status.integerValue==1?@"xin":@"heart"] forState:UIControlStateNormal];
            
        }
        
    } failure:^(NSError *error) {
        btn.userInteractionEnabled = YES;
        [QLAlertView showAlertTittle:nil message:NETERROETEXT];
    }];
    
}

-(void)clickIcon//点击头像
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}


-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *userId = [NSString stringWithFormat:@"%@",url];
    JGLog(@"%@",userId);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;

    CGPoint point = [touch locationInView:touch.view];
    CGPoint point1 = [touch.view convertPoint:point toView:self.bigBtn];//获取点击点在按钮上的坐标
    CGRect rect = self.bigBtn.bounds;
    
    if (CGRectContainsPoint(rect, point1)) {//这个方法也可以,但是rect必须是self.bigBtn的bounds,不能是它的frame<下边的方法 pointInside: withEvent: 就是这个道理> 因为bounds才是自己的坐标体系,frame是在父控件的坐标体系
        
        [self likeTheDemand:self.bigBtn];
    }else{
        [super touchesBegan:touches withEvent:event];
    }
    
//    if ([self.bigBtn pointInside:point1 withEvent:nil]) {//这个判断方法好使(判断点是不是在调用者<self.bigBtn>范围内)
//        [self likeTheDemand:self.bigBtn];
//    }else{
//        [super touchesBegan:touches withEvent:event];
//    }
}
- (IBAction)edit:(UITextField *)sender {

    if (self.sendCellIndex) {
        self.sendCellIndex(sender);
    }

    [self.commentTF becomeFirstResponder];
    
}


@end
