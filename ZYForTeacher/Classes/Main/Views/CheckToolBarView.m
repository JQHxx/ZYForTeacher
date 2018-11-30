//
//  CheckToolBarView.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/29.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CheckToolBarView.h"
#import "SketchpadView.h"
#import "UIButton+Extend.h"

@interface CheckToolBarView (){
    NSArray   *iconsArr;
    UIButton  *colorBtn;
    BOOL      isShowView;
}

@end

@implementation CheckToolBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        iconsArr = @[@"red",@"black",@"blue"];
        
        NSArray *images = @[@"red",@"coach_revoke",@"coach_delete",@"previous_page",@"next_page"];
        NSArray *titles = @[@"画笔",@"撤销",@"清除",@"上一页",@"下一页"];
        CGFloat kBtnCap = (kScreenWidth-100-titles.count*40)/6.0;
        for (NSInteger i=0; i<titles.count; i++) {
            UIImage *image = [UIImage imageNamed:images[i]];
            UIButton *btn = [UIButton createCustomButtonWithFrame:CGRectMake(kBtnCap+i*(40+kBtnCap), 8, 40, 40) Image:image title:titles[i]];
            btn.tag=i;
            [btn addTarget:self action:@selector(toolBarClickActionForItem:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                colorBtn = btn;
            }
            [self addSubview:btn];
        }
        
        UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-90, 6,75, 38)];
        [endBtn setImage:[UIImage imageNamed:@"coach_finish_button"] forState:UIControlStateNormal];
        [endBtn addTarget:self action:@selector(finishHomeworkCheckAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:endBtn];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 画笔、撤销、清除、上一页、下一页
-(void)toolBarClickActionForItem:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(checkToolBarView:didClickItemForTag:)]) {
        [self.delegate checkToolBarView:self didClickItemForTag:sender.tag];
    }
}

#pragma mark 结束检查
-(void)finishHomeworkCheckAction{
    if ([self.delegate respondsToSelector:@selector(checkToolBarViewDidFinishedCheck)]) {
        [self.delegate checkToolBarViewDidFinishedCheck];
    }
}

#pragma mark 设置颜色
-(void)setSelColorIndex:(NSInteger)selColorIndex{
    NSString *colorIcon = iconsArr[selColorIndex];
    [colorBtn setImage:[ UIImage imageNamed:colorIcon] forState:UIControlStateNormal];
}

@end
