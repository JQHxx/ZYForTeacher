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
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        imgView.layer.cornerRadius=25;
        imgView.clipsToBounds=YES;
        [self.contentView addSubview:imgView];
        
        nameLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        nameLbl.font=[UIFont boldSystemFontOfSize:16];
        nameLbl.textColor=[UIColor blackColor];
        [self.contentView addSubview:nameLbl];
        
        timeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        timeLbl.font=[UIFont systemFontOfSize:12];
        timeLbl.textAlignment=NSTextAlignmentRight;
        timeLbl.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:timeLbl];
        
        messageLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        messageLbl.font=[UIFont systemFontOfSize:14];
        messageLbl.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:messageLbl];
        
        badgeLbl=[[UILabel alloc] initWithFrame:CGRectZero];
        badgeLbl.backgroundColor=[UIColor redColor];
        badgeLbl.textColor=[UIColor whiteColor];
        badgeLbl.textAlignment=NSTextAlignmentCenter;
        badgeLbl.font=[UIFont systemFontOfSize:10];
        [self.contentView addSubview:badgeLbl];
        badgeLbl.hidden=YES;
        
    }
    return self;
}



-(void)conversationCellDisplayWithModel:(id )model{
    if ([model isKindOfClass:[ConversationModel class]]) {
        
        ConversationModel *conversation = (ConversationModel *)model;
        imgView.image = [UIImage imageNamed:conversation.lastMsgHeadPic];
        nameLbl.text = conversation.lastMsgUserName;
        
        timeLbl.text = conversation.lastMsgTime;
        CGFloat timeW = [conversation.lastMsgTime boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:timeLbl.font].width;
        timeLbl.frame = CGRectMake(kScreenWidth-timeW-10,10, timeW, 20);
        
        CGFloat nameW = [conversation.lastMsgUserName boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:nameLbl.font].width;
        CGFloat totalW = imgView.right+10+nameW+10+timeW+10;
        if (totalW > kScreenWidth) {
            nameLbl.frame = CGRectMake(imgView.right+10, 5,kScreenWidth-imgView.right-10-5-timeW-10, 30);
        }else{
            nameLbl.frame = CGRectMake(imgView.right+10, 5, nameW, 30);
        }
        
        messageLbl.text = conversation.lastMsg;
        
        NSInteger count = conversation.unreadCount;
        if (count > 0) {
            badgeLbl.hidden = NO;
            NSString *countStr = nil;
            if (count > 99) {
                countStr = @"99+";
            }else{
                countStr = [NSString stringWithFormat:@"%ld",(long)count];
            }
            badgeLbl.text = countStr;
            CGSize countSize = [countStr boundingRectWithSize:CGSizeMake(80,60) withTextFont:badgeLbl.font];
            badgeLbl.frame = CGRectMake(kScreenWidth-countSize.width-20, nameLbl.bottom, countSize.width+12, countSize.height+5);
            badgeLbl.layer.cornerRadius = (countSize.height+5)/2.0;
            badgeLbl.clipsToBounds = YES;
            
        }else{
            badgeLbl.hidden=YES;
        }
        
    }else if ([model isKindOfClass:[SystemNewsModel class]]){
        imgView.image=[UIImage imageNamed:@"ic_msg_tips"];
        nameLbl.text=@"系统消息";
        nameLbl.frame=CGRectMake(imgView.right+10, 5,100, 30);
        
        SystemNewsModel *systemNews=(SystemNewsModel *)model;
        timeLbl.text = systemNews.send_time;
        CGFloat timeW=[systemNews.send_time boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:timeLbl.font].width;
        timeLbl.frame=CGRectMake(kScreenWidth-timeW-10,10, timeW, 20);
        
        messageLbl.text=kIsEmptyString(systemNews.title)?@"暂无":systemNews.title;
        
        BOOL isRead=kIsEmptyString(systemNews.title)?YES:systemNews.isRead;
        
        badgeLbl.hidden=isRead;
        badgeLbl.frame=CGRectMake(kScreenWidth-20, timeLbl.bottom+10, 10, 10);
        badgeLbl.layer.cornerRadius=5;
        badgeLbl.clipsToBounds=YES;
        badgeLbl.text=@"";
    }
    
    messageLbl.frame=CGRectMake(imgView.right+10, nameLbl.bottom, kScreenWidth-imgView.right-badgeLbl.width- 20, 20);
}


@end
