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
        iconsArr =IS_IPAD?@[@"red_ipad",@"black_ipad",@"blue_ipad"]:@[@"red",@"black",@"blue"];
        
        NSArray *images =IS_IPAD?@[@"red_ipad",@"coach_revoke_ipad",@"coach_delete_ipad",@"previous_page_ipad",@"next_page_ipad"]:@[@"red",@"coach_revoke",@"coach_delete",@"previous_page",@"next_page"];
        NSArray *titles = @[@"画笔",@"撤销",@"清除",@"上一页",@"下一页"];
        CGFloat kBtnCap =IS_IPAD?(kScreenWidth-220-titles.count*75)/6.0:(kScreenWidth-100-titles.count*40)/6.0;
        for (NSInteger i=0; i<titles.count; i++) {
            UIImage *image = IS_IPAD?[UIImage imageNamed:images[i]]:[UIImage drawImageWithName:images[i] size:CGSizeMake(20, 20)];
            UIButton *btn = [UIButton createCustomButtonWithFrame:IS_IPAD?CGRectMake(kBtnCap+i*(55+kBtnCap), 20, 55, 55):CGRectMake(kBtnCap+i*(40+kBtnCap), 8, 40, 40) Image:image title:titles[i] btnFont:IS_IPAD?16:13];
            btn.tag=i;
            [btn addTarget:self action:@selector(toolBarClickActionForItem:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                colorBtn = btn;
            }
            [self addSubview:btn];
        }
        
        UIButton *endBtn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-160, 16, 138, 48):CGRectMake(kScreenWidth-90, 6,75, 38)];
        [endBtn setImage:[UIImage imageNamed:IS_IPAD?@"coach_finish_button_ipad":@"coach_finish_button"] forState:UIControlStateNormal];
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
