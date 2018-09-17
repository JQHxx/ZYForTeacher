//
//  PhotosView.m
//  ZuoYe
//
//  Created by vision on 2018/8/15.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "PhotosView.h"
#import "HorizontalFlowLayout.h"
#import "PhotoCollectionViewCell.h"

@interface PhotosView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView    *photoCollectionView;



@end

@implementation PhotosView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        HorizontalFlowLayout *layout = [[HorizontalFlowLayout alloc] init];
        
        self.photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        self.photoCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.photoCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.photoCollectionView.showsHorizontalScrollIndicator =NO;
        self.photoCollectionView.delegate = self;
        self.photoCollectionView.dataSource = self;
        self.photoCollectionView.backgroundColor = [UIColor bgColor_Gray];
        [self.photoCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
        [self addSubview:self.photoCollectionView];
        
    }
    return self;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    [cell.coverImgView setImage:[UIImage imageNamed:[self.photosArray objectAtIndex:indexPath.item]]];
    return cell;
}

#pragma mark 水平排放(变成一排展示)
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(200, 260);
}

#pragma mark  使前后项都能居中显示
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:section];
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount-1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width)/2, 0, (collectionView.bounds.size.width - lastSize.width)/2);
}

#pragma mark
-(void)setPhotosArray:(NSMutableArray *)photosArray{
    _photosArray = photosArray;
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    [self.photoCollectionView reloadData];
    [self.photoCollectionView layoutIfNeeded];
}

@end
