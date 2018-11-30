//
//  WhiteboardManager.h
//  ZYForTeacher
//
//  Created by vision on 2018/10/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol WhiteboardManagerDelegate <NSObject>
//创建互动白板回调
- (void)onReserve:(NSString *)name result:(NSError *)result;
//加入互动白板回调
- (void)onJoin:(NSString *)name result:(NSError *)result;

@end

@protocol WhiteboardManagerDataHandler <NSObject>

- (void)handleReceivedData:(NSData *)data sender:(NSString *)sender;

@end

@interface WhiteboardManager : NSObject

singleton_interface(WhiteboardManager);

@property (nonatomic, weak) id<WhiteboardManagerDelegate> delegate;

@property (nonatomic, weak) id <WhiteboardManagerDataHandler> dataHandler;

//创建会话
- (NSError *)reserveConference:(NSString *)name;
//加入会话
- (NSError *)joinConference:(NSString *)name;
//退出当前会话
- (void)leaveCurrentConference;
//发送数据
- (BOOL)sendRTSData:(NSData *)data toUser:(NSString *)uid;

@end
