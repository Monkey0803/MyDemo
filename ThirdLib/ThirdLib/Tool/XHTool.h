//
//  XHTool.h
//  ThirdLib
//
//  Created by 王博 on 2018/8/7.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHTool : NSObject

+ (instancetype)shareTool;

- (void)removeAllNoti;

#pragma mark -------------- array --------------

/**
 判断数组是否为空
 
 @param sourceArray 源数组
 @return YES 数组为空
 */
- (BOOL)emptyArray:(NSArray *)sourceArray;

/**
 给源数组添加一个元素，当源数组没有初始化，对源数组进行初始化，在添加元素
 
 @param object 被添加的元素
 @param sourceArray 源数组
 @return 新的数组
 */
- (NSArray *)addNilObject:(id)object sourceArray:(NSArray *)sourceArray;

/**
 移除源数组index位置上的元素 如果索引越界，就返回源数组，否则返回移除后的数组
 
 @param index 索引
 @param sourceArray 源数组
 @return 新的数组
 */
- (NSArray *)removeObjectAtIndex:(NSUInteger)index sourceArray:(NSArray *)sourceArray;

#pragma mark -------------- NSDictionary --------------

/**
 判断字典是否为空
 
 @param sourceDictionary 源字典
 @return YES 字典为空
 */
- (BOOL)emptyDictionary:(NSDictionary *)sourceDictionary;

@end

NS_ASSUME_NONNULL_END
