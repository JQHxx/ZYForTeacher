//
//  WhiteboardLines.h
//  ZuoYe
//
//  Created by vision on 2018/10/12.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WhiteboardPoint.h"
#import "WhiteboardDrawView.h"

@interface WhiteboardLines : NSObject<WhiteboardDrawViewDataSource>

//添加线条
- (void)addPoint:(WhiteboardPoint *)point uid:(NSString *)uid;
//撤销
- (void)cancelLastLine:(NSString *)uid;
//清除
- (void)clear;

@end
