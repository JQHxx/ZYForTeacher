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
#import "ZYCustomPageControl.h"
#import "SDPhotoBrowser.h"

@interface PhotosView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,SDPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView    *photoCollectionView;
@property (nonatomic, strong) ZYCustomPageControl *pageControl;


@end

@implementation PhotosView

-(instancetype)initWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = bgColor;
        
        HorizontalFlowLayout *layout = [[HorizontalFlowLayout alloc] init];
        layout.sectionInset  = UIEdgeInsetsMake(0, 10, 0, 10);
        
        self.photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20) collectionViewLayout:layout];
        self.photoCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.photoCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.photoCollectionView.showsHorizontalScrollIndicator =NO;
        self.photoCollectionView.delegate = self;
        self.photoCollectionView.dataSource = self;
        self.photoCollectionView.backgroundColor = bgColor;
        [self.photoCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
        [self addSubview:self.photoCollectionView];
        
        self.pageControl = [[ZYCustomPageControl alloc] init];
        self.pageControl.frame = CGRectMake(40, self.photoCollectionView.bottom+10, frame.size.width-80, 8);
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#B4B4B4"];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#4A4A4A"];
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
        
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
    NSString *imgStr = [self.photosArray objectAtIndex:indexPath.item];
    if (kIsEmptyString(imgStr)) {
        cell.coverImgView.image = [UIImage imageNamed:@"task_details_loading"];
    }else{
        [cell.coverImgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"task_details_loading"]];
    }
    cell.coverImgView.tag = indexPath.row;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkJobPicturesAction:)];
    [cell.coverImgView addGestureRecognizer:tap];
    
    return cell;
}

#pragma mark 水平排放(变成一排展示)
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(227, 340);
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

#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index =(NSInteger)(scrollView.contentOffset.x/227.0+0.5);
    self.pageControl.currentPage = index;
}

#pragma mark  SDPhotoBrowserDelegate
#pragma mark 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[self collectionView:self.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.coverImgView.image;
}

#pragma mark
-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *imgUrl = self.photosArray[index];
    return [NSURL URLWithString:imgUrl];
}

#pragma mark 查看作业大图
-(void)checkJobPicturesAction:(UITapGestureRecognizer *)gusture{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = gusture.view.tag;
    photoBrowser.imageCount = self.photosArray.count;
    photoBrowser.sourceImagesContainerView = self.photoCollectionView;
    [photoBrowser show];
}

#pragma mark
-(void)setPhotosArray:(NSMutableArray *)photosArray{
    _photosArray = photosArray;
    if (!_photosArray) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    self.pageControl.hidden = photosArray.count<2;
    self.pageControl.numberOfPages =photosArray.count;
    [self.photoCollectionView reloadData];
    [self.photoCollectionView layoutIfNeeded];
}

@end
