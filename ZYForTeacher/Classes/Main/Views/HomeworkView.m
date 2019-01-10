//
//  HomeworkView.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/19.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "HomeworkView.h"
#import "ZuoyeCollectionViewCell.h"
#import "MJRefresh.h"


static NSString *sectionHeaderID =@"sechederview";

@interface HomeworkView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionViewFlowLayout *flowLayout;
}

@end


@implementation HomeworkView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat rootW = (kScreenWidth-30)/2.0;
        CGFloat rootH = IS_IPAD?rootW+124: rootW+63;
        
        flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置UICollectionView为横向滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 每一行cell之间的间距
        flowLayout.minimumLineSpacing = 10;
        flowLayout.itemSize = CGSizeMake(rootW,rootH);
        flowLayout.sectionInset  = UIEdgeInsetsMake(0, 0, 20, 20);
        
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.myCollectionView.showsVerticalScrollIndicator =NO;
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.backgroundColor = [UIColor bgColor_Gray];
        [self.myCollectionView registerClass:[ZuoyeCollectionViewCell class] forCellWithReuseIdentifier:@"ZuoyeCollectionViewCell"];
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCheckHomeworkData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        self.myCollectionView.mj_header=header;
        header.hidden = YES;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCheckHomeworkData)];
        footer.automaticallyRefresh = NO;
        self.myCollectionView.mj_footer = footer;
        footer.hidden=YES;
        
        
        //注册分组头视图
        [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
        
        [self addSubview:self.myCollectionView];
        
    }
    return self;
}

#pragma mark UICollectionViewDataSource
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.isTutoring) {
        if (self.tutorialReceivedArray.count>0) {
            return 3;
        }else{
            return 2;
        }
    }else{
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isTutoring) { //作业辅导
        if (self.tutorialReceivedArray.count>0) {
            if (section==0) {
                return self.tutorialReceivedArray.count;
            }else if (section==1){
                return self.tutorialRealTimeArray.count;
            }else{
                return self.tutorialReserveArray.count;
            }
        }else{
            if (section==0){
                return self.tutorialRealTimeArray.count;
            }else{
                return self.tutorialReserveArray.count;
            }
        }
    }else{   //作业检查
        return self.myZuoyeArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZuoyeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZuoyeCollectionViewCell" forIndexPath:indexPath];
    if (!cell ) {
        cell = [[ZuoyeCollectionViewCell alloc] init];
    }
    HomeworkModel *model = nil;
    if (self.isTutoring) { //作业辅导
        NSInteger index = 0;
        if (self.tutorialReceivedArray.count>0) {
            if (indexPath.section==0) {
                model = self.tutorialReceivedArray[indexPath.item];
            }else if (indexPath.section==1){
                model = self.tutorialRealTimeArray[indexPath.item];
            }else{
                model = self.tutorialReserveArray[indexPath.item];
            }
            index = indexPath.section - 1;
        }else{
            if (indexPath.section==0&&self.tutorialRealTimeArray.count>0){
                model = self.tutorialRealTimeArray[indexPath.item];
            }else{
                if (self.tutorialReserveArray.count>0) {
                    model = self.tutorialReserveArray[indexPath.item];
                }
            }
            index = indexPath.section;
        }
        cell.tutriolButton.tag = indexPath.item;
        [cell.tutriolButton addTarget:self action:@selector(tutoringMyHomeworkAction:) forControlEvents:UIControlEventTouchUpInside];  //去辅导
        
        if (index>=0) {
            cell.acceptButton.tag = index*100+indexPath.item;
            [cell.acceptButton addTarget:self action:@selector(receiveMyHomeworkAction:) forControlEvents:UIControlEventTouchUpInside];  //接单
        }
    }else{   //作业检查
        if (self.myZuoyeArray.count>0) {
            model = self.myZuoyeArray[indexPath.item];
            cell.checkButton.tag = indexPath.item;
            [cell.checkButton addTarget:self action:@selector(checkMyHomeworkAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [cell configCellWithMyHomework:model];
    return cell;
}

#pragma mark 点击item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkModel *model = nil;
    if (self.isTutoring) { //作业辅导
        if (self.tutorialReceivedArray.count>0) {
            if (indexPath.section==0) {
                model = self.tutorialReceivedArray[indexPath.item];
            }else if (indexPath.section==1){
                model = self.tutorialRealTimeArray[indexPath.item];
            }else{
                model = self.tutorialReserveArray[indexPath.item];
            }
        }else{
            if (indexPath.section==0){
                model = self.tutorialRealTimeArray[indexPath.item];
            }else{
                model = self.tutorialReserveArray[indexPath.item];
            }
        }
    }else{   //作业检查
        model = self.myZuoyeArray[indexPath.item];
    }
    if ([self.delegate respondsToSelector:@selector(checkZuoyeView:didClickZuoyeItemForHomework:)]) {
        [self.delegate checkZuoyeView:self didClickZuoyeItemForHomework:model];
    }
}

#pragma mark 设置头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (self.isTutoring) {
        //如果是头视图
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
            //添加头视图的内容
            UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 22)];
            view.backgroundColor = [UIColor bgColor_Gray];
            
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, 4, 16)];
            colorView.backgroundColor = [UIColor colorWithHexString:@"#FF6161"];
            [view addSubview:colorView];
            
            UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(colorView.right+15, 0,100, 22)];
            titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
            titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            [view addSubview:titleLabel];
            
            NSString *titleStr = nil;
            if (self.tutorialReceivedArray.count>0) {
                if (indexPath.section==0) {
                    titleStr = @"已接单";
                }else if (indexPath.section==1){
                    titleStr = @"实时";
                }else{
                    titleStr = @"预约";
                }
            }else{
                if (indexPath.section==0){
                    titleStr = @"实时";
                }else{
                    titleStr = @"预约";
                }
            }
            titleLabel.text = titleStr;
            
            [header addSubview:view];
            return header;
        }
    }
    return nil;
}

