//
//  ZYCustomPageControl.h
//  ZuoYe
//
//  Created by vision on 2018/9/15.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCustomPageControl : UIPageControl

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *inactiveImage;

@property (nonatomic, assign) CGSize currentImageSize;
@property (nonatomic, assign) CGSize inactiveImageSize;


@end
