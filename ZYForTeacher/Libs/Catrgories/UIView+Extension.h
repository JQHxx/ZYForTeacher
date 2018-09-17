//
//  UIView+Extension.h
//  CameraDemo
//
//  Created by yml_hubery on 2017/6/10.
//  Copyright © 2017年 yh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BoderRadiusTypeAll,
    BoderRadiusTypeTop,
    BoderRadiusTypeBottom,
    BoderRadiusTypeLeft,
    BoderRadiusTypeRight,
} BoderRadiusType;

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat boderRadius;  //圆角
@property (nonatomic, assign) CGFloat topBoderRadius;  //顶部圆角
@property (nonatomic, assign) CGFloat rightBoderRadius;  //右侧圆角

-(void)drawBorderRadisuWithType:(BoderRadiusType)type boderRadius:(CGFloat)boderRadius;


@end
