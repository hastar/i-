//
//  LXSegmentControl.m
//  CustomSegmentDemo
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "LXSegmentControl.h"

#define kTag 10
@interface LXSegmentControl ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *sliderLabel;

@property (nonatomic, assign) CGFloat buttonWidth;

@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) UIColor *buttonSelectedColor;
@property (nonatomic, strong) UIColor *buttonHighLightColor;

@property (nonatomic, strong) UIColor *sliderColor;

@end

@implementation LXSegmentControl


-(void)setup
{
    self.selectedIndex = 0;
    if (!self.contentView) {
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentView];
    }
}

-(UILabel *)sliderLabel
{
    if (!_sliderLabel) {
        _sliderLabel = [[UILabel alloc] init];
        _sliderLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_sliderLabel];
    }
    
    return _sliderLabel;
}

//初始化segment的大小
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)setButtons:(NSArray *)buttons
{
    _buttons = buttons;
    
    CGFloat x = 0;
    CGFloat subWidth = self.bounds.size.width / buttons.count;
    for (int i = 0; i < buttons.count; i++) {
        NSString *title = buttons[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, subWidth, self.bounds.size.height)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = kTag+i;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        x += subWidth;
        [self.contentView addSubview:button];
    }
    LXLog(@"当前选中项:%ld", self.selectedIndex);
    
    UIButton *button = (UIButton *)[self.contentView viewWithTag:self.selectedIndex+kTag];
    button.selected = YES;
    [self buttonSelect:button];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if (self.buttons.count <= selectedIndex) {
        return ;
    }
    
    [self buttonSelect:(UIButton *)[self.contentView viewWithTag:self.selectedIndex+kTag]];
}


//设置字体的颜色,下划条的颜色
- (void)setSliderColor:(UIColor *)color
{
    _sliderColor = color;
    self.sliderLabel.backgroundColor = color;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    for (UIButton *button in self.contentView.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        
        [button setTitleColor:color forState:state];
    }
}

//设置整个segment的背景图片
- (void)setSegmentBackImage:(UIImage *)image
{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
}
- (void)setSegmentBackColor:(UIColor *)color
{
    self.contentView.backgroundColor = color;
}

- (void)setFont:(UIFont *)font
{
    for (UIButton *button in self.contentView.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        
        button.titleLabel.font = font;
    }
}


- (void)buttonSelect:(UIButton *)sender
{
    if (sender.tag == self.selectedIndex-kTag) return;
    
    CGRect frame = sender.frame;
    self.sliderLabel.frame = CGRectMake(frame.origin.x, frame.size.height - 3, frame.size.width, 3);
    self.sliderLabel.backgroundColor = self.sliderColor;
    
    for (UIButton *button in self.contentView.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        button.selected = NO;
    }
    
    sender.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(LXSegmentControl:didSelectItemAtIndex:)]) {
        [self.delegate LXSegmentControl:self didSelectItemAtIndex:sender.tag-kTag];
    }
    
    _selectedIndex = sender.tag + kTag;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
