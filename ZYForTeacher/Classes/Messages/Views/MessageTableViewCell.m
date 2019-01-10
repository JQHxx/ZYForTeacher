//
//  MessageTableViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/22.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell (){
    UIImageView   *imgView;
    UILabel       *titleLbl;
    UILabel       *timeLbl;
    UILabel       *messageLbl;
    UILabel       *badgeLbl;
}

@end

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //消息icon
        imgView=[[UIImageView alloc] initWithFrame:IS_IPAD?CGRectMake(36, 22, 68, 68):CGRectMake(18, 13, 44, 44)];
        [self.contentView addSubview:imgView];
        
        //消息类型标题
        titleLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:16];
        titleLbl.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        [self.contentView addSubview:titleLbl];
        
        //时间
        timeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        timeLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?19:12];
        timeLbl.textAlignment=NSTextAlignmentRight;
        timeLbl.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        [self.contentView addSubview:timeLbl];
        
        //消息内容
        messageLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        messageLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?21:14];
        messageLbl.textColor=[UIColor colorWithHexString:@"#B4B4B4"];
        [self.contentView addSubview:messageLbl];
        
        badgeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        badgeLbl.backgroundColor=[UIColor colorWithHexString:@"#F50000"];
        badgeLbl.textColor=[UIColor whiteColor];
        badgeLbl.textAlignment=NSTextAlignmentCenter;
        badgeLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?18:12];
        [self.contentView addSubview:badgeLbl];
        badgeLbl.hidden=YES;
        
    }
    return self;
}


-(void)messageCellDisplayWithMessage:(MessageModel *)messageInfo type:(NSInteger)messageType{
    imgView.image = [UIImage imageNamed:messageInfo.icon];
    titleLbl.text = messageInfo.myTitle;
    titleLbl.frame= IS_IPAD?CGRectMake(imgView.right+30, 25, 150, 30):CGRectMake(imgView.right+20,10,100, 25);
    
    NSString *messageStr = nil;
    if (messageType==1){ //支付消息
        if (!kIsEmptyString(messageInfo.oid)) {
            messageStr = [NSString stringWithFormat:@"订单号为%@的订单已完成支付",messageInfo.oid];
        }
    }else if (messageType==2){ //评论消息
        if (!kIsEmptyString(messageInfo.comment)) {
            messageStr = messageInfo.comment;
        }
    }else if(messageType==3){ //投诉消息
        if (!kIsEmptyString(messageInfo.complain)) {
            messageStr = messageInfo.complain;
        }
    }else{ //系统消息
        if (!kIsEmptyString(messageInfo.desc)) {
            messageStr = messageInfo.title;
        }
    }
    
    if (!kIsEmptyString(messageStr)) {
        timeLbl.text = [[ZYHelper sharedZYHelper] timeWithTimeIntervalNumber:messageInfo.create_time format:@"yyyy-MM-dd HH:mm"];
        CGFloat timeW=[timeLbl.text boundingRectWithSize:CGSizeMake(kScreenWidth, 25) withTextFont:timeLbl.font].width;
        timeLbl.frame= IS_IPAD?CGRectMake(kScreenWidth-timeW-35, 25, timeW, 26):CGRectMake(kScreenWidth-timeW-13,10, timeW, 25);
        
        messageLbl.text = messageStr;
    }else{
        messageLbl.text = @"暂无消息";
    }
    
    NSInteger count =[messageInfo.count integerValue];
    if (count > 0) {
        badgeLbl.hidden = NO;
        NSString *countStr = nil;
        if (count > 99) {
            countStr = @"99+";
        }else{
            countStr = [NSString stringWithFormat:@"%ld",(long)count];
        }
        badgeLbl.text = countStr;
        CGSize countSize = [countStr boundingRectWithSize:IS_IPAD?CGSizeMake(120, 23):CGSizeMake(80,18) withTextFont:badgeLbl.font];
        badgeLbl.frame = IS_IPAD?CGRectMake(90, 23, countSize.width+20,23):CGRectMake(47,11, countSize.width+10, 17);
        badgeLbl.layer.cornerRadius = (badgeLbl.height-1)/2.0;
        badgeLbl.clipsToBounds = YES;
        
    }else{
        badgeLbl.hidden=YES;
    }
    
    messageLbl.frame= IS_IPAD?CGRectMake(imgView.right+30, titleLbl.bottom, kScreenWidth-imgView.right-50, 29):CGRectMake(imgView.right+20, titleLbl.bottom, kScreenWidth-imgView.right-40, 25);
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
