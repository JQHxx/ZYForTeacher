//
//  WhiteboardDrawView.m
//  ZuoYe
//
//  Created by vision on 2018/10/12.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WhiteboardDrawView.h"
#import <QuartzCore/QuartzCore.h>
#import "NTESCADisplayLinkHolder.h"
#import "WhiteboardPoint.h"

@interface WhiteboardDrawView()<NTESCADisplayLinkHolderDelegate>

@property(nonatomic, strong)NTESCADisplayLinkHolder *displayLinkHolder;


@end

@implementation WhiteboardDrawView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.masksToBounds = YES;
        
        
        _displayLinkHolder = [[NTESCADisplayLinkHolder alloc] init];
        [_displayLinkHolder setFrameInterval:3];
        [_displayLinkHolder startCADisplayLinkWithDelegate:self];
    }
    return self;
}

-(void)dealloc
{
    [_displayLinkHolder stop];
}

+ (Class)layerClass{
    return [CAShapeLayer class];
}


- (void)onDisplayLinkFire:(NTESCADisplayLinkHolder *)holder duration:(NSTimeInterval)duration displayLink:(CADisplayLink *)displayLink{
    if (self.dataSource && [self.dataSource hasUpdate]) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
    NSDictionary *allLines = [self.dataSource allLinesToDraw];
    for (NSString *uid in allLines.allKeys) {
        NSArray *lines = [allLines objectForKey:uid];
        for (NSUInteger i = 0 ; i < lines.count; i ++) {
            UIBezierPath *path = [[UIBezierPath alloc] init];
            path.lineJoinStyle = kCGLineJoinRound;
            path.lineCapStyle = kCGLineCapRound;
            
            NSArray *line = [lines objectAtIndex:i];
            WhiteboardPoint *firstPoint = [line objectAtIndex:0];
            UIColor *lineColor = UIColorFromRGBA(firstPoint.colorRGB,1);
            path.lineWidth = firstPoint.lineWidth;
            for (NSUInteger j = 0 ; j < line.count; j ++) {
                WhiteboardPoint *point = [line objectAtIndex:j];
                CGPoint p = CGPointMake(point.xScale * self.frame.size.width , point.yScale * self.frame.size.height);
                if (j == 0) {
                    [path moveToPoint:p];
                    [path addLineToPoint:p];
                }else {
                    [path addLineToPoint:p];
                }
            }
            [lineColor setStroke];
            [path stroke];
        }
    }
}

@end
