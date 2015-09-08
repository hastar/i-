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

@end

@implementation NewsTableViewCell

-(void)setModel:(NewModel *)model
{
    _model = model;
    
    self.titleLabel.text = self.model.short_title;
    if (self.model.desc.length > 55) {
        self.descLabel.text = [self.model.desc substringToIndex:50];
    }
    else
    {
        self.descLabel.text = self.model.desc;
    }
    
    self.timeLabel.text = self.model.inputtime;

    [self.titeImageView sd_setImageWithURL:[NSURL URLWithString:self.model.title_pic] placeholderImage:[UIImage new]];
    
}

- (void)awakeFromNib {
    // Initialization code
//    self.contentView.backgroundColor = [UIColor lightGrayColor];
    self.titeImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
