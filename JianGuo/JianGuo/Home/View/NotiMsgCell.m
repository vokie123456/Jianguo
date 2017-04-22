//
//  NotiMsgCell.m
//  JianGuo
//
//  Created by apple on 16/5/30.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NotiMsgCell.h"
#import "DateOrTimeTool.h"

@implementation NotiMsgCell

- (void)awakeFromNib {
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NotiNewsModel *)model
{
    _model = model;
    self.titleL.text = model.title.length?model.title:@"推送消息";
    self.timeL.text = [DateOrTimeTool getDateStringBytimeStamp:model.time.floatValue];
    self.contentL.text = model.content ;
//    if (model.type.intValue == 0) {//报名
//        self.remarkL.text = @"请到\"我的\"-->\"兼职管理\"查看信息!";
//    }else if(model.type.intValue == 1){//钱包
//        self.remarkL.text = @"消息详情请到\"我的\"-->\"我的钱包\"查看信息!";
//    }else if (model.type.intValue == 2){//实名
//        self.remarkL.text = @"消息详情请到\"我的\"-->\"实名认证\"查看信息!";
//    }
    self.remarkL.text = @"点击查看详情";
}



@end
