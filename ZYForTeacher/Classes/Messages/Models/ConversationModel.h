//
//  ConversationModel.h
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversationModel : NSObject

@property (nonatomic, copy)NSString   *lastMsgHeadPic;    //头像
@property (nonatomic, copy)NSString   *lastMsgUserName;    //昵称
@property (nonatomic, copy)NSString   *lastMsg;
@property (nonatomic, copy)NSString   *lastMsgTime;
@property (nonatomic,assign)NSInteger unreadCount;

@end
