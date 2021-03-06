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
//        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
//        bgImgView.contentMode = UIViewContentModeScaleAspectFit;
//        bgImgView.clipsToBounds = YES;
        bgImgView.image =IS_IPAD?[UIImage imageNamed:@"add_card_background_ipad"]:[UIImage imageNamed:@"add_card_background"];
        bgImgView.userInteractionEnabled = YES;
        [self addSubview:bgImgView];
        
        
        UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake((kScreenWidth-210)/2.0, 40, 50, 50):CGRectMake((kScreenWidth-130)/2.0, 26, 30, 30)];
        cardImageView.image =IS_IPAD?[UIImage imageNamed:@"add_card_ipad"]:[UIImage imageNamed:@"add_card"];
        [self addSubview:cardImageView];
        
        UILabel  *bankLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(cardImageView.right+10, 44, 150, 42):CGRectMake(cardImageView.right+10, 29, 90, 25)];
        bankLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?30:18];
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
