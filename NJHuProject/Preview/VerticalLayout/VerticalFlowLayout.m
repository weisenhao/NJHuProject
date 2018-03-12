//
//  VerticalFlowLayout.m
//  NJHuProject
//
//  Created by chrisbin on 10/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "VerticalFlowLayout.h"

static const NSInteger Vertical_Columns = 3;
static const CGFloat Vertical_XMargin = 10;
static const CGFloat Vertical_YMargin = 10;
static const UIEdgeInsets Vertical_EdgeInsets = {10, 10, 10, 10};

@interface VerticalFlowLayout ()

// 所有的cell的attrbts
@property (nonatomic, strong) NSMutableArray *attrArray;

// 每一列的最后的高度
@property (nonatomic, strong) NSMutableArray *columnsHeightArray;

@end

@implementation VerticalFlowLayout

/**
 *  刷新布局的时候回重新调用
 */
- (void)prepareLayout {
    [super prepareLayout];
    // 如果重新刷新就需要移除之前存储的高度
    [self.columnsHeightArray removeAllObjects];
    // 复赋值以顶部的高度, 并且根据列数
    for (NSInteger i = 0; i < [self columns]; i++) {
        [self.columnsHeightArray addObject:@([self edgeInsets].top)];
    }
    // 移除以前计算的cells的attrs
    [self.attrArray removeAllObjects];
    // 并且重新计算, 每个cell对应的atrts, 保存到数组
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrArray addObject:attr];
    }
}

/**
 * 在这里边所处每个cell对应的位置和大小
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat w = 1.0 * (self.collectionView.frame.size.width - [self edgeInsets].left - [self edgeInsets].right - [self xMargin] * ([self columns] - 1)) / [self columns];
    
    w = floorf(w);
    // 高度由外界决定, 外界必须实现这个方法
    CGFloat h = [self.delegate verticalFlowLayout:self collectionView:self.collectionView heightForItemAtIndexPath:indexPath itemWidth:w];
    
    // 拿到最后的高度最小的那一列, 假设第0列最小
    NSInteger indexCol = 0;
    CGFloat minColH = [[self.columnsHeightArray objectAtIndex:indexCol] doubleValue];
    
    for (NSInteger i = 1; i < self.columnsHeightArray.count; i++) {
        CGFloat colH = [self.columnsHeightArray[i] doubleValue];
        if (minColH > colH) {
            minColH = colH;
            indexCol = i;
        }
    }
    
    CGFloat x = [self edgeInsets].left + ([self xMargin] + w) * indexCol;
    CGFloat y = minColH + [self yMarginAtIndexPath:indexPath];
    
    // 第一行
    if (minColH == [self edgeInsets].top) {
        y = [self edgeInsets].top;
    }
    
    // 赋值frame
    attrs.frame = CGRectMake(x, y, w, h);
    self.columnsHeightArray[indexCol] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrArray;
}

- (CGSize)collectionViewContentSize {
    CGFloat maxColH = [self.columnsHeightArray.firstObject doubleValue];
    for (NSInteger i = 1; i < self.columnsHeightArray.count; i++) {
        CGFloat colH = [self.columnsHeightArray[i] doubleValue];
        if (maxColH < colH) {
            maxColH = colH;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, maxColH + [self edgeInsets].bottom);
}

#pragma mark - Private Method
- (NSInteger)columns {
    if ([self.delegate respondsToSelector:@selector(verticalFlowLayout:columnsInCollectionView:)]) {
        return [self.delegate verticalFlowLayout:self columnsInCollectionView:self.collectionView];
    } else {
        return Vertical_Columns;
    }
}

- (CGFloat)xMargin {
    if ([self.delegate respondsToSelector:@selector(verticalFlowLayout:columnsMarginInCollectionView:)]) {
        return [self.delegate verticalFlowLayout:self columnsMarginInCollectionView:self.collectionView];
    } else {
        return Vertical_XMargin;
    }
}

- (CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(verticalFlowLayout:collectionView:linesMarginForItemAtIndexPath:)]) {
        return [self.delegate verticalFlowLayout:self collectionView:self.collectionView linesMarginForItemAtIndexPath:indexPath];
    } else {
        return Vertical_YMargin;
    }
}

- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(verticalFlowLayout:edgeInsetsInCollectionView:)]) {
        return [self.delegate verticalFlowLayout:self edgeInsetsInCollectionView:self.collectionView];
    } else {
        return Vertical_EdgeInsets;
    }
}

#pragma mark - Property
- (NSMutableArray *)attrArray {
    if (_attrArray == nil) {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

- (NSMutableArray *)columnsHeightArray {
    if (_columnsHeightArray == nil) {
        _columnsHeightArray = [NSMutableArray array];
    }
    return _columnsHeightArray;
}

@end
