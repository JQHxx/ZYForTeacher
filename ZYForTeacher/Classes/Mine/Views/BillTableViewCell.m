//
//  BillTableViewCell.m
//  ZuoYe
//
//  Created by vision on 2018/8/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BillTableViewCell.h"

@interface BillTableViewCell (){
    UIImageView    *billImageView;
    UILabel        *typeLabel;        //交易类型
    UILabel        *timeLabel;        //创建时间
    UILabel        *amountLabel;      //金额
}



@end

@implementation BillTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        billImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(26, 26, 52, 52):CGRectMake(17, 17, 34, 34)];
        [self.contentView addSubview:billImageView];
        
        typeLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(billImageView.right+20, 20, 150, 32):CGRectMake(billImageView.right+13, 13, 100, 21)];
        typeLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        typeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?23:15];
        [self.contentView addSubview:typeLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(billImageView.right+23,typeLabel.bottom+3, 180, 28):CGRectMake(billImageView.right+15, typeLabel.bottom, 110, 20)];
        timeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?20:13];
        timeLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        [self.contentView addSubview:timeLabel];
        
        amountLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-180, 32, 140, 40):CGRectMake(kScreenWidth-128, 21, 110, 25)];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?28:18];
        [self.contentView addSubview:amountLabel];
    }
    return self;
}

-(void)setMyBill:(BillModel *)myBill{
    NSString *tempStr = nil;
    if ([myBill.label integerValue]==1) {
        billImageView.image = [UIImage imageNamed:@"bill_inspect"];
        typeLabel.text = @"作业检查";
        amountLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
        tempStr = @"+";
    }else if ([myBill.label integerValue]==2){
        billImageView.image = [UIImage imageNamed:@"bill_coach"];
        typeLabel.text = @"作业辅导";
        amountLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
        tempStr = @"+";
    }else{
        billImageView.image = [UIImage imageNamed:@"bill_recharge"];
        typeLabel.text = @"提现";
        amountLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        tempStr = @"-";
    }
    
    timeLabel.text = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:myBill.income_time format:@"MM月dd日 HH:mm"];
    amountLabel.text = [tempStr stringByAppendingString:[NSString stringWithFormat:@"¥%.2f",[myBill.income doubleValue]]];
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
