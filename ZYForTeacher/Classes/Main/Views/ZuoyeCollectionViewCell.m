//
//  ZuoyeCollectionViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/18.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ZuoyeCollectionViewCell.h"
#import "NSDate+Extension.h"

@interface ZuoyeCollectionViewCell ()

@property (nonatomic, strong) UILabel     *orderTimeLabel;
@property (nonatomic, strong) UIImageView *zuoyeImgView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *priceLabel;
@property (nonatomic, strong) UILabel     *stateLabel;


@end

@implementation ZuoyeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat rootW = (kScreenWidth-30)/2.0;
        CGFloat rootH = IS_IPAD?rootW+124:rootW+63;
        UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, rootW, rootH)];
        rootView.backgroundColor = [UIColor whiteColor];
        rootView.layer.cornerRadius = 4.0;
        [self.contentView addSubview:rootView];
        
        self.zuoyeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, rootW, rootW)];
        self.zuoyeImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.zuoyeImgView.clipsToBounds = YES;
        [self.zuoyeImgView drawBorderRadisuWithType:BoderRadiusTypeTop boderRadius:4.0];
        [self.contentView addSubview:self.zuoyeImgView];
        
        CGRect timeRect = IS_IPAD?CGRectMake(rootW-70, 12, 70, 37):CGRectMake(rootW-65, 16, 65, 16);
        CGFloat timeFontSize = IS_IPAD?24.0:11.0;
        self.orderTimeLabel = [[UILabel alloc] initWithFrame:timeRect];
        self.orderTimeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:timeFontSize];
        self.orderTimeLabel.textColor = [UIColor whiteColor];
        self.orderTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.orderTimeLabel.backgroundColor = [UIColor blackColor];
        self.orderTimeLabel.alpha =0.4;
        self.orderTimeLabel.layer.cornerRadius = IS_IPAD?8.0:4.0;
        self.orderTimeLabel.clipsToBounds = YES;
        [self.contentView addSubview:self.orderTimeLabel];
        
        CGRect bgViewRect,headRect,nameRect,priceRect,btnRect;
        CGFloat fontSize,fontSize2,btnSize;
        if (IS_IPAD) {
            bgViewRect = CGRectMake(16,self.zuoyeImgView.bottom-46, 92.0, 92.0);
            headRect = CGRectMake(21, self.zuoyeImgView.bottom-41,82,82);
            nameRect = CGRectMake(headRect.origin.x+headRect.size.width+14, self.zuoyeImgView.bottom+6.0, rootW-headRect.origin.x-headRect.size.width-10, 33);
            priceRect = CGRectMake(20, headRect.origin.y+headRect.size.height+13, 180, 46);
            btnRect = CGRectMake(rootW-130, nameRect.origin.y+nameRect.size.height+17, 128, 42);
            fontSize = 24.0;
            fontSize2 = 33.0;
            btnSize = 24.0;
        }else{
            bgViewRect = kScreenWidth<375.0?CGRectMake(12,self.zuoyeImgView.bottom-20, 40.0, 40.0):CGRectMake(15.5,self.zuoyeImgView.bottom-22.5, 45.0, 45.0);
            headRect = kScreenWidth<375.0?CGRectMake(14.5, self.zuoyeImgView.bottom-17.5,  35,35):CGRectMake(18, self.zuoyeImgView.bottom-20,  40,40);
            nameRect = CGRectMake(headRect.origin.x+headRect.size.width+8, self.zuoyeImgView.bottom+2.0, rootW-headRect.origin.x-headRect.size.width-3, 20);
            priceRect = CGRectMake(15, headRect.origin.y+headRect.size.height+10, 90, 22);
            btnRect = kScreenWidth<375?CGRectMake(rootW-55, nameRect.origin.y+nameRect.size.height+8, 60,20):CGRectMake(rootW-70, nameRect.origin.y+nameRect.size.height+8, 70,24);
            fontSize = kScreenWidth<375?11.0:13.0;
            fontSize2 = kScreenWidth<375?14.0:16.0;
            btnSize = 12.0;
        }
        UIView *bgView = [[UIView alloc] initWithFrame:bgViewRect];
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView drawBorderRadisuWithType:BoderRadiusTypeAll boderRadius:bgViewRect.size.height/2.0];
        [self.contentView addSubview:bgView];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:headRect];
        self.headImageView.boderRadius = headRect.size.height/2.0;
        [self.contentView addSubview:self.headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:nameRect];
        self.nameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:fontSize];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        [self.contentView addSubview:self.nameLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:priceRect];
        self.priceLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:fontSize2];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"#FF6161"];
        [self.contentView addSubview:self.priceLabel];
        
        self.checkButton = [[UIButton alloc] initWithFrame:btnRect];
        [self.checkButton setBackgroundImage:[UIImage imageNamed:@"button3"] forState:UIControlStateNormal];
        [self.checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.checkButton setTitle:@"去检查" forState:UIControlStateNormal];
        self.checkButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:btnSize];
        [self.contentView addSubview:self.checkButton];
        
        self.acceptButton = [[UIButton alloc] initWithFrame:btnRect];
        [self.acceptButton setBackgroundImage:[UIImage imageNamed:@"button3"] forState:UIControlStateNormal];
        [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.acceptButton setTitle:@"接单" forState:UIControlStateNormal];
        self.acceptButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:btnSize];
        [self.contentView addSubview:self.acceptButton];
        self.acceptButton.hidden = YES;
        
        self.tutriolButton = [[UIButton alloc] initWithFrame:btnRect];
        [self.tutriolButton setTitleColor:[UIColor colorWithHexString:@"#648FFE"] forState:UIControlStateNormal];
        self.tutriolButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:btnSize];
        self.tutriolButton.layer.cornerRadius = 10;
        self.tutriolButton.layer.borderColor = [UIColor colorWithHexString:@"#648FFE"].CGColor;
        self.tutriolButton.layer.borderWidth = 0.7;
        [self.tutriolButton setTitle:@"去辅导" forState:UIControlStateNormal];
        [self.contentView addSubview:self.tutriolButton];
        self.tutriolButton.hidden = YES;
        
        self.stateLabel = [[UILabel alloc] initWithFrame:btnRect];
        self.stateLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:btnSize];
        self.stateLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        self.stateLabel.text = @"等待去辅导";
        [self.contentView addSubview:self.stateLabel];
        self.stateLabel.hidden = YES;
        
    }
    return self;
}

