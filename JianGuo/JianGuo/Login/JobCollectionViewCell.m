//
//  JobCollectionViewCell.m
//  JianGuo
//
//  Created by apple on 16/7/7.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "JobCollectionViewCell.h"
#import "PartTypeModel.h"
@implementation JobCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(PartTypeModel *)model
{
    _model = model;
    if (model.is_type) {
        self.contentL.backgroundColor = BLUECOLOR;
        self.contentL.textColor = WHITECOLOR;
    }else{
        self.contentL.backgroundColor = WHITECOLOR;
        self.contentL.textColor = [UIColor darkGrayColor];
    }
    self.contentL.text = model.name;



}

@end
