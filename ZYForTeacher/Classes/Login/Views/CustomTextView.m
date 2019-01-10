//
//  CustomTextView.m
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CustomTextView.h"

@interface CustomTextView ()

@property (nonatomic ,strong) UIImageView *imgView;

@end

@implementation CustomTextView

-(instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder icon:(NSString *)icon isNumber:(BOOL)isNumber{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 21.0;
        self.backgroundColor = [UIColor colorWithHexString:@"#FFA8A8"];
        CGRect imgRect = IS_IPAD?CGRectMake(31, 12, 24, 32):CGRectMake(24, 9.0, 20, 24);
        self.imgView = [[UIImageView alloc] initWithFrame:imgRect];
        self.imgView.image = [UIImage imageNamed:icon];
        [self addSubview:self.imgView];
        
        CGRect textRect = IS_IPAD?CGRectMake(self.imgView.right+15, 13,frame.size.width -self.imgView.right-30, 30):CGRectMake(self.imgView.right+10, 10.0, frame.size.width -self.imgView.right-20, 22.0);
        CGFloat fontSize = IS_IPAD?22.0:16.0;
        self.myText = [[UITextField alloc] initWithFrame:textRect];
        self.myText.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:fontSize];
        
        NSMutableAttributedString *attributePlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [attributePlaceholder addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, placeholder.length)];
        [attributePlaceholder addAttribute:NSFontAttributeName value:[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:fontSize] range:NSMakeRange(0, placeholder.length)];
        self.myText.attributedPlaceholder = attributePlaceholder;
        self.myText.textColor = [UIColor whiteColor];
        [self addSubview:self.myText];
        
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
