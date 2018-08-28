//
//  LoginButton.h
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginButton : UIButton

@property (nonatomic , assign) BOOL clickable;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;


@end
