//
//  NSTimer+XH_Helper.m
//  ThirdLib
//
//  Created by 王博 on 2018/6/26.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "NSTimer+XH_Helper.h"

@implementation NSTimer (XH_Helper)
+ (NSTimer *)xh_timerWithTimeInterval:(NSTimeInterval)ti block:(void (^)(void))inBlock repeats:(BOOL)yesOrNo
{
    void (^block)(void) = [inBlock copy];
    NSTimer *timer = [self timerWithTimeInterval:ti target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:yesOrNo];
    return timer;
}

+ (NSTimer *)xh_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)(void))inBlock repeats:(BOOL)yesOrNo
{
    void (^block)(void) = [inBlock copy];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:yesOrNo];
    return timer;
}

+ (void)__executeTimerBlock:(NSTimer *)timer
{
    if ([timer userInfo]) {
        void (^block)(void) = (void (^)(void))[timer userInfo];
        block();
    }
}
@end
