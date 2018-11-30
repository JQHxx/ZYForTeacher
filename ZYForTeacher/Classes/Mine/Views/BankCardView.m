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
        [self addSubview:bgImgView];
        
        cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 26, 26)];
        [self addSubview:cardImageView];
        
        bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardImageView.right+10, 15, 120, 28)];
        bankLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:20];
        bankLabel.textColor = [UIColor whiteColor];
        [self addSubview:bankLabel];
        
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardImageView.right+10, bankLabel.bottom+2, 200, 28)];
        numberLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:20];
        numberLabel.textColor = [UIColor whiteColor];
        [self addSubview:numberLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 35, 8,15)];
        arrowImageView.image = [UIImage drawImageWithName:@"arrow_personal_information" size:CGSizeMake(8, 15)];
        [self addSubview:arrowImageView];
        
    }
    return self;
}

-(void)setBank:(BankModel *)bank{
    bgImgView.image = [UIImage imageNamed:@"CMB2"];
    
    cardImageView.image = [UIImage imageNamed:bank.cardImage];
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
