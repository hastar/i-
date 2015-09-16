//
//  PageViewController.m
//  i资讯
//
//  Created by lanou on 15/9/14.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "PageViewController.h"

#define kTag 5200
#define kHeaderHeight 64.0
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height



@interface PageViewController () <UIScrollViewDelegate>

//头部背景View
@property (nonatomic, retain) UIView *headerView;

//装载所有的子subControllers;
@property (nonatomic, retain) UIScrollView *scrollView;

//标题字体的颜色
@property (nonatomic, retain) UIColor *normalColor;
@property (nonatomic, retain) UIColor *selectedColor;

//下划线
@property (nonatomic, retain) UILabel *sliderLabel;

//button的宽度
@property (nonatomic, assign) CGFloat btnWidth;

@end

@implementation PageViewController

#pragma mark sliderLabel 的懒加载
-(UILabel *)sliderLabel
{
    if (_sliderLabel == nil) {
        _sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.headerView.bounds.size.height - 2, self.btnWidth, 2)];
    }
    return _sliderLabel;
}

#pragma mark headerView的懒加载
-(UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeaderHeight)];
    }
    
    return _headerView;
}

#pragma mark scrollView的懒加载
-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        
        CGRect frame = self.view.bounds;
        frame.origin.y = kHeaderHeight;
        frame.size.height -= kHeaderHeight;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor redColor];
    }
    
    return _scrollView;
}

#pragma mark 添加标题按钮
-(void)initButtonAndSubviews
{
    int i = 0;
    CGFloat btnX = 0;
    CGFloat btnY = 30;
    CGFloat btnWidth = self.view.bounds.size.width / self.titles.count;
    
    CGFloat subViewX = 0;
    CGFloat subViewHeight = self.view.bounds.size.height - kHeaderHeight;
    
    while (i < self.titles.count && i < self.subControllers.count) {
        //添加按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnX, btnY, btnWidth, kHeaderHeight - btnY);
        button.tag = kTag + i;
        button.titleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:16];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedColor forState:UIControlStateHighlighted];
        [button setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:button];
        
        btnX += btnWidth;
        
        
        //添加子视图
        UIViewController *viewController = self.subControllers[i];
        viewController.view.tag = kTag + i;
        CGRect frame = viewController.view.frame;
        
        frame.origin.x = subViewX;
        frame.size.height = subViewHeight;
        viewController.view.frame = frame;
        [self.scrollView addSubview:viewController.view];
        
        subViewX += [UIScreen mainScreen].bounds.size.width;
        
        i++;
    }
    
    self.scrollView.contentSize = CGSizeMake(i * kWidth, kHeight - kHeaderHeight);
    [self selectedIndex:kTag];
    
}

#pragma mark 选中某一标题button
-(void)selectedButtonIndex:(NSUInteger)index
{
    for (UIButton *btn in self.headerView.subviews) {
        if (btn.tag >= kTag) {
            
            [btn setSelected:NO];
            if (btn.tag == index)
            {
                [btn setSelected:YES];
            }
        }
    }
}

#pragma mark  选中某一页
-(void)selectedIndex:(NSUInteger)index
{
    [self selectedButtonIndex:index];
    
    NSUInteger i = index - kTag;
    CGRect frame = self.sliderLabel.frame;
    frame.origin.x = i * self.btnWidth;
    [UIView animateWithDuration:0.4 animations:^{
        self.sliderLabel.frame = frame;
        self.scrollView.contentOffset = CGPointMake(i * kWidth, 0);
    }];
    
}



#pragma mark 标题按钮点击响应方法
-(void)buttonSelected:(UIButton *)sender
{
    [self selectedIndex:sender.tag];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnWidth = kWidth / self.titles.count;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitleBackgroundColor:[UIColor colorWithRed:110.0/256 green:58.0/256 blue:188.0/256 alpha:1.0]];
    
    [self setTitleNormalColor:[UIColor lightGrayColor]];
    [self setTitleSelectedColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.headerView addSubview: self.sliderLabel];
    self.sliderLabel.backgroundColor = [UIColor redColor];
    
    
    [self initButtonAndSubviews];    
}

#pragma mark 视图即将出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark 初始化方法
-(instancetype)initWithTitles:(NSArray *)titles ViewControllers:(NSArray *)subControllers
{
    if (self = [super init]) {
        _titles = [NSArray arrayWithArray:titles];
        _subControllers = [NSArray arrayWithArray:subControllers];
    }
    
    return self;
}

#pragma mark 设置标题背景颜色
-(void)setTitleBackgroundColor:(UIColor *)color
{
    self.headerView.backgroundColor = color;
}


#pragma mark 设置正常情况下的标题颜色
-(void)setTitleNormalColor:(UIColor *)color
{
    self.normalColor = color;
}

#pragma mark 设置选中情况下的标题颜色
-(void)setTitleSelectedColor:(UIColor *)color
{
    self.selectedColor = color;
}

#pragma mark 滚动时响应
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.sliderLabel.frame;
    CGFloat totalWidth =self.btnWidth / (kWidth * (self.titles.count-1));
    frame.origin.x = totalWidth * scrollView.contentOffset.x * 2;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderLabel.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
