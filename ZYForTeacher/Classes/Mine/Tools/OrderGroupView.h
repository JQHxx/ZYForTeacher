//
//  OrderGroupView.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderGroupView;
@protocol OrderGroupViewDelegate<NSObject>

-(void)orderGroupView:(OrderGroupView *)orderGroupView didSelectItemWithIndex:(NSInteger)index;

@end

@interface OrderGroupView : UIView

@property (nonatomic ,weak )id<OrderGroupViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
