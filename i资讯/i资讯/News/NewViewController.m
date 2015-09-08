//
//  NewViewController.m
//  i资讯
//
//  Created by lanou on 15/9/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "NewViewController.h"
#import "NewModel.h"
#import "NewsTableViewCell.h"

#define kNewsUrl @"http://wap.25pp.com/news/ajax_list/133/20/"

@interface NewViewController ()<UITableViewDataSource, UITableViewDelegate>

//当前数据已经加载到了第几页
@property (nonatomic, assign) NSUInteger index;
//tableview用于数据显示
@property (nonatomic, strong) UITableView *tableView;
//数据源数组，所有的数据都放在这个数组中
@property (nonatomic, strong) NSMutableArray *dataArray;

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
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDic = dic[@"data"];
            NSArray *array = dataDic[@"data"];
            for (NSDictionary *modeDic in array) {
                NewModel *model = [[NewModel alloc] init];
                [model setValuesForKeysWithDictionary:modeDic];
                [self.dataArray addObject:model];
            }
            self.index++;
            [self.tableView reloadData];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 1;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    [self loadNewDataWithIndex:self.index];
    
}


#pragma mark - tableView代理方法
#pragma mark - 返回有多少个item
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

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
    
    NewModel *model = self.dataArray[indexPath.section];
    
    cell.model = model;    
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSLog(@"%ld", indexPath.row);
    if (indexPath.row > (self.dataArray.count - 18)) {
        [self loadNewDataWithIndex:self.index];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

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
