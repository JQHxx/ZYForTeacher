//
//  CustomTextView.h
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextView : UIView

-(instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder icon:(NSString *)icon;

@property (nonatomic ,strong) UITextField *myText;

@end
