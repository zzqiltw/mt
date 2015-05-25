//
//  ZQPDFViewController.m
//  MT
//
//  Created by zzqiltw on 15/5/24.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQPDFViewController.h"

@interface ZQPDFViewController ()
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation ZQPDFViewController

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:self.filename ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


@end
