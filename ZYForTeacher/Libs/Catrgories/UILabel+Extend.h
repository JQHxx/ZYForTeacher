//
//  UILabel+Extend.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/26.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Extend)

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end

NS_ASSUME_NONNULL_END
