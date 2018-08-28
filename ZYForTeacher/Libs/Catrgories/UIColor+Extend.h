//
//  UIColor+Extend.h
//  SRZCommonTool
//
//  Created by vision on 16/7/21.
//  Copyright © 2016年 SRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)

/**
 *  十六进制转颜色
 *
 *  @param color 颜色的十六进制数值
 *
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 *  十六进制转颜色
 *
 *  @param hexValue   颜色的十六进制值
 *  @param alphaValue 透明度
 *
 *  @return 颜色
 */
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue ;

/**
 *  灰色背景
 *
 *  @return 颜色
 */
+(UIColor *)bgColor_Gray;

@end
