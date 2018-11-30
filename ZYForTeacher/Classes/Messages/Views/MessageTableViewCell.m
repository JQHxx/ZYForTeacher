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
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(18, 13, 44, 44)];
        [self.contentView addSubview:imgView];
        
        //消息类型标题
        titleLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        titleLbl.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        [self.contentView addSubview:titleLbl];
        
        //时间
        timeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        timeLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        timeLbl.textAlignment=NSTextAlignmentRight;
        timeLbl.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        [self.contentView addSubview:timeLbl];
        
        //消息内容
        messageLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        messageLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        messageLbl.textColor=[UIColor colorWithHexString:@"#B4B4B4"];
        [self.contentView addSubview:messageLbl];
        
        badgeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        badgeLbl.backgroundColor=[UIColor colorWithHexString:@"#F50000"];
        badgeLbl.textColor=[UIColor whiteColor];
        badgeLbl.textAlignment=NSTextAlignmentCenter;
        badgeLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        [self.contentView addSubview:badgeLbl];
        badgeLbl.hidden=YES;
        
    }
    return self;
}


-(void)messageCellDisplayWithMessage:(MessageModel *)messageInfo type:(NSInteger)messageType{
    imgView.image = [UIImage imageNamed:messageInfo.icon];
    titleLbl.text = messageInfo.myTitle;
    titleLbl.frame=CGRectMake(imgView.right+20,10,100, 25);
    
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
        timeLbl.frame=CGRectMake(kScreenWidth-timeW-13,10, timeW, 25);
        
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
        CGSize countSize = [countStr boundingRectWithSize:CGSizeMake(80,18) withTextFont:badgeLbl.font];
        badgeLbl.frame = CGRectMake(47,11, countSize.width+10, 17);
        badgeLbl.layer.cornerRadius = 15.0/2.0;
        badgeLbl.clipsToBounds = YES;
        
    }else{
        badgeLbl.hidden=YES;
    }
    
    messageLbl.frame=CGRectMake(imgView.right+20, titleLbl.bottom, kScreenWidth-imgView.right-badgeLbl.width- 20, 25);
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
