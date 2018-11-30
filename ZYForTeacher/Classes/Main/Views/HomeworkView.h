//
//  HomeworkView.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/19.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkModel.h"

@class HomeworkView;
@protocol HomeworkViewDelegate<NSObject>

-(void)homeworkView:(HomeworkView *)aView loadCheckZuoyeForIsLoadNew:(BOOL)isLoadNew;

//检查作业
-(void)homeworkView:(HomeworkView *)aView didCheckZuoyeForHomework:(HomeworkModel *)homework;
//作业辅导接单
-(void)homeworkView:(HomeworkView *)aView didReceivedZuoyeForHomework:(HomeworkModel *)homework;
//作业辅导
-(void)homeworkView:(HomeworkView *)aView didTutoringZuoyeForHomework:(HomeworkModel *)homework;
//点击作业item 查看作业详情
-(void)checkZuoyeView:(HomeworkView *)aView didClickZuoyeItemForHomework:(HomeworkModel *)homework;

@end

@interface HomeworkView : UIView

@property (nonatomic ,strong) UICollectionView *myCollectionView;

@property (nonatomic , weak ) id<HomeworkViewDelegate>delegate;

@property (nonatomic , assign ) BOOL  isTutoring;
@property (nonatomic , strong ) NSMutableArray  *myZuoyeArray;   //作业检查
@property (nonatomic , strong ) NSMutableArray  *tutorialReceivedArray;   //作业辅导（已接单）
@property (nonatomic , strong ) NSMutableArray  *tutorialRealTimeArray;   //作业辅导（实时）
@property (nonatomic , strong ) NSMutableArray  *tutorialReserveArray;    //作业辅导（预约）

@end
