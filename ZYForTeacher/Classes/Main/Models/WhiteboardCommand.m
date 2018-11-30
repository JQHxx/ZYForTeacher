//
//  WhiteboardCommand.m
//  ZuoYe
//
//  Created by vision on 2018/10/12.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WhiteboardCommand.h"

#define WhiteboardCmdFormatPoint @"%zd:%.4f,%.4f,%ld,%.1f;"
#define WhiteboardCmdFormatPacketID @"%zd:%llu;"
#define WhiteboardCmdFormatPureCmd  @"%zd:;"
#define WhiteboardCmdFormatBoardCmd @"%zd:%ld;"

@implementation WhiteboardCommand

+ (NSString *)pointCommand:(WhiteboardPoint *)point
{
    return [NSString stringWithFormat:WhiteboardCmdFormatPoint, point.type, point.xScale, point.yScale, point.colorRGB,point.lineWidth];
}

+ (NSString *)pureCommand:(WhiteBoardCmdType)type
{
    return [NSString stringWithFormat:WhiteboardCmdFormatPureCmd, type];
}

+ (NSString *)packetIdCommand:(UInt64)packetId
{
    return [NSString stringWithFormat:WhiteboardCmdFormatPacketID, WhiteBoardCmdTypePacketID, packetId];
}

+(NSString *)boardHandleCommand:(WhiteBoardCmdType)type withIndex:(NSInteger)index{
    return [NSString stringWithFormat:WhiteboardCmdFormatBoardCmd,type,index];
}

@end
