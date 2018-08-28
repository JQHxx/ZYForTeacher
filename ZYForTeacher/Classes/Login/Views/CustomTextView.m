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
        [self addSubview:self.myText];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,49,frame.size.width, 1)];
        lineLbl.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self addSubview:lineLbl];
    }
    return self;
}

@end
