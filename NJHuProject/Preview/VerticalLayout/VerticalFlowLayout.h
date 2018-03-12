//
//  VerticalFlowLayout.h
//  NJHuProject
//
//  Created by chrisbin on 10/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerticalFlowLayout;
@protocol VerticalFlowLayoutDelegate<NSObject>

@required
/**
 *  要求实现
 *
 *  @param flowLayout 哪个布局需要代理返回高度
 *  @param indexPath  对应的cell, 的indexPath, 但是indexPath.section == 0
 *  @param width      layout内部计算的宽度
 *
 *  @return 需要代理高度对应的cell的高度
 */
- (CGFloat)verticalFlowLayout:(VerticalFlowLayout *)flowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)width;

@optional
/**
 *  需要显示的列数, 默认3
 */
- (NSInteger)verticalFlowLayout:(VerticalFlowLayout *)flowLayout columnsInCollectionView:(UICollectionView *)collectionView;
/**
 *  列间距, 默认10
 */
- (CGFloat)verticalFlowLayout:(VerticalFlowLayout *)flowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView;
/**
 *  行间距, 默认10
 */
- (CGFloat)verticalFlowLayout:(VerticalFlowLayout *)flowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  距离collectionView四周的间距, 默认{10, 10, 10, 10}
 */
- (UIEdgeInsets)verticalFlowLayout:(VerticalFlowLayout *)flowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView;

@end

@interface VerticalFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<VerticalFlowLayoutDelegate> delegate;

@end
