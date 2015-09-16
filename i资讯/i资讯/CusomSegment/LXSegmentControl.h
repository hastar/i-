//
//  LXSegmentControl.h
//  CustomSegmentDemo
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LXSegmentControlDelegate;

@interface LXSegmentControl : UIControl

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) IBOutlet id <LXSegmentControlDelegate> delegate;

//初始化segment的大小
- (instancetype)initWithFrame:(CGRect)frame;

//设置字体的颜色,下划条的颜色
- (void)setSliderColor:(UIColor *)color;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

//设置整个segment的背景图片
- (void)setSegmentBackImage:(UIImage *)image;
- (void)setSegmentBackColor:(UIColor *)color;

- (void)setFont:(UIFont *)font;
@end


@protocol LXSegmentControlDelegate <NSObject>

@required

-(void)LXSegmentControl:(LXSegmentControl *)segment didSelectItemAtIndex:(NSInteger)index;

@end