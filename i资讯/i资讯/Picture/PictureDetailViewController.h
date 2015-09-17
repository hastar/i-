//
//  PictureDetailViewController.h
//  i资讯
//
//  Created by lanou on 15/9/15.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PageBlock)(NSInteger page);
@interface PictureDetailViewController : UIViewController

//接收所有model对象的数组
@property (nonatomic, strong) NSMutableArray *dataArray;

//当前加载了多少页数据
@property (nonatomic, assign) NSInteger page;

//当前需要显示第几页
@property (nonatomic, assign) NSInteger index;

//向回传值的block
@property (nonatomic, copy) PageBlock pageBlock;

@end
