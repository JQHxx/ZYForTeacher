//
//  BillHeaderView.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/19.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BillHeaderView.h"

@implementation BillHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel  *titleLabel =[[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(31, 20, 60, 36):CGRectMake(20, 13, 80, 22)];
        titleLabel.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        titleLabel.text = @"明细";
        [self addSubview:titleLabel];
        
        NSArray *titles = @[@"筛选",@"时间"];
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-200+90*i, 18, 80, 36):CGRectMake(kScreenWidth-122+61*i, 9, 43.8, 30)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
            [btn setImage:IS_IPAD?[UIImage drawImageWithName:@"arrow_down_ipad" size:CGSizeMake(14, 9)]:[UIImage drawImageWithName:@"arrow_down" size:CGSizeMake(8.8, 6)] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
            btn.imageEdgeInsets =IS_IPAD?UIEdgeInsetsMake(0, 60, 0, 0):UIEdgeInsetsMake(0, 35, 0, 0);
            btn.titleEdgeInsets = IS_IPAD?UIEdgeInsetsMake(6, -20, 6, 20): UIEdgeInsetsMake(4, -11.8, 4,11.8);
            btn.tag = i;
            [btn addTarget:self action:@selector(filterWithTypeOrTimeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(0, 71.5, kScreenWidth, 0.5): CGRectMake(0,45.5, kScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self addSubview:lineView];
    }
    return self;
}

#pragma mark 筛选或时间
-(void)filterWithTypeOrTimeAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(billHeaderView:didFilterForTag:)]) {
        [self.delegate billHeaderView:self didFilterForTag:sender.tag];
    }
}

@end
