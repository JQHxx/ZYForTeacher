//
//  UIButton+Extend.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "UIButton+Extend.h"

@implementation UIButton (Extend)

+(UIButton *)createCustomButtonWithFrame:(CGRect)aFrame Image:(UIImage *)aImage title:(NSString *)btnTitle btnFont:(CGFloat)size{
    UIButton *btn = [[UIButton alloc] initWithFrame:aFrame];
    [btn setImage:aImage forState:UIControlStateNormal];
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:size];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.imageEdgeInsets = UIEdgeInsetsMake(-(btn.height-btn.titleLabel.height-btn.titleLabel.y),(btn.width-btn.titleLabel.width-btn.imageView.width)/2.0, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(btn.height-btn.imageView.height-btn.imageView.y, -btn.imageView.width, 0, 0);
    return btn;
}

@end
