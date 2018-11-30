//
//  NonBankCardView.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/19.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCallBack)();

@interface NonBankCardView : UIView

@property (nonatomic ,copy )clickCallBack clickAction;

@end
