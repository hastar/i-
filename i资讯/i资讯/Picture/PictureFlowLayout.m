//
//  PictureFlowLayout.m
//  i资讯
//
//  Created by lanou on 15/9/9.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "PictureFlowLayout.h"

@interface PictureFlowLayout ()

//存储所有item的布局属性
@property (nonatomic, strong) NSArray *attributsArray;

//一共有多少个item
@property (nonatomic, assign) NSInteger itemCount;

//一共有多少列
@property (nonatomic, assign) NSInteger columnCount;

@end

@implementation PictureFlowLayout

- (NSInteger)shortestColumnHeigh:(CGFloat *)columnHeigh
{
    CGFloat min = CGFLOAT_MAX;
    NSInteger column = 0;
    for (int i = 0; i < self.columnCount; i++) {
        if (columnHeigh[i] < min) {
            min = columnHeigh[i];
            column = i;
        }
    }
    
    return column;
}

- (NSInteger)heihtestColumnHeigh:(CGFloat *)columnHeigh
{
    CGFloat max = -1;
    NSInteger column = 0;
    for (int i = 0; i < self.columnCount; i++) {
        if (columnHeigh[i] > max) {
            max = columnHeigh[i];
            column = i;
        }
    }
    
    return column;
}

-(NSInteger)maxCount:(CGFloat *)columnItemCount
{
    CGFloat max = -1;
    NSInteger column = 0;
    for (int i = 0; i < self.columnCount; i++) {
        if (columnItemCount[i] > max) {
            max = columnItemCount[i];
            column = i;
        }
    }
    
    return column;
}


#pragma mark 计算所有的布局信息
-(void)computeAttributesWithItemWidth:(CGFloat)itemWidth
{
    CGFloat columnHeight[self.columnCount]; //存储每一列的最高Y值
    CGFloat columnItemCount[self.columnCount];  //存储每一列现在有多少个item
    
    //初始化数组内容
    for (int i = 0; i < self.columnCount; i++) {
        columnHeight[i] = self.sectionInset.top;
        columnItemCount[i] = 0;
    }
    
    NSMutableArray *layoutAttributs = [[NSMutableArray alloc] initWithCapacity:2];
    for (NSInteger index = 0; index < self.itemCount; index++) {
        //第i个item的位置信息
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        //创建布局属性对象
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        //获取放置item的列号
        NSInteger column = [self shortestColumnHeigh:columnHeight];
        columnItemCount[column]++;
        
        //X值
        CGFloat itemX = (itemWidth + self.minimumInteritemSpacing) * column
        + self.sectionInset.left;
        
        //Y 值
        CGFloat itemY = columnHeight[column];
        
        //计算item的高度
        CGFloat itemHeight = 0.0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(pictureFlowLayout:indexPath:)]) {
            itemHeight = [self.delegate pictureFlowLayout:self indexPath:indexPath];
        }
        
        //设置item的frame属性
        attribute.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        [layoutAttributs addObject:attribute];
        
        //对应列的高度增加
        columnHeight[column] += itemHeight + 2;
    }
    
    //获取最高的列号
    NSInteger maxColumn = [self heihtestColumnHeigh:columnHeight];
    
    //获取平均列高
    CGFloat itemHeight = (columnHeight[maxColumn] - self.minimumInteritemSpacing * (columnItemCount[maxColumn] - 1)) / columnItemCount[maxColumn];
    
    //设置itemSize
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //添加页脚属性
    NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footerIndexPath];
    footerAttr.frame = CGRectMake(0, columnHeight[maxColumn], self.collectionView.bounds.size.width, 50);
    [layoutAttributs addObject:footerAttr];
    
    
    //复制布局属性数组
    self.attributsArray = [layoutAttributs copy];
}


#pragma mark 加载前的准备工作，布局的计算就在这里
-(void)prepareLayout
{
    self.columnCount = 2;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(numberOfColumnInCollectionView)]) {
        self.columnCount = [self.delegate numberOfColumnInCollectionView];
    }
    
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat contectWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
    CGFloat marginX = self.minimumInteritemSpacing;
    
    CGFloat itemWidth = (contectWidth - marginX * (self.columnCount - 1))/self.columnCount;
    
    [self computeAttributesWithItemWidth:itemWidth];
}

#pragma mark 返回所有的布局信息
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributsArray;
}

@end
