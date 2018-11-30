//
//  BillHeaderView.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/19.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillHeaderView;
@protocol BillHeaderViewDelegate<NSObject>

-(void)billHeaderView:(BillHeaderView *)headerView didFilterForTag:(NSInteger)tag;


@end

@interface BillHeaderView : UIView

@property (nonatomic ,weak ) id<BillHeaderViewDelegate>delegate;


@end
