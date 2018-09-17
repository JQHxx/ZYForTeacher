//
//  ItemGroupView.m
//  ZuoYe
//
//  Created by vision on 2018/8/7.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ItemGroupView.h"

#define kBtnWidth 70

@interface ItemGroupView (){
    UIButton       *selectBtn;
    UILabel        *line_lab;
    
    CGFloat        kGapWidth;
    CGFloat        viewHeight;
}


@end

@implementation ItemGroupView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        viewHeight = frame.size.height;
        kGapWidth = (frame.size.width - titles.count*kBtnWidth)/2.0;
        
        for (int i=0; i<titles.count; i++) {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(kGapWidth+i*kBtnWidth, 0, kBtnWidth, viewHeight)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            btn.tag=100+i;
            [btn addTarget:self action:@selector(changeItemForClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            if (i==0) {
                selectBtn=btn;
                selectBtn.selected=YES;
            }
        }
        
        line_lab=[[UILabel alloc] initWithFrame:CGRectMake(kGapWidth+5.0,viewHeight-3, kBtnWidth-10.0, 2.0)];
        line_lab.backgroundColor = [UIColor redColor];
        [self addSubview:line_lab];
        
        
    }
    return self;
}

-(void)changeItemForClickAction:(UIButton *)sender{
    NSUInteger index=sender.tag-100;
    [UIView animateWithDuration:0.2 animations:^{
        selectBtn.selected=NO;
        sender.selected=YES;
        selectBtn=sender;
        line_lab.frame=CGRectMake(kGapWidth+index*kBtnWidth+5.0,viewHeight-3, kBtnWidth-10.0, 2.0);
    }];
    
    if ([_viewDelegate respondsToSelector:@selector(itemGroupView:didClickActionWithIndex:)]) {
        [_viewDelegate itemGroupView:self didClickActionWithIndex:sender.tag];
    }
}

-(void)changeItemForSwipMenuAction:(UIButton *)sender{
    NSUInteger index=sender.tag-100;
    [UIView animateWithDuration:0.2 animations:^{
        selectBtn.selected=NO;
        sender.selected=YES;
        selectBtn=sender;
        line_lab.frame=CGRectMake(kGapWidth+index*kBtnWidth+5.0,viewHeight-3, kBtnWidth-10.0, 2.0);
    }];
}

@end
