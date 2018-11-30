//
//  WhiteboardPoint.h
//  ZuoYe
//
//  Created by vision on 2018/10/12.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WhiteboardPointType){
    WhiteboardPointTypeStart    = 1,
    WhiteboardPointTypeMove     = 2,
    WhiteboardPointTypeEnd      = 3,
};

@interface WhiteboardPoint : NSObject

//点类型
@property(nonatomic, assign) WhiteboardPointType type;

//x 轴比例
@property(nonatomic, assign) float xScale;
//y 轴比例
@property(nonatomic, assign) float yScale;
//颜色
@property(nonatomic, assign) NSInteger colorRGB;
//线宽度
@property(nonatomic, assign) CGFloat lineWidth;

@end
