//
//  CardTableViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/6.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CardTableViewCell.h"

@interface CardTableViewCell (){
    UIImageView    *cardImageView;
    UILabel        *bankLabel;
    UILabel        *numberLabel;
}

@end

@implementation CardTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
    }
    return self;
}

-(void)setBankModel:(BankModel *)bankModel{
    cardImageView.image = [UIImage imageNamed:bankModel.cardImage];
    bankLabel.text = bankModel.bankName;
    
    NSString *numStr = bankModel.bankNum;
    numStr = [numStr substringFromIndex:numStr.length-4];
    numberLabel.text = [NSString stringWithFormat:@"尾号%@",numStr];
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
