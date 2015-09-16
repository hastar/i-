//
//  NewsDetailViewController.m
//  i资讯
//
//  Created by lanou on 15/9/8.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "NewsDetailViewController.h"

@interface NewsDetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) WKWebView *wkView;

//是否已经加载
@property (nonatomic, assign) BOOL isLoaded;

//加载进度条
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation NewsDetailViewController

#pragma mark 进度条的懒加载
-(UIProgressView *)progressView{
    if (_progressView == nil) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y = 0;
        frame.size.height = 2;
        
        _progressView = [[UIProgressView alloc] initWithFrame:frame];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
    }
    
    return _progressView;
}


#pragma mark wkView的懒加载
-(WKWebView *)wkView{
    if (_wkView == nil) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y -= 80;
        frame.size.height += 80;
        _wkView = [[WKWebView alloc] initWithFrame:frame];
    }
    
    return _wkView;
}


#pragma mark webView的懒加载
-(UIWebView *)webView
{
    if (_webView == nil) {
        
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y -= 80;
        frame.size.height += 80;
        
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
    }
    
    return _webView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    UIImage *rightImage =  [UIImage imageNamed:@"share"];
    rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(share:)];
    
    //添加webView
    [self.view addSubview:self.wkView];
    [self.view addSubview:self.progressView];
    self.progressView.progress = 0.0;
    
    //加载webView数据
    NSURL *url = [NSURL URLWithString:self.news_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkView loadRequest:request];
    [self.wkView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%f", self.wkView.estimatedProgress);
        [self.progressView setProgress:self.wkView.estimatedProgress animated:YES];
        
        if (self.wkView.estimatedProgress == 1) {
            self.progressView.hidden = YES;
            [self.wkView removeObserver:self forKeyPath:@"estimatedProgress"];
        }
        
    }
}

#pragma mark 返回按钮响应方法
-(void)back:(id)sender
{
    //判断是否已经移除
    while ([self.wkView observationInfo]) {
        
        NSLog(@"%@", [self.wkView observationInfo]);
        [self.wkView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 分享按钮响应方法
- (void)share:(id)sender
{
    NSLog(@"分享");
}


-(void)viewWillAppear:(BOOL)animated
{
    //显示导航栏，隐藏tabbar
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