#pragma mark -- Private Methods
#pragma mark 加载最新作业检查
-(void)loadNewCheckHomeworkData{
    if([self.delegate respondsToSelector:@selector(homeworkView:loadCheckZuoyeForIsLoadNew:)]){
        [self.delegate homeworkView:self loadCheckZuoyeForIsLoadNew:YES];
    }
}

#pragma mark 加载更多作业检查
-(void)loadMoreCheckHomeworkData{
    if([self.delegate respondsToSelector:@selector(homeworkView:loadCheckZuoyeForIsLoadNew:)]){
        [self.delegate homeworkView:self loadCheckZuoyeForIsLoadNew:NO];
    }
}

#pragma mark -- Event Response
#pragma mark 检查作业
-(void)checkMyHomeworkAction:(UIButton *)sender{
    MyLog(@"check--tag:%ld",sender.tag);
    
    HomeworkModel *model = self.myZuoyeArray[sender.tag];
    if ([self.delegate respondsToSelector:@selector(homeworkView:didCheckZuoyeForHomework:)]) {
        [self.delegate homeworkView:self didCheckZuoyeForHomework:model];
    }
}

#pragma mark 作业辅导接单
-(void)receiveMyHomeworkAction:(UIButton *)sender{
    MyLog(@"receive--tag:%ld",sender.tag);
    
    NSInteger section = sender.tag/100;
    HomeworkModel *model = nil;
    if (section==0) {
        model = self.tutorialRealTimeArray[sender.tag%100];
    }else{
        model = self.tutorialReserveArray[sender.tag%100];
    }
    if ([self.delegate respondsToSelector:@selector(homeworkView:didReceivedZuoyeForHomework:)]) {
        [self.delegate homeworkView:self didReceivedZuoyeForHomework:model];
    }
}

#pragma mark 去辅导作业
-(void)tutoringMyHomeworkAction:(UIButton *)sender{
     MyLog(@"tutoring--tag:%ld",sender.tag);

    HomeworkModel *model = self.tutorialReceivedArray[sender.tag];
    if ([self.delegate respondsToSelector:@selector(homeworkView:didTutoringZuoyeForHomework:)]) {
        [self.delegate homeworkView:self didTutoringZuoyeForHomework:model];
    }
}

#pragma mark --  Setters
-(void)setIsTutoring:(BOOL)isTutoring{
    _isTutoring = isTutoring;
    flowLayout.headerReferenceSize = isTutoring?CGSizeMake(self.width,22):CGSizeZero;  //设置collectionView头视图的大小
    self.myCollectionView.mj_header.hidden = isTutoring;
}

//作业检查
-(void)setMyZuoyeArray:(NSMutableArray *)myZuoyeArray{
    _myZuoyeArray = myZuoyeArray;
    if (!_myZuoyeArray) {
        _myZuoyeArray = [[NSMutableArray alloc] init];
    }
}

//作业辅导
//已接单
-(void)setTutorialReceivedArray:(NSMutableArray *)tutorialReceivedArray{
    _tutorialReceivedArray = tutorialReceivedArray;
    if (!_tutorialReceivedArray) {
        _tutorialReceivedArray = [[NSMutableArray alloc] init];
    }
}

//实时未接单
-(void)setTutorialRealTimeArray:(NSMutableArray *)tutorialRealTimeArray{
    _tutorialRealTimeArray = tutorialRealTimeArray;
    if (!_tutorialRealTimeArray) {
        _tutorialRealTimeArray = [[NSMutableArray alloc] init];
    }
}

//实时已接单
-(void)setTutorialReserveArray:(NSMutableArray *)tutorialReserveArray{
    _tutorialReserveArray = tutorialReserveArray;
    if (!_tutorialReserveArray) {
        _tutorialReserveArray = [[NSMutableArray alloc] init];
    }
}

@end
