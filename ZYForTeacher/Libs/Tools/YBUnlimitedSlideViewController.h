//
//  YBUnlimitedSlideViewController.h
//  YBExample
//
//  Created by laouhn on 15/11/14.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBUnlimitedSlideViewController;

@protocol  YBUnlimitedSlideViewControllerDelegate<NSObject>

@required

- (NSMutableArray *)dataSourceArray;

@optional
//返回ScrollerView的宽和高
- (CGSize)getScrollerViewForWidthAndHeight;


@end

@interface YBUnlimitedSlideViewController : UIViewController

@property (nonatomic, assign) id<YBUnlimitedSlideViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isPageControl;

//返回当前点的是第几张图片
- (NSInteger)backCurrentCilkPicture;

@end
