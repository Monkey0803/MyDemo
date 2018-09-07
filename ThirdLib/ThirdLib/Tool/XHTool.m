//
//  XHTool.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/7.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHTool.h"
#import <UserNotifications/UserNotifications.h>
@implementation XHTool

+ (instancetype)shareTool
{
    static XHTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [XHTool new];
    });
    return _tool;
}

#pragma mark -------------- 通知 --------------

/**
 移除所有没有触发的通知
 */
- (void)removeAllNoti
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            NSMutableArray *muArray = @[].mutableCopy;
            for (UNNotificationRequest *request in requests) {
                [muArray addObject:request.identifier];
            }
            [center removePendingNotificationRequestsWithIdentifiers:muArray.copy];
            [center removeAllPendingNotificationRequests];
        }];
    } else {
        // Fallback on earlier versions
    }
   
}

#pragma mark -------------- array --------------

/**
 判断数组是否为空

 @param sourceArray 源数组
 @return YES 数组为空
 */
- (BOOL)emptyArray:(NSArray *)sourceArray
{
    if (
        sourceArray == nil ||
        sourceArray.count == 0 ||
        [sourceArray isKindOfClass:[NSNull class]]
        ) {
        return YES;
    }
    return NO;
}

/**
 给源数组添加一个元素，当源数组没有初始化，对源数组进行初始化，在添加元素

 @param object 被添加的元素
 @param sourceArray 源数组
 @return 新的数组
 */
- (NSArray *)addNilObject:(id)object sourceArray:(NSArray *)sourceArray
{
    if (object != nil) {
        NSMutableArray *muArray = sourceArray.mutableCopy;
        if ([self emptyArray:sourceArray]) {
            muArray = @[].mutableCopy;
            [muArray addObject:object];
        }else{
            [muArray addObject:object];
            
        }
        return muArray.copy;
    }else{
        if ([self emptyArray:sourceArray]) {
            return @[];
        }
        return sourceArray;
    }
}

/**
 移除源数组index位置上的元素 如果索引越界，就返回源数组，否则返回移除后的数组

 @param index 索引
 @param sourceArray 源数组
 @return 新的数组
 */
- (NSArray *)removeObjectAtIndex:(NSUInteger)index sourceArray:(NSArray *)sourceArray
{
    NSMutableArray *muArray = sourceArray.mutableCopy;
    if (index <= sourceArray.count - 1) {
        [muArray removeObjectAtIndex:index];
        return muArray.copy;
    }else{
        NSLog(@"索引越界了");
        return sourceArray;
    }
}

#pragma mark -------------- NSDictionary --------------

/**
 判断字典是否为空

 @param sourceDictionary 源字典
 @return YES 字典为空
 */
- (BOOL)emptyDictionary:(NSDictionary *)sourceDictionary
{
    if (
        sourceDictionary == nil ||
        sourceDictionary.count == 0 ||
        sourceDictionary.allKeys.count == 0 ||
        [sourceDictionary isKindOfClass:[NSNull class]]
        
        ) {
        return YES;
    }
    return NO;

}




@end
