//
//  NTESAVNotifier.h
//  ZuoYe
//
//  Created by vision on 2018/12/14.
//  Copyright © 2018 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTESAVNotifier : NSObject

singleton_interface(NTESAVNotifier)

//震动
- (void)startVibrate;
//停止震动
-(void)stopVibrate;

@end

NS_ASSUME_NONNULL_END
