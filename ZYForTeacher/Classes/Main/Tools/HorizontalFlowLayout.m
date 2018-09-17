//
//  HorizontalFlowLayout.m
//  ZuoYe
//
//  Created by vision on 2018/8/10.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "HorizontalFlowLayout.h"


@implementation HorizontalFlowLayout

-(instancetype)init{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *arr = [self getCopyOfAttributes:[super layoutAttributesForElementsInRect:rect]];
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *attr in arr) {
        CGFloat scale = 1 - fabs(attr.center.x - contentOffsetX - collectionViewCenterX) /self.collectionView.bounds.size.width;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return arr;
}

//  每次都有图片居中
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width,self.collectionView.bounds.size.height);
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
    CGFloat minDistance = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGFloat distance = attr.center.x - contentOffsetX - collectionViewCenterX;
        if (fabs(distance) < fabs(minDistance)) {
            minDistance = distance;
        }
    }
    
    proposedContentOffset.x += minDistance;
    return proposedContentOffset;
}

//防止报错 先复制attributes
- (NSArray *)getCopyOfAttributes:(NSArray *)attributes
{
    NSMutableArray *copyArr = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [copyArr addObject:[attribute copy]];
    }
    return copyArr;
}


//是否需要重新计算布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return true;
}

@end
