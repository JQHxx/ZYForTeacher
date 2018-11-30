//
//  SketchpadView.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/27.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "SketchpadView.h"

#define kBtnWidth  26

@interface SketchpadView ()

@end

@implementation SketchpadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0,80+kBtnWidth*3,kBtnWidth+14)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.boderRadius =4;
        [self addSubview:bgView];
        //画笔颜色
        NSArray *iconsArr = @[@"red",@"black",@"blue"];
        for (NSInteger i=0; i<iconsArr.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+i*(20+kBtnWidth),7, kBtnWidth, kBtnWidth)];
            [btn setImage:[UIImage imageNamed:iconsArr[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(setPenColorAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [bgView addSubview:btn];
        }
    }
    return self;
}

#pragma mark 选择颜色
- (void)setPenColorAction:(UIButton *)sender{
    self.setColor(sender.tag);
}



@end
