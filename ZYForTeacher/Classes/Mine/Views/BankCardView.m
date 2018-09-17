//
//  BankCardView.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BankCardView.h"

@interface BankCardView (){
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
        
        cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 40)];
        [self addSubview:cardImageView];
        
        bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardImageView.right+10, 10, 120, 25)];
        bankLabel.font = kFontWithSize(14);
        bankLabel.textColor = [UIColor blackColor];
        [self addSubview:bankLabel];
        
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardImageView.right+10, bankLabel.bottom, 120, 25)];
        numberLabel.font =kFontWithSize(12);
        numberLabel.textColor = [UIColor blackColor];
        [self addSubview:numberLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 25, 20, 20)];
        arrowImageView.image = [UIImage drawImageWithName:@"箭头" size:CGSizeMake(20, 20)];
        [self addSubview:arrowImageView];
        
    }
    return self;
}

-(void)setBank:(BankModel *)bank{
    cardImageView.image = [UIImage imageNamed:bank.cardImage];
    bankLabel.text = bank.bankName;
    
    NSString *numStr = bank.bankNum;
    numStr = [numStr substringFromIndex:numStr.length-4];
    numberLabel.text = [NSString stringWithFormat:@"尾号%@",numStr];
}

@end
