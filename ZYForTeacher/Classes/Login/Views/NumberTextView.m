//
//  NumberTextView.m
//  ZuoYe
//
//  Created by vision on 2018/8/8.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "NumberTextView.h"

@interface NumberTextView ()

@property (nonatomic ,strong) UIImageView *imgView;

@end


@implementation NumberTextView

-(instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder icon:(NSString *)icon{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,15, 20, 20)];
        self.imgView.image = [UIImage imageNamed:icon];
        [self addSubview:self.imgView];
        
        self.myText = [[UITextField alloc] initWithFrame:CGRectMake(self.imgView.right+10, 10, frame.size.width -self.imgView.right-20, 30)];
        self.myText.font = [UIFont systemFontOfSize:16.0];
        self.myText.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.myText.placeholder = placeholder;
        self.myText.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:self.myText];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,49,frame.size.width, 1)];
        lineLbl.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self addSubview:lineLbl];
    
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
    return self;
}

#pragma mark -- Event response
#pragma mark 完成编辑
-(void)confirmEdit{
    [self.myText resignFirstResponder];
}


@end
