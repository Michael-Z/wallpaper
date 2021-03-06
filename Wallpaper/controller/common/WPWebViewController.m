//
//  WPWebViewController.m
//  Wallpaper
//
//  Created by kyson on 03/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "WPWebViewController.h"
#import <WebKit/WebKit.h>

@interface WPWebViewController()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView  *webView;
@property (nonatomic, strong) UIButton *leftNavigationBarButton;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation WPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc]init];
    self.leftNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image1 = [UIImage imageNamed:@"icon_navi_back"];
    [self.leftNavigationBarButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [self.leftNavigationBarButton setFrame:CGRectMake(0, 0, 20, 21)];
    [btnItem1 setCustomView:self.leftNavigationBarButton];
    @weakify(self);
    [[self.leftNavigationBarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    self.navigationItem.leftBarButtonItem = btnItem1;
    
    [self handleNavigationWithScrollView:self.webView.scrollView];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
    NSURL *url = [NSURL URLWithString:self.loadingURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self.indicatorView startAnimating];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self.indicatorView stopAnimating];

}

-(WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    }
    return _webView;
}


-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _indicatorView.hidesWhenStopped = YES;
        _indicatorView.color = UIColor.lightGrayColor;
    }
    return _indicatorView;
}

@end
