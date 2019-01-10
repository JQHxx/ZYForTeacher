//
//  BankCardView.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BankCardView.h"

@interface BankCardView (){
    UIImageView    *bgImgView;
    UIImageView    *cardImageView;
    UILabel        *bankLabel;
    UILabel        *numberLabel;
}

@end

@implementation BankCardView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        bgImgView.clipsToBounds = YES;
        bgImgView.boderRadius = 3.0;
        [self addSubview:bgImgView];
        
        
        cardImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(24, 23, 40, 40):CGRectMake(16, 15, 26, 26)];
        [self addSubview:cardImageView];
        
        
        bankLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(cardImageView.right+15, 24, 200, 42):CGRectMake(cardImageView.right+10, 15, 120, 28)];
        bankLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?30:20];
        bankLabel.textColor = [UIColor whiteColor];
        [self addSubview:bankLabel];
        
        
        numberLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(cardImageView.right+15, bankLabel.bottom+4,320, 42):CGRectMake(cardImageView.right+10, bankLabel.bottom+2, 220, 28)];
        numberLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?30:20];
        numberLabel.textColor = [UIColor whiteColor];
        [self addSubview:numberLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-60, 57.5, 12, 23):CGRectMake(kScreenWidth-40, 35, 8,15)];
        arrowImageView.image = [UIImage drawImageWithName:@"arrow_personal_information" size:IS_IPAD?CGSizeMake(10, 23):CGSizeMake(8, 15)];
        [self addSubview:arrowImageView];
        
    }
    return self;
}

-(void)setBank:(BankModel *)bank{
    bgImgView.image = [UIImage imageNamed:bank.cardBgImage];
    cardImageView.image = [UIImage imageNamed:bank.cardImage];
    
    if ([bank.cardImage isEqualToString:@"bank"]) {
        bankLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        numberLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    }else{
        bankLabel.textColor = [UIColor whiteColor];
        numberLabel.textColor = [UIColor whiteColor];
    }
    
    bankLabel.text = bank.bankName;
    NSString *numStr = bank.bankNum;
    NSString *tempStr = @"";
    for (NSInteger i=0; i<12; i++) {
        tempStr = [tempStr stringByAppendingString:@"*"];
        if ((i+1)%4==0) {
            tempStr = [tempStr stringByAppendingString:@" "];
        }
    }
    NSString *lastNumStr = [numStr substringFromIndex:numStr.length-4];
    numberLabel.text = [NSString stringWithFormat:@"%@%@",tempStr,lastNumStr];
}

@end
