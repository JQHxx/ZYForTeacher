//
//  PhotosView.h
//  ZuoYe
//
//  Created by vision on 2018/8/15.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosView : UIView

-(instancetype)initWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor;

@property (nonatomic, strong) NSMutableArray      *photosArray;

@end
