//
//  PostSkillViewController.h
//  JianGuo
//
//  Created by apple on 17/9/13.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "NavigatinViewController.h"

@interface PostSkillViewController : NavigatinViewController


@property (nonatomic,assign) BOOL isFromDraftVC;
/** 草稿id */
@property (nonatomic,copy) NSString *draftId;


@end
