//
//  MessageListTableViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MessageListTableViewCell.h"

#define kRootViewWidth kScreenWidth-30

@interface MessageListTableViewCell (){
    NSInteger       _type;  //1.支付消息 2.评论消息 3.投诉消息
    NSMutableArray  *scoreArray;  //评分
    
    
}

@property (nonatomic,strong)UIView      *rootView;
@property (nonatomic,strong)UIImageView *headImgView;
@property (nonatomic,strong)UILabel     *nicknameLab;
@property (nonatomic,strong)UILabel     *timeLabel;
@property (nonatomic,strong)UILabel     *lineLabel;

@property (nonatomic,strong)UILabel     *payMoneyLabel;  //付款金额
@property (nonatomic,strong)UILabel     *payWayLabel;     //支付方式

@property (nonatomic,strong)UILabel     *titleLabel;             //类型或评分
@property (nonatomic,strong)UILabel     *contentTitleLabel;      //评语或投诉内容标题

@property (nonatomic,strong)UILabel     *complainTypeLabel;      //投诉类型
@property (nonatomic,strong)UILabel     *complainContentLabel;    //投诉内容
@property (nonatomic,strong)UILabel     *commentContentLabel;     //评语

@property (nonatomic,strong)UILabel   *orderSnLab;



@end


@implementation MessageListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _type = type;
        
        self.contentView.backgroundColor = [UIColor bgColor_Gray];
        
        self.rootView = [[UIView alloc] initWithFrame:CGRectZero];
        self.rootView.backgroundColor = [UIColor whiteColor];
        self.rootView.layer.cornerRadius =4.0;
        [self.contentView addSubview:self.rootView];
        
        //头像
        self.headImgView = [[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(44, 32, 50, 50):CGRectMake(12+15, 18, 32, 32)];
        self.headImgView.boderRadius = IS_IPAD?25:16;
        [self.contentView addSubview:self.headImgView];
        
        //昵称
        self.nicknameLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(self.headImgView.right+15, 40, 160, 32):CGRectMake(self.headImgView.right+10, 20, 100, 25)];
        self.nicknameLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        self.nicknameLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?23:15];
        [self.contentView addSubview:self.nicknameLab];
        
        //日期
        self.timeLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-245, 43, 200, 30):CGRectMake(kRootViewWidth-120, 20, 120, 25)];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#A2A2A2"];
        self.timeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?21:14];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        //线条
        self.lineLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(45, self.headImgView.bottom+10, kScreenWidth-90, 0.5):CGRectMake(30, self.headImgView.bottom+7, kRootViewWidth-30, 0.5)];
        self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self.contentView addSubview:self.lineLabel];
        
        if (type==1) { //支付消息
            self.payMoneyLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(44, self.lineLabel.bottom+17, 240, 32):CGRectMake(12+15, self.lineLabel.bottom+5, 180, 25)];
            self.payMoneyLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            self.payMoneyLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?23:15];
            [self.contentView addSubview:self.payMoneyLabel];
            
            self.payWayLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(44, self.payMoneyLabel.bottom+5, 240, 32):CGRectMake(12+15, self.payMoneyLabel.bottom, 180, 25)];
            self.payWayLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            self.payWayLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?23:15];
            [self.contentView addSubview:self.payWayLabel];
        }else{
            CGRect titleRect,contentRect;
            if (IS_IPAD) {
                titleRect = type==2?CGRectMake(44, self.lineLabel.bottom+17, 70,32):CGRectMake(44, self.lineLabel.bottom+17, 115, 32);
                contentRect = type==2?CGRectMake(44, titleRect.origin.y+titleRect.size.height+5, 70, 32):CGRectMake(44,titleRect.origin.y+titleRect.size.height, 115, 32);
            }else{
                titleRect = type==2?CGRectMake(12+15, self.lineLabel.bottom+5, 45, 25):CGRectMake(12+15, self.lineLabel.bottom+5, 75, 25);
                contentRect = type==2?CGRectMake(12+15,titleRect.origin.y+titleRect.size.height, 45, 20):CGRectMake(12+15,titleRect.origin.y+titleRect.size.height, 75, 20);
            }
            
            
            self.titleLabel = [[UILabel alloc] initWithFrame:titleRect];
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            self.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?23:15];
            self.titleLabel.text = type==2?@"评分：":@"类      型：";
            [self.contentView addSubview:self.titleLabel];
            
            self.contentTitleLabel = [[UILabel alloc] initWithFrame:contentRect];
            self.contentTitleLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
            self.contentTitleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?23:15];
            self.contentTitleLabel.text = type==2?@"评语：":@"投诉内容：";
            [self.contentView addSubview:self.contentTitleLabel];
            
            
            if (type==2) { //评论消息
                //评分
                //准备5个心桃 默认隐藏
                scoreArray = [[NSMutableArray alloc]init];
                for (int i = 0; i<=4; i++) {
                    UIImageView *scoreImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"score"]];
                    [scoreArray addObject:scoreImage];
                    [self.contentView addSubview:scoreImage];
                }
                //评语
                self.commentContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                self.commentContentLabel.textColor = [UIColor colorWithHexString:@"#808080"];
                self.commentContentLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?23:15];
                self.commentContentLabel.numberOfLines = 0;
                [self.contentView addSubview:self.commentContentLabel];
            
            }else{
                //投诉类型
                self.complainTypeLabel = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(self.titleLabel.right,  self.lineLabel.bottom+17, 200, 32):CGRectMake(self.titleLabel.right, self.lineLabel.bottom+5, 120, 25)];
                self.complainTypeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
                self.complainTypeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?23:15];
                [self.contentView addSubview:self.complainTypeLabel];
                //投诉内容
                self.complainContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                self.complainContentLabel.textColor = [UIColor colorWithHexString:@"#808080"];
                self.complainContentLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?23:15];
                self.complainContentLabel.numberOfLines = 0;
                [self.contentView addSubview:self.complainContentLabel];
            }
        }
        
        //订单号
        self.orderSnLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.orderSnLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        self.orderSnLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        [self.contentView addSubview:self.orderSnLab];
        
        if (kScreenWidth>=375.0) {
            self.checkDetailsBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            [self.checkDetailsBtn setTitle:@"查看订单详情>" forState:UIControlStateNormal];
            [self.checkDetailsBtn setTitleColor:[UIColor colorWithHexString:@"#648FFE"] forState:UIControlStateNormal];
            self.checkDetailsBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
            [self.contentView addSubview:self.checkDetailsBtn];
        }
        
    }
    return self;
}

