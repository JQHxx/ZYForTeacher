//
//  JobPicsView.m
//  ZuoYe
//
//  Created by vision on 2018/10/25.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "JobPicsView.h"
#import "SDPhotoBrowser.h"
#import "PicturesCollectionViewCell.h"
#import "PictureCollectionViewFlowLayout.h"

#define kItemW (kScreenWidth-45)/3.0

@interface JobPicsView ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>{
    NSMutableArray *photosArr;
}

@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation JobPicsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        photosArr = [[NSMutableArray alloc] init];
        [self setupPicturesCollectionView];
    }
    return self;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return photosArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PicturesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PicturesCollectionViewCell" forIndexPath:indexPath];

    NSString *imgUrl = photosArr[indexPath.row];
    cell.myImageView.tag = indexPath.row;
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"task_feedback_loading"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkJobPicAction:)];
    [cell.myImageView addGestureRecognizer:tap];
    
    return cell;
}

#pragma mark 水平排放(变成一排展示)
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kItemW, kItemW);
}

#pragma mark 选择图片
-(void)checkJobPicAction:(UITapGestureRecognizer *)sender{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = sender.view.tag;
    photoBrowser.imageCount = photosArr.count;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    [photoBrowser show];
}

#pragma mark  SDPhotoBrowserDelegate
#pragma mark 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    PicturesCollectionViewCell *cell = (PicturesCollectionViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.myImageView.image;
}

#pragma mark 
-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *imgUrl = photosArr[index];
    return [NSURL URLWithString:imgUrl];
}

#pragma mark -- Public Methods
-(void)updateCollectViewWithPhotosArr:(NSMutableArray *)arr{
    photosArr = arr;
    NSInteger allNum =photosArr.count;
    self.collectionView.frame =  CGRectMake(18,0, kScreenWidth, (kItemW+5)*(1+(allNum-1)/3)+10);
    [self.collectionView reloadData];
}


#pragma mark -- Private Methods
-(void)setupPicturesCollectionView{
    
    PictureCollectionViewFlowLayout *layout = [[PictureCollectionViewFlowLayout alloc] init];
   
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor  = [UIColor whiteColor];
    [self.collectionView registerClass:[PicturesCollectionViewCell class] forCellWithReuseIdentifier:@"PicturesCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        //        self.collectionView.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self addSubview:self.collectionView];
}

@end
