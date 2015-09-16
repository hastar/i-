//
//  PageViewController.h
//  i资讯
//
//  Created by lanou on 15/9/14.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController

//标题数组
@property (nonatomic, retain) NSArray *titles;
//子视图控制器数组
@property (nonatomic, retain) NSArray *subControllers;


//初始化方法
-(instancetype)initWithTitles:(NSArray *)titles ViewControllers:(NSArray *)subControllers;

//设置标题背景色
-(void)setTitleBackgroundColor:(UIColor *)color;

//设置标题字体颜色
-(void)setTitleNormalColor:(UIColor *)color;
-(void)setTitleSelectedColor:(UIColor *)color;


@end
