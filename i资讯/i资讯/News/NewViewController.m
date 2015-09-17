//
//  NewViewController.m
//  i资讯
//
//  Created by lanou on 15/9/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "AppDelegate.h"
#import "NewViewController.h"
#import "NewModel.h"
#import "NewsTableViewCell.h"
#import "NewsDetailViewController.h"

#define kNewsUrl @"http://wap.25pp.com/news/ajax_list/133/10/"

@interface NewViewController ()<UITableViewDataSource, UITableViewDelegate>

//当前数据已经加载到了第几页
@property (nonatomic, assign) NSUInteger index;
//tableview用于数据显示
@property (nonatomic, strong) UITableView *tableView;
//数据源数组，所有的数据都放在这个数组中
@property (nonatomic, strong) NSMutableArray *dataArray;

//是否正在加载数据
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation NewViewController

#pragma mark 数据源数组的懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return _dataArray;
}

#pragma mark tableView的懒加载
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UINib *nib = [UINib nibWithNibName:@"NewsTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"cellID"];

    }
    
    return _tableView;
}


- (void)loadNewDataWithIndex:(NSUInteger)index
{
    NSString *urlString = [NSString stringWithFormat:@"%@%lu", kNewsUrl, index];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.isLoading = YES;
    __block typeof(self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDic = dic[@"data"];
            NSArray *array = dataDic[@"data"];
            for (NSDictionary *modeDic in array) {
                NewModel *model = [[NewModel alloc] init];
                [model setValuesForKeysWithDictionary:modeDic];
                [weakSelf.dataArray addObject:model];
            }
            weakSelf.index++;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.isLoading = NO;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置其实页码
    self.index = 1;
    self.isLoading = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    //加载数据
    [self loadNewDataWithIndex:self.index];
    [self loadNewDataWithIndex:self.index];
    
}


#pragma mark - tableView代理方法
#pragma mark - 返回每个section有多少个item
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark 有多少个section(每个条新闻当作一个section，有利于间隔的显示)
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

#pragma mark 返回cell数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"cellID";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NewModel *model = self.dataArray[indexPath.section];
    
    cell.model = model;    
    
    return cell;
}


#pragma mark 响应点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewModel *model = self.dataArray[indexPath.section];
    
    NewsDetailViewController *newDetailVc = [[NewsDetailViewController alloc] init];
    newDetailVc.model = model;
 
 
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *rootNav = (UINavigationController *)appDelegate.window.rootViewController;
    [rootNav.topViewController.navigationController pushViewController:newDetailVc animated:YES];
    
}



#pragma mark 当滚动到一定位置，就加载数据
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSLog(@"%ld", indexPath.section);
    
    if (indexPath.section > (self.dataArray.count - 18) && !self.isLoading) {
        [self loadNewDataWithIndex:self.index];
    }
    
}

#pragma mark 设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rate = 160.0/290.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width/3;
    CGFloat height = width * rate;
    return height + 20;
}

#pragma mark 设置分区头高度(和分区尾一起够成cell间隔)
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

#pragma mark 设置分区尾高度(和分区头一起够成cell间隔)
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
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
