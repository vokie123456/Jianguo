//
//  WebViewController.h
//  JianGuo
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"
@class DiscoveryModel;
@interface WebViewController : NavigatinViewController

@property (nonatomic,strong) DiscoveryModel *model;

@property (nonatomic,assign) BOOL ishaveShareButton;

@property (nonatomic,copy) NSString *url;

@end
