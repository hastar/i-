//
//  WealModel.h
//  i资讯
//
//  Created by lanou on 15/9/9.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WealModel : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *publishedAt;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@end
