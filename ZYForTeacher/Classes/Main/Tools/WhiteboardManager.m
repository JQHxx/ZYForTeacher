//
//  WhiteboardManager.m
//  ZYForTeacher
//
//  Created by vision on 2018/10/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WhiteboardManager.h"
#import <NIMAVChat/NIMAVChat.h>
#import <NIMSDK/NIMSDK.h>

#define NTESRTSConferenceManager [NIMAVChatSDK sharedSDK].rtsConferenceManager

@interface WhiteboardManager ()<NIMRTSConferenceManagerDelegate>

@property (nonatomic ,strong) NIMRTSConference *currentConference;


@end

@implementation WhiteboardManager

singleton_implementation(WhiteboardManager);

-(instancetype)init{
    self = [super init];
    if (self) {
        [NTESRTSConferenceManager addDelegate:self];
    }
    return self;
}

-(void)dealloc{
    [self leaveCurrentConference];
    [NTESRTSConferenceManager removeDelegate:self];
}

#pragma mark 创建会话
-(NSError *)reserveConference:(NSString *)name{
    NIMRTSConference *conference = [[NIMRTSConference alloc] init];
    conference.name = name;
    conference.ext = @"test extend rts conference messge";
    return [NTESRTSConferenceManager reserveConference:conference];
}

#pragma mark 加入会话
- (NSError *)joinConference:(NSString *)name{
    [self leaveCurrentConference];
    
    NIMRTSConference *conference = [[NIMRTSConference alloc] init];
    conference.name = name;
    conference.serverRecording = YES;
    __weak typeof (self) wself = self;
    conference.dataHandler = ^(NIMRTSConferenceData *data) {
        [wself handleReceivedData:data];
    };
    NSError *result = [NTESRTSConferenceManager joinConference:conference];
    return result;
}

- (void)handleReceivedData:(NIMRTSConferenceData *)data{
    if (_dataHandler) {
        [_dataHandler handleReceivedData:data.data sender:data.uid];
    }
}

#pragma mark 退出当前会话
-(void)leaveCurrentConference{
    if (_currentConference) {
        NSError *result = [NTESRTSConferenceManager leaveConference:_currentConference];
        MyLog(@"leave current conference %@ result %@", _currentConference.name, result);
        _currentConference = nil;
    }
}

#pragma mark 发送数据
-(BOOL)sendRTSData:(NSData *)data toUser:(NSString *)uid{
    BOOL accepted = NO;
    if (_currentConference) {
        NIMRTSConferenceData *conferenceData = [[NIMRTSConferenceData alloc] init];
        conferenceData.conference = _currentConference;
        conferenceData.data = data;
        conferenceData.uid = uid;
        accepted = [NTESRTSConferenceManager sendRTSData:conferenceData];
    }
    return accepted;
}

#pragma mark - NIMRTSConferenceManagerDelegate
#pragma mark 创建多人互动白板结果回调
-(void)onReserveConference:(NIMRTSConference *)conference result:(NSError *)result{
    MyLog(@"Reserve conference %@ result:%@", conference.name, result);
    if (result.code == NIMRemoteErrorCodeExist) {
        result = nil;
    }
    if (_delegate) {
        [_delegate onReserve:conference.name result:result];
    }
}
#pragma mark 加入多人互动白板结果回调
- (void)onJoinConference:(NIMRTSConference *)conference result:(NSError *)result{
    MyLog(@"Join conference %@ result:%@", conference.name, result);
    if (nil == result || nil == _currentConference) {
        _currentConference = conference;
    }
    if (_delegate) {
        [_delegate onJoin:conference.name result:result];
    }
}


@end
