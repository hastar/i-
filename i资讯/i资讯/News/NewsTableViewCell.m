//
//  NewsTableViewCell.m
//  i资讯
//
//  Created by lanou on 15/9/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "NewModel.h"
#import "UIImageView+WebCache.h"

@interface NewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@end

@implementation NewsTableViewCell

-(void)setModel:(NewModel *)model
{
    _model = model;
    
    self.titleLabel.text = self.model.short_title;
    self.descLabel.text = self.model.title;
//    if (self.model.desc.length > 55) {
//        self.descLabel.text = [self.model.desc substringToIndex:50];
//    }
//    else
//    {
//        self.descLabel.text = self.model.desc;
//    }
    
    self.timeLabel.text = self.model.inputtime;

    [self.titeImageView sd_setImageWithURL:[NSURL URLWithString:self.model.title_pic] placeholderImage:[UIImage new]];
    
}

- (void)awakeFromNib {

    //cell圆角
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.clipsToBounds = YES;
    
    //设置图片的填充模式
    self.titeImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //设置图片的大小
    CGFloat rate = 160.0/290.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width/3;
    CGFloat height = width * rate;
    self.imageViewWidth.constant = width;
    self.imageViewHeight.constant = height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
