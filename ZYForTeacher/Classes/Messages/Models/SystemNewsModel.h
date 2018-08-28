//
//  SystemNewsModel.h
//  ZuoYe
//
//  Created by vision on 2018/8/13.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemNewsModel : NSObject

@property (nonatomic,assign)NSInteger   message_user_id;
@property (nonatomic,assign)NSInteger   message_id;
@property (nonatomic, copy )NSString    *title;
@property (nonatomic, copy )NSString    *send_time;
@property (nonatomic,assign)BOOL        isRead;
@property (nonatomic,assign)NSInteger   type;              //1、文章   2、系统消息

@end
