//
//  LoginButton.m
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "LoginButton.h"

@implementation LoginButton

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius =20;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        
    }
    return self;
}

-(void)setClickable:(BOOL)clickable{
    if (clickable) {
        self.userInteractionEnabled =YES;
        self.backgroundColor = [UIColor redColor];
    }else{
        self.userInteractionEnabled =NO;
        self.backgroundColor = kRGBColor(240, 174, 151);
    }
}

@end
