//
//  TutorialToolBarView.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/9.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TutorialToolBarView;
@protocol TutorialToolBarViewDelegate<NSObject>

-(void)tutorialToolBarView:(TutorialToolBarView *)barView didClickItemForTag:(NSInteger)itemTag;

@end

@interface TutorialToolBarView : UIView

@property (nonatomic, weak ) id<TutorialToolBarViewDelegate>delegate;

@property (nonatomic,assign) NSInteger selColorIndex;

@end
