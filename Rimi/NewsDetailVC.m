//
//  NewsDetailVC.m
//  Rimi
//
//  Created by 王志龙 on 15/8/19.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "NewsDetailVC.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface NewsDetailVC () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSString *NewsURL;
@end

@implementation NewsDetailVC
@synthesize NewsURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:NewsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView setScalesPageToFit:YES];
    self.webView.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showHUD {
    [[UIApplication sharedApplication].keyWindow addSubview:self.hud];
    [self.hud show:YES];
}

- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    }
    return _hud;
}
#pragma mark WebDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud removeFromSuperview];
}
@end