#pragma mark
-(void)configCellWithMyHomework:(HomeworkModel *)homework{
    //作业封面图
    if (kIsArray(homework.job_pic)&&homework.job_pic.count>0) {
        [self.zuoyeImgView sd_setImageWithURL:[NSURL URLWithString:homework.job_pic[0]] placeholderImage:[UIImage imageNamed:@"teacher_home_loading"]];
    }else{
        self.zuoyeImgView.image = [UIImage imageNamed:@"teacher_home_loading"];
    }
    //用户头像
    if (kIsEmptyString(homework.trait)) {
        self.headImageView.image  = [UIImage imageNamed:@"default_head_image"];
    }else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:homework.trait] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
    }
    
    //姓名
    NSString *nameStr = [NSString stringWithFormat:@"%@/%@",homework.username,homework.grade];
    NSRange aRange = NSMakeRange(nameStr.length-homework.grade.length-1, homework.grade.length+1);
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#808080"] range:aRange];
    [attributeStr addAttribute:NSFontAttributeName value:self.nameLabel.font range:aRange];
    self.nameLabel.attributedText = attributeStr;
    //预约时间
    if ([homework.label integerValue]==2) {
        NSString *day = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:homework.start_time format:@"yyyy-MM-dd"];
        NSString *today = [NSDate GetCurrentDay];
        NSString *tempDayStr = [day isEqualToString:today]?@"今天":@"明天";
        NSString *orderTimeStr = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:homework.start_time format:@"HH:mm"] ;
        self.orderTimeLabel.text = [NSString stringWithFormat:@"%@/%@ %@",homework.subject,tempDayStr,orderTimeStr];
    }else{
        self.orderTimeLabel.text = homework.subject;
    }
    
    CGFloat orderWidth = [self.orderTimeLabel.text boundingRectWithSize:CGSizeMake((kScreenWidth-30)/2.0, self.orderTimeLabel.height) withTextFont:self.orderTimeLabel.font].width;
    self.orderTimeLabel.frame = CGRectMake((kScreenWidth-30)/2.0-orderWidth-16, 16, orderWidth+20, self.orderTimeLabel.height);
    
    if ([homework.label integerValue]==1) { //作业检查
        self.checkButton .hidden = NO;
        self.tutriolButton.hidden = self.acceptButton.hidden = YES;
        self.stateLabel.hidden = YES;
        self.priceLabel.text =  [NSString stringWithFormat:@"¥%.2f",[homework.price doubleValue]];
    }else{ //作业辅导
        if ([homework.is_receive integerValue]==1) {  //待接单
            self.acceptButton .hidden = NO;
            self.tutriolButton.hidden = self.checkButton.hidden = YES;
            self.stateLabel.hidden = YES;
        }else{
            self.acceptButton .hidden = self.checkButton .hidden = YES;
            NSNumber *currentTime =[[ZYHelper sharedZYHelper] timeSwitchTimestamp:[NSDate currentFullDate] format:@"yyyy年MM月dd日 HH:mm:ss"];
            if ([homework.start_time integerValue]>[currentTime integerValue]) {
                self.tutriolButton.hidden = YES;
                self.stateLabel.hidden = NO;
            }else{
                 self.tutriolButton.hidden = NO;
                 self.stateLabel.hidden = YES;
            }
        }
        self.priceLabel.text =  [NSString stringWithFormat:@"¥%.2f/分钟",[homework.price doubleValue]];
    }
}

@end

