//
//  FunsCell.h
//  JianGuo
//
//  Created by apple on 17/6/26.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FunsModel;
@protocol FunsCellDelegate <NSObject>

-(void)chatSomeOne:(NSString *)userId;
-(void)followSomeOne:(NSString *)userId;

@end

@interface FunsCell : UITableViewCell

/** Model */
@property (nonatomic,strong) FunsModel *model;


@property (nonatomic,strong) id <FunsCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *schoolL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *genderView;
@property (weak, nonatomic) IBOutlet UIButton *followB;
@property (weak, nonatomic) IBOutlet UIButton *chatB;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
