//
//  XHWeakTimer.m
//  ThirdLib
//
//  Created by 王博 on 2018/6/26.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHWeakTimer.h"
@interface XHWeakTimerTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer* weaktimer;

@end

@implementation XHWeakTimerTarget

- (void)fire:(NSTimer *)timer {
    if(self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0.0f];
#pragma clang diagnostic pop
    } else {
        [self.weaktimer invalidate];
    }
}

@end

@implementation XHWeakTimer
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
    XHWeakTimerTarget *weakTarget = [[XHWeakTimerTarget alloc] init];
    weakTarget.target = target;
    weakTarget.selector = selector;
    weakTarget.weaktimer = [NSTimer scheduledTimerWithTimeInterval:ti target:weakTarget selector:@selector(fire:) userInfo:userInfo repeats:repeats];
    return weakTarget.weaktimer;
}


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(XHWeakHandleBlock)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats
{
    NSMutableArray *muArray = @[].mutableCopy;
    [muArray addObject:[block copy]];
    if (userInfo != nil) {
        [muArray addObject:userInfo];
    }
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(_timerBlockInvoke:) userInfo:[muArray copy] repeats:repeats];
}

+ (void)_timerBlockInvoke:(NSArray *)userInfo
{
    XHWeakHandleBlock block = userInfo.firstObject;
    id info = nil;
    if (userInfo.count == 2) {
        info = userInfo[1];
    }
    !block ? : block(info);
    
}
@end
