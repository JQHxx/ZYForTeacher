//
//  TutorialToolBarView.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/9.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "TutorialToolBarView.h"
#import "UIButton+Extend.h"

#define kViewWidth 224.0

@interface TutorialToolBarView (){
    NSArray   *iconsArr;
    UIButton  *colorBtn;
    BOOL      isShowView;
}

@end

@implementation TutorialToolBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        iconsArr = @[@"red",@"black",@"blue"];
        
        NSArray *images = @[@"red",@"coach_whiteboard",@"coach_delete",@"coach_revoke"];
        NSArray *titles = @[@"画笔",@"白板",@"清除",@"撤销"];
        CGFloat kBtnCap = (kViewWidth-titles.count*40)/4.0;
        for (NSInteger i=0; i<titles.count; i++) {
            UIImage *image = [UIImage imageNamed:images[i]];
            UIButton *btn = [UIButton createCustomButtonWithFrame:CGRectMake(kBtnCap+i*(40+kBtnCap), 12, 40, 40) Image:image title:titles[i]];
            btn.tag=i;
            if (i==0) {
                colorBtn = btn;
            }
            [btn addTarget:self action:@selector(tutorialToolBarClickActionForItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
    }
    return self;
}

#pragma mark 辅导操作
-(void)tutorialToolBarClickActionForItem:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(tutorialToolBarView:didClickItemForTag:)]) {
        [self.delegate tutorialToolBarView:self didClickItemForTag:sender.tag];
    }
}

#pragma mark 设置颜色
-(void)setSelColorIndex:(NSInteger)selColorIndex{
    NSString *colorIcon = iconsArr[selColorIndex];
    [colorBtn setImage:[ UIImage imageNamed:colorIcon] forState:UIControlStateNormal];
}

@end
