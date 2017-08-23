//
//  ShareView.h
//  JianGuo
//
//  Created by apple on 16/3/19.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailModel,JianzhiModel,DemandDetailModel,DiscoveryModel,SkillDetailModel;
@interface ShareView : UIView

+(instancetype)aShareView;
-(void)show;

@property (nonatomic,assign) BOOL isDiscvoeryVC;

@property (nonatomic,strong) DiscoveryModel *discoverModel;
@property (nonatomic,strong) DetailModel *model;
@property (nonatomic,strong) JianzhiModel *jzModel;
@property (nonatomic,strong) DemandDetailModel *demandModel;
@property (nonatomic,strong) SkillDetailModel *skillModel;

@property (nonatomic,copy) NSString *money;

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *address;

@property (weak, nonatomic) IBOutlet UILabel *shareToL;
@property (weak, nonatomic) IBOutlet UIButton *labelBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *QQView;
@property (weak, nonatomic) IBOutlet UIImageView *QQimgView;
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;
@property (weak, nonatomic) IBOutlet UIView *weChatView;
@property (weak, nonatomic) IBOutlet UIImageView *wxImgView;
@property (weak, nonatomic) IBOutlet UILabel *wxLabel;
@property (weak, nonatomic) IBOutlet UIView *QQZoneView;
@property (weak, nonatomic) IBOutlet UIImageView *QZoneImgView;
@property (weak, nonatomic) IBOutlet UILabel *QzoneL;
@property (weak, nonatomic) IBOutlet UIView *friendCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *friendImgView;
@property (weak, nonatomic) IBOutlet UILabel *frienfLabel;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *QzoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;

@end
