//
//  IOSViewController.m
//  i资讯
//
//  Created by lanou on 15/9/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#import "AppDelegate.h"
#import "IOSViewController.h"
#import "IOSModel.h"
#import "IOSDetailViewController.h"
#import "NewsDetailViewController.h"

#define kTechUrl @"http://gank.avosapps.com/api/day/"
@interface IOSViewController () <UITableViewDataSource, UITableViewDelegate>

//tableView
@property (nonatomic, strong) UITableView *tableView;
//前多少天
@property (nonatomic, assign) NSUInteger preDay;
//数据源数组
@property (nonatomic, strong) NSMutableArray *dataArray;
//数据加载状态
@property (nonatomic, assign) BOOL isLoading;


@end

@implementation IOSViewController

#pragma mark 获取前几天的日期
-(NSString *)dateWithPreday:(NSUInteger)preDay
{
    NSTimeInterval preDaySec = -24.0 *60 * 60 * preDay;
    
    NSDate *date = [NSDate date];
    date = [NSDate dateWithTimeInterval:preDaySec sinceDate:date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [df stringFromDate:date];
    
    
    
    return dateString;
}

#pragma mark dataArray的懒加载
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return _dataArray;
}

#pragma mark tableView的懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
    
    return _tableView;
}

#pragma mark 加载一天的数据
-(void)loadDataWithPreday:(NSUInteger)preDay
{
    self.preDay++;
    self.isLoading = YES;
    
    __block NSString *dateString = [self dateWithPreday:preDay];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kTechUrl, dateString];
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    __block typeof(self)weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data != nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dict = dict[@"results"];
            NSArray *array = dict[@"iOS"];
            
            NSMutableArray *modelArray = [[NSMutableArray alloc] init];
            for (NSDictionary *modelDic in array) {
                IOSModel *model = [[IOSModel alloc] init];
                [model setValuesForKeysWithDictionary:modelDic];
                [modelArray addObject:model];
            }
            
            if (modelArray.count < 1) {
                return ;
            }
            
            NSDictionary *modelDict = @{@"ios":modelArray,@"date":dateString};
            [weakSelf.dataArray addObject:modelDict];
            [weakSelf.dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString *str1 = obj1[@"date"];
                NSString *str2 = obj2[@"date"];
                return [str2 compare:str1];
            }];
            [weakSelf.tableView reloadData];
            self.isLoading = NO;
        }
    }];
}

#pragma mark 连续加载一段时间的数据
-(void)loadPageData
{
    NSUInteger start = self.preDay;
    for (int i = 0; i < 5; i++) {
        [self loadDataWithPreday:start+i];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoading = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self loadPageData];
    [self loadPageData];
//    [self loadPageData];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArray[section];
    return [dict[@"ios"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
    }
    
    NSArray *array = self.dataArray[indexPath.section][@"ios"];
    IOSModel *model = array[indexPath.row];
    
    cell.textLabel.text = model.desc;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = (NSString *)(self.dataArray[section][@"date"]);
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark 滚到到一定位置，加载数据
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath.section > self.dataArray.count - 5 && !self.isLoading) {
        [self loadPageData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataArray[indexPath.section][@"ios"];
    IOSModel *model = array[indexPath.row];
    
    

    IOSDetailViewController *detailVc = [[IOSDetailViewController alloc] init];
    detailVc.model = model;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *rootNav = (UINavigationController *)appDelegate.window.rootViewController;
    [rootNav.topViewController.navigationController pushViewController:detailVc animated:YES];
    
    
//    
//    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVc];
//
//    [self presentViewController:detailNav animated:YES completion:nil];
    
}


-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

-(void)viewDidLayoutSubviews
{
    self.tableView.frame = self.view.bounds;
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
