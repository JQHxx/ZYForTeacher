//
//  WhiteboardLines.m
//  ZuoYe
//
//  Created by vision on 2018/10/12.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "WhiteboardLines.h"

@interface WhiteboardLines()

//所有人的白板线信息，key 是 uid
@property(nonatomic, strong) NSMutableDictionary *allLines;

@property(nonatomic, assign) BOOL hasUpdate;

@end

@implementation WhiteboardLines


- (instancetype)init{
    if (self = [super init]) {
        _allLines = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (NSDictionary *)allLines{
    return _allLines;
}

#pragma mark 添加线条
- (void)addPoint:(WhiteboardPoint *)point uid:(NSString *)uid{
    if (!point || !uid) {
        return;
    }
    
    NSMutableArray *lines = [_allLines objectForKey:uid];
    
    if (!lines) {
        lines = [[NSMutableArray alloc] init];
        [_allLines setObject:lines forKey:uid];
    }
    
    if (point.type == WhiteboardPointTypeStart) {
        [lines addObject:[NSMutableArray arrayWithObject:point]];
    }else if (lines.count == 0){
        [lines addObject:[NSMutableArray arrayWithObject:point]];
    }else {
        NSMutableArray *lastLine = [lines lastObject];
        [lastLine addObject:point];
    }
    _hasUpdate = YES;
}

#pragma mark 撤销
- (void)cancelLastLine:(NSString *)uid{
    NSMutableArray *lines = [_allLines objectForKey:uid];
    [lines removeLastObject];
    _hasUpdate = YES;
}

#pragma mark 清除
- (void)clear{
    [_allLines removeAllObjects];
    _hasUpdate = YES;
}

#pragma  mark - NTESWhiteboardDrawViewDataSource
- (NSDictionary *)allLinesToDraw{
    _hasUpdate = NO;
    return _allLines;
}

- (BOOL)hasUpdate{
    return _hasUpdate;
}

@end
