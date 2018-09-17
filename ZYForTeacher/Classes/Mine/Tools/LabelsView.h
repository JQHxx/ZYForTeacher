//
//  LabelsView.h
//  ZuoYe
//
//  Created by vision on 2018/8/16.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelsView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *labelsArray;

@property (nonatomic, strong) void (^viewHeightRecalc) (CGFloat height);
@property (nonatomic, strong) void (^didClickItem) (NSInteger itemIndex);

@end
