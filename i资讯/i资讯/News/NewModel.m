//
//  NewModel.m
//  i资讯
//
//  Created by lanou on 15/9/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "NewModel.h"

@implementation NewModel



-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.desc = [NSString stringWithFormat:@"%@", value];
    }
    
}

@end
