//
//  NTESAVNotifier.m
//  ZuoYe
//
//  Created by vision on 2018/12/14.
//  Copyright © 2018 vision. All rights reserved.
//

#import "NTESAVNotifier.h"

@import AudioToolbox;

static void VibrateCompletion(SystemSoundID soundID, void *data)
{
    id notifier = (__bridge id)data;
    if([notifier isKindOfClass:[NTESAVNotifier class]])
    {
        SEL selector = NSSelectorFromString(@"vibrate");
        SuppressPerformSelectorLeakWarning([(NTESAVNotifier *)notifier performSelector:selector withObject:nil afterDelay:1.0]);
    }
}

@interface NTESAVNotifier ()

@property (nonatomic,assign)    BOOL shouldStopVibrate;
@property (nonatomic,assign)    NSInteger vibrateCount;

@end

@implementation NTESAVNotifier

singleton_implementation(NTESAVNotifier)

-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

#pragma mark - Public Methods
-(void)startVibrate{
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground){
        return;
    }
    [self stopVibrate];
    _vibrateCount = 0;
    _shouldStopVibrate = NO;
    [self vibrate];
}

-(void)stopVibrate{
    _shouldStopVibrate = YES;
}

#pragma mark - NSNotification
- (void)willEnterForeground:(NSNotification *)notification{
    [self stopVibrate];
}

#pragma mark -- Private Methods
#pragma mark 震动
- (void)vibrate{
    if (!_shouldStopVibrate)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, VibrateCompletion, (__bridge void *)self);
        _vibrateCount++;
        if (_vibrateCount >= 30){
            _shouldStopVibrate = YES;
        }
    }
}




@end
