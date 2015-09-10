//
//  IOSDetailViewController.m
//  i资讯
//
//  Created by lanou on 15/9/8.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "IOSDetailViewController.h"

@interface IOSDetailViewController () <UIWebViewDelegate>

//用来显示网页内容
@property (nonatomic, strong) UIWebView *webView;

//是否已经加载
@property (nonatomic, assign) BOOL isLoaded;

@end

@implementation IOSDetailViewController

#pragma mark webView的懒加载
-(UIWebView *)webView
{
    if (_webView == nil) {
        
        CGRect frame = [UIScreen mainScreen].bounds;
        
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
    }
    
    return _webView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLoaded = NO;
    
    //添加webView
    [self.view addSubview:self.webView];
    
    //加载webView数据
    NSURL *url = [NSURL URLWithString:self.news_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //显示导航栏，隐藏tabbar
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.absoluteString);
    if (!self.isLoaded) {
        self.isLoaded = YES;
        return YES;
    }
    
    return NO;
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
