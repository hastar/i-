//
//  WealModel.m
//  i资讯
//
//  Created by lanou on 15/9/9.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "WealModel.h"
#import "SDWebImageManager.h"

@implementation WealModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(void)setUrl:(NSString *)url
{
    _url = url;
    NSURL *MyUrl = [NSURL URLWithString:url];
    
    self.width = 100;
    self.height = 100;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:MyUrl];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data != nil) {
        UIImage *image = [UIImage imageWithData:data];
        self.width = image.size.width;
        self.height = image.size.height;
    }

    
}

@end
