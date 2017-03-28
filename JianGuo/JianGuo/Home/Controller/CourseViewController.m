//
//  CourseViewController.m
//  JianGuo
//
//  Created by apple on 17/3/9.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "CourseViewController.h"

@interface CourseViewController ()

@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.5];
}
- (IBAction)gotoScan:(id)sender {
    
    if (self.callBackBlock) {
        self.callBackBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
