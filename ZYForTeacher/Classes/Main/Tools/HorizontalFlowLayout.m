//
//  HorizontalFlowLayout.m
//  ZuoYe
//
//  Created by vision on 2018/8/10.
//  Copyright © 2018年 vision. All rights reserved.
/*
 1)重写   - (void)prepareLayout
 
 - 该方法是准备布局，会在cell显示之前调用，可以在该方法中设置布局的一些属性，比如滚动方向，cell之间的水平间距，以及行间距等
 - 也建议在这个方法中做布局的初始化操作，不建议在init方法中初始化，这个时候可能CollectionView还没有创建，官方文档也有明确说明哦
 - 如果重写了该方法，一定要调用父类的prepareLayout
 2) 重写   - (NSArray *)layoutAttributesForElementsInRect:(CGRect):rect
 
 - 该方法的返回值是一个存放着rect范围内所有元素的布局属性的数组
 - 数组里面的对象决定了rect范围内所有元素的排布（frame）
 - 里面存放的都是UICollectionViewLayoutAttributes对象，该对象决定了cell的排布样式
 - 一个cell就对应一个UICollectionViewLayoutAttributes对象
 - UICollectionViewLayoutAttributes对象决定了cell的frame
 3) 重写   - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
 - 是否允许在里面cell位置改变的时候重新布局
 - 默认是NO，返回YES的话，该方法内部重新会按顺序调用以下2个方法
 **- (void)prepareLayout
 **- (NSArray *)layoutAttributesForElementsInRect:(CGRect):rect
 
 4)重写   - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
 - proposedContentOffset：原本情况下，collectionview停止滚动时最终的偏移量
 **滑动的时候手松开因为惯性并不会立即停止，会再滚动一会才会真正停止，这个属性就是记录这个真正停止这一刻的偏移量
 **我们这个效果是手指松开，完全停止滚动的时候，离屏幕中间y值最近的cell自动滚动到屏幕的中间
 **所以我们需要利用该方法的返回值，这个返回值就是需要我们给一个偏移量，这个collectionview在它由于惯性滚动结束后，再去多滚动我们给的这一部分偏移量
 - velocity：滚动速率，可以根据velocity的x或y判断它是向上/向下/向右/向左滑动
 **这个参数在这里没有什么用，但是这个参数本身还是非常有用的，我之前使用过它来判断当前tabbleview是向上滑还是向下滑，这个时候可以通过这个判断很简单的就控制是隐藏tabBar或者显示tabBar，或者是隐藏显示导航条，使用很爽
 
 */
//

#import "HorizontalFlowLayout.h"


@implementation HorizontalFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];

    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 20;
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 拿到系统已经帮我们计算好的布局属性数组，然后对其进行拷贝一份，后续用这个新拷贝的数组去操作
    NSArray *originalArray = [super layoutAttributesForElementsInRect:rect];
    NSArray *curArray = [[NSArray alloc] initWithArray:originalArray copyItems:YES];
    
    // 计算collectionView中心点的y值(这个中心点可不是屏幕的中线点哦，是整个collectionView的，所以是包含在屏幕之外的偏移量的哦)
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
     // 拿到每一个cell的布局属性，在原有布局属性的基础上，进行调整
    for (UICollectionViewLayoutAttributes *attrs in curArray) {
        // cell的中心点y 和 collectionView最中心点的y值 的间距的绝对值
        CGFloat space = ABS(attrs.center.x - centerX);
        // 根据间距值 计算 cell的缩放比例
        // 间距越大，cell离屏幕中心点越远，那么缩放的scale值就小
        CGFloat scale = 1 - space / self.collectionView.frame.size.width;
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return curArray;
}

//  每次都有图片居中
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 计算出停止滚动时(不是松手时)最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得系统已经帮我们计算好的布局属性数组
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的y值
    // 再啰嗦一下，这个proposedContentOffset是系统帮我们已经计算好的，当我们松手后它惯性完全停止后的偏移量
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 当完全停止滚动后，离中点Y值最近的那个cell会通过我们多给出的偏移量回到屏幕最中间
    // 存放最小的间距值
    // 先将间距赋值为最大值，这样可以保证第一次一定可以进入这个if条件，这样可以保证一定能闹到最小间距
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minSpace) > ABS(attrs.center.x - centerX)) {
            minSpace = attrs.center.x - centerX;
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minSpace;
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




@end
