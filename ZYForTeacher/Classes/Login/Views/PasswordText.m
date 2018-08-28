//
//  PasswordText.m
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "PasswordText.h"

@implementation PasswordText

-(instancetype)initWithFrame:(CGRect)frame icon:(NSString *)iconName{
    self = [super initWithFrame:frame];
    if (self) {
        self.returnKeyType=UIReturnKeyDone;
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.font = [UIFont systemFontOfSize:16];
        self.secureTextEntry = YES;
        
        UIImageView *phoneImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,15, 20, 20)];
        phoneImg.image = [UIImage imageNamed:iconName];
        [self addSubview:phoneImg];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 50,frame.size.width, 1)];
        lineLbl.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self addSubview:lineLbl];
    }
    return self;
}

@end
