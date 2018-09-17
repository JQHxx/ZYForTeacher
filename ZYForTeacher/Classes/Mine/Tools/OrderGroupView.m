//
//  OrderGroupView.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "OrderGroupView.h"

@interface OrderGroupView (){
    UIButton   *selectBtn;
}


@end

@implementation OrderGroupView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat btnWith = frame.size.width/titles.count;
        
        for (int i=0; i<titles.count; i++) {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(i*btnWith, 0, btnWith, frame.size.height)];
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
    }
    return self;
}

#pragma mark 选择
-(void)changeItemForClickAction:(UIButton *)sender{
    selectBtn.selected=NO;
    sender.selected=YES;
    selectBtn=sender;
    
    if ([_delegate respondsToSelector:@selector(orderGroupView:didSelectItemWithIndex:)]) {
        [_delegate orderGroupView:self didSelectItemWithIndex:sender.tag-100];
    }
}

@end
