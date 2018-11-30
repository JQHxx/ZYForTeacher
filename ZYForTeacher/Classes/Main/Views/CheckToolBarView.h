//
//  CheckToolBarView.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckToolBarView;
@protocol CheckToolBarViewDelegate<NSObject>

//撤销、清除、上一页、下一页
-(void)checkToolBarView:(CheckToolBarView *)barView didClickItemForTag:(NSInteger)tag;
//结束
-(void)checkToolBarViewDidFinishedCheck;

@end

@interface CheckToolBarView : UIView

@property (nonatomic , weak) id<CheckToolBarViewDelegate>delegate;

@property (nonatomic,assign) NSInteger selColorIndex;


@end
