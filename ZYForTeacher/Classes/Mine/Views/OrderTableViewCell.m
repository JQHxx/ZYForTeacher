//
//  OrderTableViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell (){
    UILabel      *dateTimeLab;          //日期
    UILabel      *stateLab;             //状态
    UIImageView  *headImageView;        //头像
    UILabel      *nameLab;              //姓名
    UILabel      *gradeLab;             //年级/科目
    UILabel      *payLab;               //付款金额
    
    UIView       *lineView2;
}

@end

@implementation OrderTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        dateTimeLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(30, 15, 200, 30):CGRectMake(13, 9, 150, 20)];
        dateTimeLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?21: 14];
        dateTimeLab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        [self.contentView addSubview:dateTimeLab];
        
        stateLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-110,15, 80, 30):CGRectMake(kScreenWidth-100,9, 82, 20)];
        stateLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        stateLab.textColor = [UIColor colorWithHexString:@"#FF6161"];
        stateLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:stateLab];
        
        UIView *lineView = [[UIView alloc]initWithFrame:IS_IPAD?CGRectMake(24, dateTimeLab.bottom+14.0, kScreenWidth-12, 0.5): CGRectMake(12, dateTimeLab.bottom+9.0, kScreenWidth-12, 0.5)];
        lineView.backgroundColor  = [UIColor colorWithHexString:@"#D8D8D8"];
        [self.contentView addSubview:lineView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:IS_IPAD?CGRectMake(27,lineView.bottom+16.0, 80.0, 80.0):CGRectMake(18,lineView.bottom+9.0, 52.0, 52.0)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#FFE0D3"];
        bgView.boderRadius = IS_IPAD?40:26;
        [self.contentView addSubview:bgView];
        
        headImageView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(32, lineView.bottom+21, 70, 70): CGRectMake(21, lineView.bottom+12, 46, 46)];
        headImageView.boderRadius = IS_IPAD?35:23;
        [self.contentView addSubview:headImageView];
        
        nameLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(headImageView.right+25, lineView.bottom+28, 180, 30):CGRectMake(headImageView.right+16, lineView.bottom+16, 90, 20)];
        nameLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        nameLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [self.contentView addSubview:nameLab];
        
        gradeLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(headImageView.right+27, nameLab.bottom+2, 200, 26):CGRectMake(headImageView.right+16, nameLab.bottom, 90, 18)];
        gradeLab.font =  [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?19:12];
        gradeLab.textColor = [UIColor colorWithHexString:@"#808080"];
        [self.contentView addSubview:gradeLab];
        
        payLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-260, lineView.bottom+60, 235, 40):CGRectMake(kScreenWidth-160, lineView.bottom+37, 150, 20)];
        payLab.textColor = [UIColor colorWithHexString:@"#FF6161"];
        payLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?28:18];
        payLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:payLab];
        
        lineView2 = [[UIView alloc]initWithFrame:IS_IPAD?CGRectMake(24, bgView.bottom+17, kScreenWidth-12, 0.5):CGRectMake(12, bgView.bottom+10, kScreenWidth-12, 0.5)];
        lineView2.backgroundColor  = [UIColor colorWithHexString:@" #D8D8D8"];
        [self.contentView addSubview:lineView2];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-350, lineView2.bottom+19, 135, 43):CGRectMake(kScreenWidth-190, lineView2.bottom+8, 80, 25)];
        [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"#9B9B9B"] forState:UIControlStateNormal];
        self.cancelButton.layer.cornerRadius = 14;
        self.cancelButton.layer.borderColor = [UIColor colorWithHexString:@"#9B9B9B"].CGColor;
        self.cancelButton.layer.borderWidth = 1;
        self.cancelButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        [self.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.contentView addSubview:self.cancelButton];
        self.cancelButton.hidden = YES;
        
        self.checkButton = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-175, lineView2.bottom+19, 135, 43):CGRectMake(kScreenWidth-100, lineView2.bottom+8,80, 25)];
        self.checkButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?22:14];
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"button3"] forState:UIControlStateNormal];
        [self.checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.checkButton];
    }
    return self;
}

-(void)setMyOrder:(OrderModel *)myOrder{
    _myOrder = myOrder;
    
    dateTimeLab.text = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:myOrder.create_time format:@"yyyy-MM-dd HH:mm"];
    if ([myOrder.status integerValue]==0) {
        stateLab.text =!kIsEmptyObject(myOrder.label)&&[myOrder.label integerValue]==1?@"检查中":@"辅导中";
        stateLab.textColor = [UIColor colorWithHexString:@"#FF6161"];
        [self.checkButton setTitle:[myOrder.label integerValue]>1?@"继续辅导":@"继续检查" forState:UIControlStateNormal];
    }else if ([myOrder.status integerValue]==1) {
        stateLab.text = @"待付款";
        stateLab.textColor = [UIColor colorWithHexString:@"#FF6161"];
    }else if ([myOrder.status integerValue]==2){
        stateLab.text = @"已完成";
        stateLab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    }else{
        stateLab.text = @"已取消";
        stateLab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    }
    if (!kIsEmptyString(myOrder.trait)) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:myOrder.trait] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
    }else{
        headImageView.image = [UIImage imageNamed:@"default_head_image"];
    }
    
    nameLab.text = myOrder.username;
    gradeLab.text = kIsEmptyString(myOrder.grade)||kIsEmptyString(myOrder.subject)?@"":[NSString stringWithFormat:@"%@/%@",myOrder.grade,myOrder.subject];
    
    self.checkButton.hidden = [myOrder.status integerValue]>0;
    lineView2.hidden = [myOrder.status integerValue]>0;
    self.cancelButton.hidden = [myOrder.status integerValue]>0;
    
    if ([myOrder.status integerValue]==0||[myOrder.status integerValue]==3) {
        payLab.hidden = YES;
    }else{
        payLab.hidden = NO;
        NSString *payStr = [NSString stringWithFormat:@"%@：¥%.2f",[myOrder.status integerValue]==1?@"待付金额":@"已付金额",[myOrder.price doubleValue]];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:payStr];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4A4A4A"] range:NSMakeRange(0, 5)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?20:13] range:NSMakeRange(0, 5)];
        payLab.attributedText = attributeStr;
    }
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
