//
//  ConversationTableViewCell.m
//  TangShiService
//
//  Created by vision on 17/5/31.
//  Copyright © 2017年 tianjiyun. All rights reserved.
//

#import "ConversationTableViewCell.h"
#import "SystemNewsModel.h"
#import "ConversationModel.h"

@interface ConversationTableViewCell (){
    UIImageView   *imgView;
    UILabel       *nameLbl;
    UILabel       *timeLbl;
    UILabel       *messageLbl;
    UILabel       *badgeLbl;
}

@end

@implementation ConversationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(18, 13, 44, 44)];
        [self.contentView addSubview:imgView];
        
        nameLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        nameLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        nameLbl.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        [self.contentView addSubview:nameLbl];
        
        timeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        timeLbl.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        timeLbl.textAlignment=NSTextAlignmentRight;
        timeLbl.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
        [self.contentView addSubview:timeLbl];
        
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



-(void)conversationCellDisplayWithModel:(id )model{
    NSInteger count = 0;
    if ([model isKindOfClass:[ConversationModel class]]) {
        
        ConversationModel *conversation = (ConversationModel *)model;
        imgView.image = [UIImage imageNamed:conversation.lastMsgHeadPic];
        nameLbl.text = conversation.lastMsgUserName;
        
        timeLbl.text = conversation.lastMsgTime;
        CGFloat timeW = [conversation.lastMsgTime boundingRectWithSize:CGSizeMake(kScreenWidth, 17) withTextFont:timeLbl.font].width;
        timeLbl.frame = CGRectMake(kScreenWidth-timeW-13,15, timeW, 17);
        
        CGFloat nameW = [conversation.lastMsgUserName boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:nameLbl.font].width;
        CGFloat totalW = imgView.right+10+nameW+10+timeW+10;
        if (totalW > kScreenWidth) {
            nameLbl.frame = CGRectMake(imgView.right+20, 15,kScreenWidth-imgView.right-10-5-timeW-10, 20);
        }else{
            nameLbl.frame = CGRectMake(imgView.right+20, 15, nameW, 20);
        }
        
        messageLbl.text = conversation.lastMsg;
        count = conversation.unreadCount;
        
        
    }else if ([model isKindOfClass:[SystemNewsModel class]]){
        imgView.image=[UIImage imageNamed:@"news"];
        nameLbl.text=@"系统消息";
        nameLbl.frame=CGRectMake(imgView.right+20,18,100, 20);
        
        SystemNewsModel *systemNews=(SystemNewsModel *)model;
        timeLbl.text = systemNews.send_time;
        CGFloat timeW=[systemNews.send_time boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:timeLbl.font].width;
        timeLbl.frame=CGRectMake(kScreenWidth-timeW-13,18, timeW, 17);
        
        messageLbl.text=kIsEmptyString(systemNews.title)?@"暂无":systemNews.title;
        
        count =systemNews.unreadCount;
    }
    
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
    
    messageLbl.frame=CGRectMake(imgView.right+20, nameLbl.bottom, kScreenWidth-imgView.right-badgeLbl.width- 20, 20);
}


@end
