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
        dateTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 180, 20)];
        dateTimeLab.font = kFontWithSize(14);
        dateTimeLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:dateTimeLab];
        
        stateLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90, 5, 70, 30)];
        stateLab.font = kFontWithSize(16);
        stateLab.textColor = [UIColor blackColor];
        stateLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:stateLab];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, dateTimeLab.bottom+10, kScreenWidth-10, 0.5)];
        lineView.backgroundColor  = kLineColor;
        [self.contentView addSubview:lineView];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, lineView.bottom+10, 50, 50)];
        [self.contentView addSubview:headImageView];
        
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right+10, lineView.bottom+10, 90, 30)];
        nameLab.font = kFontWithSize(14);
        nameLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLab];
        
        gradeLab = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right+10, nameLab.bottom, 90, 20)];
        gradeLab.font = kFontWithSize(13);
        gradeLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:gradeLab];
        
        lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, headImageView.bottom+10, kScreenWidth-10, 0.5)];
        lineView2.backgroundColor  = kLineColor;
        [self.contentView addSubview:lineView2];
        
        payLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-130, lineView2.bottom+10, 120, 20)];
        payLab.textColor = [UIColor blackColor];
        payLab.font = kFontWithSize(14);
        [self.contentView addSubview:payLab];
    }
    return self;
}

-(void)setMyOrder:(OrderModel *)myOrder{
    _myOrder = myOrder;
    
    dateTimeLab.text = myOrder.create_time;
    stateLab.text = [[ZYHelper sharedZYHelper] getStateStringWithIndex:myOrder.state];
    headImageView.image = [UIImage imageNamed:myOrder.head_image];
    nameLab.text = myOrder.name;
    gradeLab.text = [NSString stringWithFormat:@"%@/%@",myOrder.grade,myOrder.subject];
    
    NSString *payStr = [NSString stringWithFormat:@"%@：¥%.2f",myOrder.state==3?@"待付金额":@"已付金额",myOrder.payPrice];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:payStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, payStr.length-5)];
    payLab.attributedText = attributeStr;
    
    payLab.hidden = lineView2.hidden = myOrder.state==5;
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
