//
//  PictureViewController.m
//  i资讯
//
//  Created by lanou on 15/9/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureFlowLayout.h"
#import "WealCell.h"
#import "WealModel.h"
#import "UIImageView+WebCache.h"

#define kWealUrl @"http://gank.avosapps.com/api/data/%E7%A6%8F%E5%88%A9/5/"

@interface PictureViewController () <UICollectionViewDataSource, PictureFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

//当前加载到第几页数据
@property (nonatomic, assign) NSInteger page;

//是否正在加载数据
@property (nonatomic, assign) BOOL isLoading;

//网络数据请求队列
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation PictureViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return _dataArray;
}

#pragma mark collectionView懒加载
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        PictureFlowLayout *layout = [[PictureFlowLayout alloc] init];
        layout.delegate = self;
        layout.minimumInteritemSpacing = 2;
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        
        CGRect frame = self.view.bounds;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        UINib *nib = [UINib nibWithNibName:@"WealCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"CollectionCell"];
    }
    
    return _collectionView;
}



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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            return ;
        }
        
        for (NSDictionary *modelDict in array) {
            WealModel *model = [[WealModel alloc] init];
            NSLog(@"\n\n");
            [model setValuesForKeysWithDictionary:modelDict];
            NSLog(@"\n\n");
            
            [self.dataArray addObject:model];
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
    self.isLoading = NO;

}

-(void)addOneLoading
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downLoadPageData) object:nil];
    
    if (self.queue.operationCount > 0) {
        NSLog(@"我是第一个哦哦");
        [operation addDependency:self.queue.operations[self.queue.operationCount-1]];
    }
    
    [self.queue addOperation:operation];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.isLoading = NO;
    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.collectionView];
    
    self.queue = [[NSOperationQueue alloc] init];
    [self.queue setMaxConcurrentOperationCount:1];

    
    for (int i = 0; i < 5; i++) {
        [self addOneLoading];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}


#pragma mark 设置行数
-(NSInteger)numberOfColumnInCollectionView
{
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        return  4;
    }
    else
    {
        return 2;
    }
}
#pragma mark 设置item对应的高度
-(CGFloat)pictureFlowLayout:(PictureFlowLayout *)flowLayout indexPath:(NSIndexPath *)indexPath
{
    WealModel *model = self.dataArray[indexPath.row];
    
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        return  model.height/4.0/2;
    }
    else
    {
        return model.height/2.0/2;
    }
}

#pragma mark 设置item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"布局好乐");
    return self.dataArray.count;
}

#pragma mark 设置item的数据
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[WealCell alloc] init];
    }
    
    WealModel *model = self.dataArray[indexPath.row];
    
    [cell.WealImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage new]];
    
    return cell;
}

#pragma mark item点击事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self loadPageData];
    [self addOneLoading];
}

#pragma mark 滚动到某一程度，继续加载
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat height = scrollView.contentSize.height- self.view.bounds.size.height * 2;
    
    CGPoint point = scrollView.contentOffset;
    
    if (point.y > height && !self.isLoading) {
        NSLog(@"加载数据");
        
        [self addOneLoading];
      
        
        
        
//        [NSThread detachNewThreadSelector:@selector(loadPageData) toTarget:self withObject:nil];
        
    }
}


#pragma mark 屏幕旋转
-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

-(void)viewWillLayoutSubviews
{
    self.collectionView.frame = self.view.bounds;
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
