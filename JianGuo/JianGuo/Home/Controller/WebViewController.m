//
//  WebViewController.m
//  JianGuo
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation WebViewController

-(WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, SCREEN_W, 10);
    self.progressView.progressTintColor = YELLOWCOLOR;
    [self.view addSubview:self.progressView];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }else if( [keyPath isEqualToString: @"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }
}
-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}













// 允许多个手势并发,不然 webview 会导致导航右滑返回手势失效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
