//
//  PictureDetailViewController.m
//  i资讯
//
//  Created by lanou on 15/9/15.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "PictureDetailViewController.h"

@interface PictureDetailViewController ()

@end

@implementation PictureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
