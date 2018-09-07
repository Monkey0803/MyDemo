//
//  XHDebugManager.h
//  ThirdLib
//
//  Created by 王博 on 2018/8/8.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//
/*
 使用黑科技（未开发的API🏋🏻‍♂️）调试APP
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XHDebugManager : NSObject
+ (instancetype)shareDebug;

/**
 打印某个视图的层级关系
 
 @param sView 目标视图
 */
- (void)printViewHierarchy:(UIView *)sView;
/**
 _methodDescription - 打印某个对象的属性，实例和类方法
 */
- (void)printAllMethodOfInstance;
/**
 _ivarDescription - 打印某个对象所有instance的名字和值
 */
- (void)printAllIvarOfInstance;
/**
 _printHierarchy － 直接打印所有UIViewController
 */
- (void)printAllViewCHierarchy;
/**
 _autolayoutTrace - recursiveDescription的简化版，去掉了UIView的一些描述
 */
- (void)printViewHierarchyTrace;
@end

NS_ASSUME_NONNULL_END
