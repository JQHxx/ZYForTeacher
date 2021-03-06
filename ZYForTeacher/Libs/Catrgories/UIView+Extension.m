//
//  UIView+Extension.m
//  CameraDemo
//
//  Created by yml_hubery on 2017/6/10.
//  Copyright © 2017年 yh. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(void)setX:(CGFloat)x{
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setY:(CGFloat)y{
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)x{
    
    return self.frame.origin.x;
}

-(CGFloat)y{
    
    return self.frame.origin.y;
}

-(void)setCenterX:(CGFloat)centerX{
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerX{
    
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY{
    
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(CGFloat)centerY{
    
    return self.center.y;
}

-(void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)height{
    
    return self.frame.size.height;
}

-(CGFloat)width{
    
    return self.frame.size.width;
}

-(void)setSize:(CGSize)size{
    
    CGRect freme = self.frame;
    freme.size = size;
    self.frame = freme;
}

-(CGSize)size{
    
    return self.frame.size;
}

-(void)setOrigin:(CGPoint)origin{
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame   = frame;
}

-(CGPoint)origin{
    
    return self.frame.origin;
}

- (CGFloat) top{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

-(void)setBoderRadius:(CGFloat)boderRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft| UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight  cornerRadii:CGSizeMake(boderRadius, boderRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

-(void)drawBorderRadisuWithType:(BoderRadiusType)type boderRadius:(CGFloat)boderRadius{
    UIRectCorner corner;
    if (type == BoderRadiusTypeAll) {
        corner = UIRectCornerTopLeft| UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }else if (type == BoderRadiusTypeTop){
        corner = UIRectCornerTopLeft| UIRectCornerTopRight;
    }else if (type == BoderRadiusTypeLeft){
        corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    }else if (type == BoderRadiusTypeRight){
        corner = UIRectCornerTopRight | UIRectCornerBottomRight;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner  cornerRadii:CGSizeMake(boderRadius, boderRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


@end
