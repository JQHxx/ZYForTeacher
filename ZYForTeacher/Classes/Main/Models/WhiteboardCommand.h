//
//  WhiteboardCommand.h
//  ZuoYe
//
//  Created by vision on 2018/10/12.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WhiteboardPoint.h"

typedef NS_ENUM(NSUInteger, WhiteBoardCmdType){
    WhiteBoardCmdTypePointStart    = 1, //开始绘制
    WhiteBoardCmdTypePointMove     = 2,  //绘制中
    WhiteBoardCmdTypePointEnd      = 3,  //结束绘制
    
    WhiteBoardCmdTypeCancelLine    = 4,  //撤销
    WhiteBoardCmdTypePacketID      = 5,
    WhiteBoardCmdTypeClearLines    = 6,  //清除

    WhiteBoardCmdTypeExam          = 7,  //审题
    WhiteBoardCmdTypeStartCoach    = 8,   //开始辅导
    WhiteBoardCmdTypeEndCoach      = 9,   //结束辅导
    WhiteBoardCmdTypeCancelCoach   = 10,   //取消辅导
    WhiteBoardCmdTypeAddWhiteboard   = 11,   //添加白板
    WhiteBoardCmdTypeChooseWhiteboard   = 12,  //选择白板
    WhiteBoardCmdTypeDeleteWhiteboard   = 13,  //删除白板
};

@interface WhiteboardCommand : NSObject

+ (NSString *)pointCommand:(WhiteboardPoint *)point;

+ (NSString *)pureCommand:(WhiteBoardCmdType)type;

+ (NSString *)packetIdCommand:(UInt64)packetId;

+ (NSString *)boardHandleCommand:(WhiteBoardCmdType)type withIndex:(NSInteger)index;

@end
