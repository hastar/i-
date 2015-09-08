//
//  IOSDetailViewController.m
//  i资讯
//
//  Created by lanou on 15/9/8.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "IOSDetailViewController.h"

@interface IOSDetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation IOSDetailViewController

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
