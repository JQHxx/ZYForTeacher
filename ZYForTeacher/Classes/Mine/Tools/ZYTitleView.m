//
//  ZYTitleView.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ZYTitleView.h"


@interface ZYTitleView (){
    UIButton       *selectBtn;
    UILabel        *line_lab;
    
    CGFloat        viewHeight;
    CGFloat        btnWidth;
}

@end

@implementation ZYTitleView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self=[super initWithFrame:frame];
    if (self) {
        viewHeight=frame.size.height;
        btnWidth = frame.size.width/titles.count;
        for (int i=0; i<titles.count; i++) {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectZero];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#FF6161"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
            btn.tag=100+i;
            btn.frame =CGRectMake(btnWidth*i, 0, btnWidth, viewHeight);
            [btn addTarget:self action:@selector(switchItemWithButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (i==0) {
                selectBtn=btn;
                selectBtn.selected=YES;
            }
        }
        
        line_lab=[[UILabel alloc] initWithFrame:CGRectMake(10,self.height - 3.0f, btnWidth-20.0, 3.0)];
        line_lab.backgroundColor = [UIColor colorWithHexString:@"#FF6161"];
        [self addSubview:line_lab];
        
    }
    return self;
}

-(void)switchItemWithButton:(UIButton *)btn{
    NSUInteger index=btn.tag-100;
    [UIView animateWithDuration:0.2 animations:^{
        selectBtn.selected=NO;
        btn.selected=YES;
        selectBtn=btn;
        line_lab.frame=CGRectMake(btnWidth*index+5,self.height - 3.0f, btnWidth-20, 3.0);
    }];
    if ([_delegate respondsToSelector:@selector(titleViewGroupActionWithIndex:)]) {
        [_delegate titleViewGroupActionWithIndex:index];
    }
}

@end
