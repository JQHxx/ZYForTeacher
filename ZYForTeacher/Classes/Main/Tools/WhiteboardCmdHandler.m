//
//  WhiteboardCmdHandler.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WhiteboardCmdHandler.h"
#import "WhiteboardManager.h"


@interface WhiteboardCmdHandler ()

@property (nonatomic, strong) NSMutableString *cmdsSendBuffer;

@property (nonatomic, assign) UInt64 refPacketID;

@property (nonatomic, weak) id<WhiteboardCmdHandlerDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *syncPoints;

@end

@implementation WhiteboardCmdHandler

- (instancetype)initWithDelegate:(id<WhiteboardCmdHandlerDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
        _cmdsSendBuffer = [[NSMutableString alloc] init];
        _syncPoints = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark 发送白板绘制数据
- (void)sendMyPoint:(WhiteboardPoint *)point{
    NSString *cmd = [WhiteboardCommand pointCommand:point];
    [_cmdsSendBuffer appendString:cmd];
    [self doSendCmds];
}

#pragma mark 发送指令
- (void)sendPureCmd:(WhiteBoardCmdType)type{
    NSString *cmd = [WhiteboardCommand pureCommand:type];
    [_cmdsSendBuffer appendString:cmd];
    [self doSendCmds];
}

#pragma mark 发送白板操作
-(void)sendHandleCmd:(WhiteBoardCmdType)type index:(NSInteger)index{
    NSString *cmd = [WhiteboardCommand boardHandleCommand:type withIndex:index];
    [_cmdsSendBuffer appendString:cmd];
    [self doSendCmds];
}

#pragma mark  -- WhiteboardManagerDataHandler
#pragma mark 处理接收到的数据
-(void)handleReceivedData:(NSData *)data sender:(NSString *)sender{
    NSString *cmdsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    MyLog(@"handleReceivedData:%@",cmdsString);
    NSArray *cmdsArray = [cmdsString componentsSeparatedByString:@";"];
    for (NSString *cmdString in cmdsArray) {
        if (cmdString.length == 0) {
            continue;
        }
        
        NSArray *cmd = [cmdString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
        NSInteger type = [cmd[0] integerValue];
        switch (type) {
            case WhiteBoardCmdTypeEndCoach:  //结束辅导
            case WhiteBoardCmdTypeCancelCoach:    //取消辅导
            {
                if (_delegate) {
                    [_delegate onReceiveCmd:type from:sender];
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark -- Private Methods
#pragma mark 发送数据
- (void)doSendCmds{
    if (_cmdsSendBuffer.length>0) {
        NSString *cmd =  [WhiteboardCommand packetIdCommand:_refPacketID++];
        [_cmdsSendBuffer appendString:cmd];
        [[WhiteboardManager sharedWhiteboardManager] sendRTSData:[_cmdsSendBuffer dataUsingEncoding:NSUTF8StringEncoding] toUser:nil];
        MyLog(@"send data %@", _cmdsSendBuffer);
        [_cmdsSendBuffer setString:@""];
    }
}



@end
