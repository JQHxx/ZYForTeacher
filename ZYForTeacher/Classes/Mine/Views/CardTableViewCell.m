//
//  CardTableViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/6.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CardTableViewCell.h"

@interface CardTableViewCell (){
    UIImageView    *bgImgView;
    UIImageView    *cardImageView;
    UILabel        *bankLabel;
    UILabel        *numberLabel;
}

@end

@implementation CardTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor bgColor_Gray];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 85)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        bgImgView = [[UIImageView alloc] initWithFrame:bgView.bounds];
        bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:bgImgView];
        
        cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 26, 26)];
        [bgView addSubview:cardImageView];
        
        bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardImageView.right+10, 15, 120, 28)];
        bankLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:20];
        bankLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:bankLabel];
        
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardImageView.right+10, bankLabel.bottom+2, 220, 28)];
        numberLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:20];
        numberLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:numberLabel];
    }
    return self;
}

-(void)setBankModel:(BankModel *)bankModel{
    
    bgImgView.image = [UIImage imageNamed:bankModel.cardBgImage];
    cardImageView.image = [UIImage imageNamed:bankModel.cardImage];
    
    if ([bankModel.cardImage isEqualToString:@"bank"]) {
        cardImageView.frame = CGRectMake(14, 19, 28.5, 20);
        bankLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        numberLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    }else{
        cardImageView.frame = CGRectMake(16, 15, 26, 26);
        bankLabel.textColor = [UIColor whiteColor];
        numberLabel.textColor = [UIColor whiteColor];
    }
    
    bankLabel.text = kIsEmptyString(bankModel.bankName)||[bankModel.bankName isEqualToString:@"(null)"]?@"":bankModel.bankName;
    
    NSString *numStr = bankModel.bankNum;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
