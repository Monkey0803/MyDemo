//
//  XHWeakTimer.h
//  ThirdLib
//
//  Created by 王博 on 2018/6/26.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^XHWeakHandleBlock)(id userInfo);
@interface XHWeakTimer : NSObject
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(XHWeakHandleBlock)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;
@end
