//
//  UserAgreementView.h
//  ZuoYe
//
//  Created by vision on 2018/8/9.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCallBack)();

@interface UserAgreementView : UIView

-(instancetype)initWithFrame:(CGRect)frame string:(NSString *)tempStr;

@property (nonatomic ,copy )clickCallBack clickAction;

@end
