//
//  ZYTitleView.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYTitleViewDelegate <NSObject>

-(void)titleViewGroupActionWithIndex:(NSUInteger)index;

@end

@interface ZYTitleView : UIView

@property (nonatomic ,weak) id<ZYTitleViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
