//
//  LoginTextView.h
//  ZuoYe
//
//  Created by vision on 2018/9/10.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTextView : UIView

@property (nonatomic ,strong) UITextField *myText;

-(instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder icon:(NSString *)icon isNumber:(BOOL)isNumber;


@end
