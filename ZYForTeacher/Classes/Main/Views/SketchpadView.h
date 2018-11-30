//
//  SketchpadView.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/27.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^setColorIndex)(NSInteger index);

@interface SketchpadView : UIView

@property (nonatomic,assign) NSInteger currentIndex; //0黑色 1红色 2蓝色

@property (nonatomic, copy ) setColorIndex setColor;

@end

NS_ASSUME_NONNULL_END
