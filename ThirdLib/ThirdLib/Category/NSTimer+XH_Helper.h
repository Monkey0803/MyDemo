//
//  NSTimer+XH_Helper.h
//  ThirdLib
//
//  Created by 王博 on 2018/6/26.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (XH_Helper)
///block 里面不能再强引用timer 否则会造成循环引用， 可以使用weakSelf.timer 弱引用
+ (NSTimer *)xh_timerWithTimeInterval:(NSTimeInterval)ti block:(void (^)(void))inBlock repeats:(BOOL)yesOrNo;
+ (NSTimer *)xh_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void (^)(void))inBlock repeats:(BOOL)yesOrNo;
@end
