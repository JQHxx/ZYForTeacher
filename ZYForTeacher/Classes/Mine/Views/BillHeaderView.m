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
        
        UILabel  *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(20, 13, 80, 22)];
        titleLabel.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        titleLabel.text = @"明细";
        [self addSubview:titleLabel];
        
        NSArray *titles = @[@"筛选",@"时间"];
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-122+61*i, 9, 43.8, 30)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
            [btn setImage:[UIImage drawImageWithName:@"arrow_down" size:CGSizeMake(8.8, 6)] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(4, -11.8, 4,11.8);
            btn.tag = i;
            [btn addTarget:self action:@selector(filterWithTypeOrTimeAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,45.5, kScreenWidth, 0.5)];
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
