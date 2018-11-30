//
//  NonBankCardView.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/19.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "NonBankCardView.h"

@implementation NonBankCardView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        bgImgView.image = [UIImage imageNamed:@"add_card_background"];
        bgImgView.userInteractionEnabled = YES;
        [self addSubview:bgImgView];
        
        
        UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-130)/2.0, 26, 30, 30)];
        cardImageView.image = [UIImage imageNamed:@"add_card"];
        [self addSubview:cardImageView];
        
        UILabel  *bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardImageView.right+10, 29, 90, 25)];
        bankLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:18];
        bankLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        bankLabel.text = @"添加银行卡";
        [self addSubview:bankLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
        [btn addTarget:self action:@selector(addBankCardAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)addBankCardAction{
    self.clickAction();
}

@end
