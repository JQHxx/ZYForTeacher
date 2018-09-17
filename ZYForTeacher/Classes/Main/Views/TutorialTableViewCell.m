//
//  TutorialTableViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/8/31.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "TutorialTableViewCell.h"

@interface TutorialTableViewCell (){
    UILabel        *orderTimeLabel;    //预约时间
    UILabel        *stateLabel;        //接单状态
    UILabel        *lineLabel;
    UIImageView    *headImageView;     //头像
    UILabel        *nameLabel;         //姓名
    UILabel        *gradeLabel;        //年级
    UIImageView    *photoImageView;    //作业截图
    UILabel        *priceLabel;        //价格
}

@end

@implementation TutorialTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        orderTimeLabel = [[UILabel alloc] init];
        orderTimeLabel.font = kFontWithSize(14);
        orderTimeLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:orderTimeLabel];
        
        stateLabel = [[UILabel alloc] init];
        stateLabel.font = kFontWithSize(14);
        stateLabel.textColor = [UIColor blackColor];
        stateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:stateLabel];
        
        lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        lineLabel.backgroundColor = kLineColor;
        [self.contentView addSubview:lineLabel];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:headImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = kFontWithSize(14);
        nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLabel];
        
        gradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        gradeLabel.textColor = [UIColor lightGrayColor];
        gradeLabel.font = kFontWithSize(13);
        [self.contentView addSubview:gradeLabel];
        
        photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        photoImageView.backgroundColor = [UIColor bgColor_Gray];
        [self.contentView addSubview:photoImageView];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = kFontWithSize(14);
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:priceLabel];
        
        self.cellButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [self.cellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cellButton.titleLabel.font = kFontWithSize(14);
        self.cellButton.layer.cornerRadius = 5.0;
        self.cellButton.clipsToBounds = YES;
        self.cellButton.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.cellButton];
    }
    return self;
}

-(void)cellDisplayWithModel:(OrderModel *)orderModel selIndex:(NSInteger)index{
    if (index==0) {   //作业检查
        orderTimeLabel.hidden = stateLabel.hidden = lineLabel.hidden = YES;
        headImageView.frame = CGRectMake(10, 15, 40, 40);
        priceLabel.text = [NSString stringWithFormat:@"¥%.2f",orderModel.check_price];
        self.cellButton.hidden = NO;
        [self.cellButton setTitle:@"去检查" forState:UIControlStateNormal];
    }else{ //作业辅导
        priceLabel.text = [NSString stringWithFormat:@"%.2f元/分钟",orderModel.perPrice];
        if (orderModel.state == 0) { //待接单
            stateLabel.hidden = YES;
            stateLabel.text = @"";
            self.cellButton.hidden = NO;
            [self.cellButton setTitle:@"接单" forState:UIControlStateNormal];
            if (orderModel.time_type == 0) { //实时
                orderTimeLabel.hidden = stateLabel.hidden = lineLabel.hidden = YES;
                headImageView.frame = CGRectMake(10, 15, 40, 40);
            }else{ //预约
                orderTimeLabel.hidden = lineLabel.hidden = NO;
                orderTimeLabel.frame = CGRectMake(10, 5, 120, 30);
                lineLabel.frame = CGRectMake(10, 40, kScreenWidth-20, 0.5);
                headImageView.frame = CGRectMake(10,40+15, 40, 40);
            }
        }else{ //已接单
            orderTimeLabel.hidden = lineLabel.hidden = NO;
            orderTimeLabel.frame = CGRectMake(10, 5, 120, 30);
            lineLabel.frame = CGRectMake(10, 40, kScreenWidth-20, 0.5);
            headImageView.frame = CGRectMake(10,40+15, 40, 40);
            stateLabel.hidden = NO;
            stateLabel.text = orderModel.received_state==0?@"等待去辅导":@"预约时间到";
            stateLabel.frame = CGRectMake(kScreenWidth-130, 5, 120, 30);
            self.cellButton.hidden = orderModel.received_state == 0;
            [self.cellButton setTitle:@"去辅导" forState:UIControlStateNormal];
        }
    }
    nameLabel.frame = CGRectMake(headImageView.right+10, headImageView.top-5, 80, 25);
    gradeLabel.frame = CGRectMake(headImageView.right+10, nameLabel.bottom, 80, 25);
    photoImageView.frame = CGRectMake(nameLabel.right, headImageView.top, 40, 40);
    priceLabel.frame = CGRectMake(kScreenWidth-120, headImageView.top-10, 110, 20);
    self.cellButton.frame = CGRectMake(kScreenWidth-100, priceLabel.bottom+5, 90, 30);
    
    orderTimeLabel.text = orderModel.order_time;
    headImageView.image = [UIImage imageNamed:orderModel.head_image];
    nameLabel.text = orderModel.name;
    gradeLabel.text = orderModel.grade;
    photoImageView.image = [UIImage imageNamed:orderModel.images[0]];
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
