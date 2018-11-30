//
//  WhiteboardManagerView.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WhiteboardManagerView.h"
#import "UIButton+Extend.h"
#import "WhiteboardCollecetionViewFlowLayout.h"
#import "WhiteboardCollectionViewCell.h"

#define kBtnW 84.0
#define kBtnH 116.0

@interface WhiteboardManagerView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation WhiteboardManagerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 127)];
        bgImageView.image = [UIImage imageNamed:@"coach_whiteboard_background"];
        [self addSubview:bgImageView];
        
        WhiteboardCollecetionViewFlowLayout *layout = [[WhiteboardCollecetionViewFlowLayout alloc] init];
        
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBtnH) collectionViewLayout:layout];
        self.myCollectionView.backgroundColor  = [UIColor colorWithHexString:@"#E4E4E4"];
        [self.myCollectionView registerClass:[WhiteboardCollectionViewCell class] forCellWithReuseIdentifier:@"WhiteboardCollectionViewCell"];
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:self.myCollectionView];
        
    }
    return self;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.whiteboardsArray.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WhiteboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WhiteboardCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row==0) {
        cell.contentImage = [UIImage imageNamed:@"coach_whiteboard_add"];
        cell.titleStr = @"新建白板";
        cell.deleteBtn.hidden = YES;
    }else{
        cell.contentImage = self.whiteboardsArray[indexPath.row-1];
        cell.titleStr = [NSString stringWithFormat:@"白板%ld",indexPath.row];
        
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.tag = indexPath.row-1;
        [cell.deleteBtn addTarget:self action:@selector(deleteWhiteboardAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) { //新建白板
        if ([self.viewDelegate respondsToSelector:@selector(whiteboardManagerViewAddWhiteboard)]) {
            [self.viewDelegate whiteboardManagerViewAddWhiteboard];
        }
    }else{ //选择白板
        if ([self.viewDelegate respondsToSelector:@selector(whiteboardManagerView:didSelectWhiteboardWithIndex:)]) {
            [self.viewDelegate whiteboardManagerView:self didSelectWhiteboardWithIndex:indexPath.row-1];
        }
    }
}

#pragma mark 水平排放(变成一排展示)
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kBtnW, kBtnH);
}

#pragma mark -- Event Response
#pragma mark 删除白板
-(void)deleteWhiteboardAction:(UIButton *)sender{
    if (self.whiteboardsArray.count==1) {
        [kKeyWindow makeToast:@"必须保证至少有一个白板" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.viewDelegate respondsToSelector:@selector(whiteboardManagerView:deleteWhiteboardWithIndex:)]) {
        [self.viewDelegate whiteboardManagerView:self deleteWhiteboardWithIndex:sender.tag];
    }
}

-(void)setWhiteboardsArray:(NSMutableArray *)whiteboardsArray{
    _whiteboardsArray = whiteboardsArray;
}


@end