#pragma mark 设置信息
-(void)setMessageModel:(MessageModel *)messageModel{
    if (kIsEmptyString(messageModel.trait)) {
        self.headImgView.image = [UIImage imageNamed:@"default_head_image"];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:messageModel.trait] placeholderImage:[UIImage imageNamed:@"default_head_image"]];
    }
    self.nicknameLab.text = messageModel.username;
    
    self.timeLabel.text = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:messageModel.create_time format:@"yyyy-MM-dd HH:mm"];
    
    //支付信息
    NSString *payStr = [NSString stringWithFormat:@"付款金额：¥%.2f",[messageModel.pay_money doubleValue]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:payStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF6161"] range:NSMakeRange(5, payStr.length-5)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?23:15] range:NSMakeRange(5, payStr.length-5)];
    self.payMoneyLabel.attributedText = attributeStr;
    
    NSString *payWayStr = nil;
    if ([messageModel.pay_cate integerValue]==1) { //支付宝
        payWayStr = @"支付宝支付";
    }else if ([messageModel.pay_cate integerValue]==2){ //微信支付
        payWayStr = @"微信支付";
    }else{ //余额支付
        payWayStr = @"余额支付";
    }
    NSString *tempPayWayStr = [NSString stringWithFormat:@"支付方式：%@",payWayStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:tempPayWayStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#808080"] range:NSMakeRange(5, tempPayWayStr.length-5)];
    self.payWayLabel.attributedText = attStr;
    
    //评论信息
    //评分 加星级
    CGSize scoreSize = IS_IPAD?CGSizeMake(20, 20):CGSizeMake(13, 13);
    double scoreNum = [messageModel.score doubleValue];
    NSInteger oneScroe=(NSInteger)scoreNum;
    NSInteger num=scoreNum>oneScroe?oneScroe+1:oneScroe;
    for (int i = 0; i<scoreArray.count; i++) {
        UIImageView *scoreImage = scoreArray[i];
        [scoreImage setFrame:IS_IPAD?CGRectMake(self.titleLabel.right+(scoreSize.width+6.0)*i,self.lineLabel.bottom+22, scoreSize.width, scoreSize.height):CGRectMake(self.titleLabel.right+(scoreSize.width+4.0)*i,self.lineLabel.bottom+11, scoreSize.width, scoreSize.height)];
        if (i<= num-1) {
            if ((i==num-1)&&scoreNum>oneScroe) {
                scoreImage.image=[UIImage imageNamed:@"score_half"];
            }
        }else{
            scoreImage.image=[UIImage imageNamed:@"score_gray"];
        }
    }
    //评语
    self.commentContentLabel.text = messageModel.comment;
    CGFloat commentHeight = [messageModel.comment boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-146, CGFLOAT_MAX):CGSizeMake(kRootViewWidth-100, CGFLOAT_MAX) withTextFont:self.commentContentLabel.font].height;
    [self.commentContentLabel setFrame:IS_IPAD?CGRectMake(self.contentTitleLabel.right, self.titleLabel.bottom+5, kScreenWidth-146, commentHeight):CGRectMake(self.contentTitleLabel.right, self.titleLabel.bottom, kRootViewWidth-100, commentHeight)];
    
    //投诉信息
    //投诉类型
    NSString *complainTypeStr = nil;
    if ([messageModel.label integerValue]==1) {
        complainTypeStr = @"对老师不满意";
    }else if ([messageModel.label integerValue]==2){
        complainTypeStr = @"对订单有疑问";
    }else{
        complainTypeStr = @"其他";
    }
    self.complainTypeLabel.text = complainTypeStr;
    //投诉内容
    self.complainContentLabel.text = messageModel.complain;
    CGFloat complainHeight = [messageModel.complain boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-181, CGFLOAT_MAX):CGSizeMake(kRootViewWidth-100, CGFLOAT_MAX) withTextFont:self.complainContentLabel.font].height;
    [self.complainContentLabel setFrame:IS_IPAD?CGRectMake(self.contentTitleLabel.right, self.titleLabel.bottom+5, kScreenWidth-181, complainHeight):CGRectMake(self.contentTitleLabel.right, self.titleLabel.bottom, kRootViewWidth-100, complainHeight)];
    
    self.orderSnLab.text = [NSString stringWithFormat:@"订单号：%@",messageModel.oid];
    
    CGFloat tempHeight = 0.0;
    CGFloat contentBottomHeight = 0.0;
    if (_type==1) {
        tempHeight = IS_IPAD?221:140;
        contentBottomHeight = self.payWayLabel.bottom+10;
    }else if (_type==2){
        tempHeight = IS_IPAD?190+commentHeight:commentHeight +112;
        contentBottomHeight = self.commentContentLabel.bottom+10;
    }else{
        tempHeight = IS_IPAD?190+complainHeight:complainHeight +112;
        contentBottomHeight = self.complainContentLabel.bottom+10;
    }
    self.orderSnLab.frame = IS_IPAD?CGRectMake(44, contentBottomHeight, 360, 30):CGRectMake(12+15, contentBottomHeight, 220, 20);
    
    self.checkDetailsBtn.frame = IS_IPAD?CGRectMake(kScreenWidth-200, contentBottomHeight, 150, 30):CGRectMake(kRootViewWidth-90,contentBottomHeight, 95, 20);
    
    self.rootView.frame = IS_IPAD?CGRectMake(22, 21, kScreenWidth-44, tempHeight):CGRectMake(15, 10, kRootViewWidth, tempHeight+5);
}

+(CGFloat)getCellHeightWithModel:(MessageModel *)model type:(NSInteger)type{
    if (type==1) {  //支付
        return IS_IPAD?242.0:160.0;
    }else if (type==2){ //评论
        CGFloat commentHeight = [model.comment boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-146, CGFLOAT_MAX):CGSizeMake(kRootViewWidth-100, CGFLOAT_MAX) withTextFont:[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?23:15]].height;
        return IS_IPAD?211+commentHeight:82+commentHeight+50;
    }else{ //投诉
         CGFloat complainHeight = [model.complain boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-181, CGFLOAT_MAX):CGSizeMake(kRootViewWidth-100, CGFLOAT_MAX) withTextFont:[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?23:15]].height;
        return IS_IPAD?211+complainHeight:82+complainHeight+50;
    }
}


@end
