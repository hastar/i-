//
//  PictureDetailViewController.m
//  i资讯
//
//  Created by lanou on 15/9/15.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "WealModel.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "PictureDetailViewController.h"

#define kWidth self.view.bounds.size.width
#define kHeight self.view.bounds.size.height
#define kWealUrl @"http://gank.avosapps.com/api/data/%E7%A6%8F%E5%88%A9/5/"
@interface PictureDetailViewController () <UIScrollViewDelegate>

//自定义的导航栏
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;

//图片的滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

//3张图片
@property (nonatomic, strong) UIImageView *preImageView;
@property (nonatomic, strong) UIImageView *curImageView;
@property (nonatomic, strong) UIImageView *nextImageView;

//网络加载情况
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation PictureDetailViewController

#pragma mark scrollView 的懒加载
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}



#pragma mark headerView的懒加载
-(UIView *)headerView
{
    if (_headerView == nil) {
        CGRect frame = self.view.bounds;
        frame.size.height = 64;
        _headerView = [[UIView alloc] initWithFrame:frame];
        _headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroup"]];
        _headerView.alpha= 0.5;
        
        //添加返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 20, 40, 40);
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_headerView addSubview:backButton];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(frame.size.width - 40, 20, 40, 40);
        [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_headerView addSubview:shareButton];
        
        //添加头标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/4, 20, kWidth/2, 40)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:self.titleLabel];
    }
    
    
    return _headerView;
}

#pragma mark 返回按钮响应方法
-(void)back:(id)sender
{
    //判断是否已经移除
    if (self.pageBlock) {
        self.pageBlock(self.page);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 分享按钮响应方法
- (void)share:(id)sender
{
    NSLog(@"分享");
    WealModel *model = self.dataArray[self.index];
    NSString *shareString = [NSString stringWithFormat:@"%@\n%@", @"漂亮清纯萌妹子----分享来自i客之家 iPhone客户端",model.url];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55fa1fa867e58e81eb0061cb"
                                      shareText:shareString
                                     shareImage:self.curImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent, UMShareToDouban, UMShareToRenren, nil]
                                       delegate:nil];
}

#pragma mark 系统ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoading = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
    
    //添加前置图片
    UITapGestureRecognizer *preTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.preImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.preImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIScrollView *preScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [preScrollView addSubview:self.preImageView];
    preScrollView.minimumZoomScale = 1;
    preScrollView.maximumZoomScale = 5;
    preScrollView.delegate = self;
    [preScrollView addGestureRecognizer:preTap];
    [self.scrollView addSubview:preScrollView];
    
    //添加当前图片
    UITapGestureRecognizer *curTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.curImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.curImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIScrollView *curScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    [curScrollView addSubview:self.curImageView];
    curScrollView.minimumZoomScale = 1;
    curScrollView.maximumZoomScale = 5;
    curScrollView.delegate = self;
    [curScrollView addGestureRecognizer:curTap];
    [self.scrollView addSubview:curScrollView];
    
    
    //添加后置图片
    UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.nextImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIScrollView *nextScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth * 2, 0, kWidth, kHeight)];
    [nextScrollView addSubview:self.nextImageView];
    nextScrollView.minimumZoomScale = 1;
    nextScrollView.maximumZoomScale = 5;
    nextScrollView.delegate = self;
    [nextScrollView addGestureRecognizer:nextTap];
    [self.scrollView addSubview:nextScrollView];
    
    if (self.dataArray.count == 1) {
        self.scrollView.contentSize = CGSizeMake(kWidth, kHeight);
    }
    else if (self.dataArray.count == 2){
        self.scrollView.contentSize = CGSizeMake(kWidth * 2, kHeight);
    }
    else{
        self.scrollView.contentSize = CGSizeMake(kWidth * 3, kHeight);
    }
    
    
    [self initImage];
}

#pragma mark tap点击事件响应方法
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"接收点击事件");
    self.headerView.hidden = !self.headerView.hidden;
}

