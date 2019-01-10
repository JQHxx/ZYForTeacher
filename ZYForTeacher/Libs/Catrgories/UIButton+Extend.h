//
//  UIButton+Extend.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extend)

+(UIButton *)createCustomButtonWithFrame:(CGRect)aFrame Image:(UIImage *)aImage title:(NSString *)btnTitle btnFont:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
