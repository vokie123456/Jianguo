//
//  PostSuccessViewController.m
//  JianGuo
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "PostSuccessViewController.h"

@interface PostSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation PostSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = self.labelStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = WHITECOLOR;
}


- (IBAction)dismiss:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.callBackBlock) {
        self.callBackBlock();
    }
    
}

@end
