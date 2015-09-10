//
//  PictureFlowLayout.h
//  i资讯
//
//  Created by lanou on 15/9/9.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureFlowLayout;
@protocol PictureFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

@required
-(NSInteger)numberOfColumnInCollectionView;
-(CGFloat)pictureFlowLayout:(PictureFlowLayout *)flowLayout indexPath:(NSIndexPath *)indexPath;

@end

@interface PictureFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id<PictureFlowLayoutDelegate> delegate;

@end