#pragma mark 初始化图片
-(void)initImage{
    
    if (self.dataArray.count == 1) {
        WealModel *model = self.dataArray[self.index];
        [self.preImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    else if (self.dataArray.count == 2){
        self.scrollView.contentSize = CGSizeMake(kWidth * 2, kHeight);
        
        WealModel *model = self.dataArray[0];
        [self.preImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
        
        WealModel *model1 = self.dataArray[1];
        [self.curImageView sd_setImageWithURL:[NSURL URLWithString:model1.url]];
        self.scrollView.contentOffset = CGPointMake(self.index * kWidth, 0);
        
    }
    else{
       
        if (self.index == 0) {
            WealModel *model = self.dataArray[0];
            [self.preImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
            
            WealModel *model1 = self.dataArray[1];
            [self.curImageView sd_setImageWithURL:[NSURL URLWithString:model1.url]];
            
            WealModel *model2 = self.dataArray[2];
            [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:model2.url]];
            
            self.scrollView.contentOffset = CGPointZero;
        }
        else if (self.index == self.dataArray.count-1) {
            WealModel *model = self.dataArray[self.index-2];
            [self.preImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
            
            WealModel *model1 = self.dataArray[self.index - 1];
            [self.curImageView sd_setImageWithURL:[NSURL URLWithString:model1.url]];
            
            WealModel *model2 = [self.dataArray objectAtIndex:self.index];
            [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:model2.url]];
            
            self.scrollView.contentOffset = CGPointMake(kWidth * 2, 0);
        }
        else{
            WealModel *model = self.dataArray[self.index-1];
            [self.preImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
            
            WealModel *model1 = self.dataArray[self.index];
            [self.curImageView sd_setImageWithURL:[NSURL URLWithString:model1.url]];
            
            WealModel *model2 = self.dataArray[self.index + 1];
            [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:model2.url]];
            
            self.scrollView.contentOffset = CGPointMake(kWidth, 0);
        }
    }
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"%2ld/%2ld", self.index+1, self.dataArray.count];
}

#pragma mark 下载一页图片
-(void) downLoadPageData
{
    NSLog(@"================================");
    self.page++;
    self.isLoading = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%ld", kWealUrl, self.page];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"%d", [NSThread isMainThread]);
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data != nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dict[@"results"];
        
        if (array.count <= 0) {
            self.isLoading = NO;
            
            return ;
        }
        
        for (NSDictionary *modelDict in array) {
            WealModel *model = [[WealModel alloc] init];
            [model setValuesForKeysWithDictionary:modelDict];
            
            [self.dataArray addObject:model];
        }
        
    }
    
    self.isLoading = NO;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / kWidth;
    
    if (page == 2 && self.index < self.dataArray.count - 2) {
        self.index++;
        NSLog(@"往后走");
        WealModel *model = self.dataArray[self.index];
        [self.curImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
        
        WealModel *model1 = self.dataArray[self.index-1];
        [self.preImageView sd_setImageWithURL:[NSURL URLWithString:model1.url]];
        
        WealModel *mode2 = self.dataArray[self.index + 1];
        [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:mode2.url]];
        self.scrollView.contentOffset = CGPointMake(kWidth, 0);
    }
    else if (page == 0 && self.index > 1) {
        self.index--;
        NSLog(@"往前走");
        WealModel *model = self.dataArray[self.index];
        [self.curImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
        
        WealModel *model1 = self.dataArray[self.index-1];
        [self.preImageView sd_setImageWithURL:[NSURL URLWithString:model1.url]];
        
        WealModel *mode2 = self.dataArray[self.index + 1];
        [self.nextImageView sd_setImageWithURL:[NSURL URLWithString:mode2.url]];
        self.scrollView.contentOffset = CGPointMake(kWidth, 0);
        

    }
    
    NSLog(@"%2ld/%2ld", self.index+1, self.dataArray.count);
    self.titleLabel.text = [NSString stringWithFormat:@"%2ld/%2ld", self.index+1, self.dataArray.count];
    
    if (self.index > self.dataArray.count - 10 && !self.isLoading) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoadPageData) object:nil];
        [queue addOperation:operation];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

@end
