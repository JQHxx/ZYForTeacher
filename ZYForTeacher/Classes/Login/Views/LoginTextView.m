//
//  LoginTextView.m
//  ZuoYe
//
//  Created by vision on 2018/9/10.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "LoginTextView.h"

@interface LoginTextView ()

@property (nonatomic ,strong) UIImageView *imgView;

@end

@implementation LoginTextView

-(instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder icon:(NSString *)icon isNumber:(BOOL)isNumber{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(30, 25, 28, 35):CGRectMake(20,14.0, 20, 24)];
        self.imgView.image = [UIImage imageNamed:icon];
        [self addSubview:self.imgView];
        
        self.myText = [[UITextField alloc] initWithFrame:IS_IPAD?CGRectMake(self.imgView.right+25, 26,frame.size.width-self.imgView.right-80, 33):CGRectMake(self.imgView.right+10, 15, frame.size.width -self.imgView.right-40, 22)];
        CGFloat fontSize= kScreenWidth<375.0?14:16;
        self.myText.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?24:fontSize];
        self.myText.placeholder = placeholder;
        self.myText.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [self addSubview:self.myText];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(0, self.myText.bottom+25.5, frame.size.width, 0.5):CGRectMake(0,self.myText.bottom+15.0,frame.size.width, 0.5)];
        lineLbl.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self addSubview:lineLbl];
        
        if (isNumber) {
            self.myText.keyboardType = UIKeyboardTypeNumberPad;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            view.backgroundColor = [UIColor bgColor_Gray];
            self.myText.inputAccessoryView = view;
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -50, 5, 40, 40)];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(confirmEdit) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 完成编辑
-(void)confirmEdit{
    [self.myText resignFirstResponder];
}

@end
