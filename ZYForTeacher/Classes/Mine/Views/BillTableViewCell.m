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
        billImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self.contentView addSubview:billImageView];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(billImageView.right+10, 10, 100, 25)];
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.font = kFontWithSize(14);
        [self.contentView addSubview:typeLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(billImageView.right+10, typeLabel.bottom, 110, 30)];
        timeLabel.font = kFontWithSize(12);
        timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:timeLabel];
        
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 20, 110, 30)];
        amountLabel.textAlignment = NSTextAlignmentRight;
        amountLabel.font = kFontWithSize(14);
        [self.contentView addSubview:amountLabel];
    }
    return self;
}

-(void)setMyBill:(BillModel *)myBill{
    billImageView.image = [UIImage imageNamed:@"ic_m_head"];
    
    NSString *tempStr = nil;
    if (myBill.bill_type==0) {
        typeLabel.text = @"提现";
        amountLabel.textColor = [UIColor greenColor];
        tempStr = @"-";
    }else if (myBill.bill_type==1){
        typeLabel.text = @"作业检查";
        amountLabel.textColor = [UIColor redColor];
        tempStr = @"+";
    }else{
        typeLabel.text = @"作业辅导";
        amountLabel.textColor = [UIColor redColor];
        tempStr = @"+";
    }
    
    timeLabel.text = myBill.create_time;
    amountLabel.text = [tempStr stringByAppendingString:[NSString stringWithFormat:@"¥%.2f",myBill.amount]];
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
