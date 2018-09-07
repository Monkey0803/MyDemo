//
//  XHDebugManager.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/8.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHDebugManager.h"

@implementation XHDebugManager

+ (instancetype)shareDebug
{
    static XHDebugManager *_man = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _man = [XHDebugManager new];
    });
    return _man;
}

/**
 打印某个视图的层级关系

 @param sView 目标视图
 */
- (void)printViewHierarchy:(UIView *)sView
{
    [sView performSelector:NSSelectorFromString(@"recursiveDescription") withObject:nil afterDelay:0.01];
}

/**
 _autolayoutTrace - recursiveDescription的简化版，去掉了UIView的一些描述
 */
- (void)printViewHierarchyTrace
{
    [self performSelector:NSSelectorFromString(@"_autolayoutTrace") withObject:nil afterDelay:0.01];
}

/**
 _printHierarchy － 直接打印所有UIViewController
 */
- (void)printAllViewCHierarchy
{
    [self performSelector:NSSelectorFromString(@"_printHierarchy") withObject:nil afterDelay:0.01];

}

/**
 _ivarDescription - 打印某个对象所有instance的名字和值
 */
- (void)printAllIvarOfInstance
{
    [self performSelector:NSSelectorFromString(@"_ivarDescription") withObject:nil afterDelay:0.01];
    
}


/**
 _methodDescription - 打印某个对象的属性，实例和类方法
*/
- (void)printAllMethodOfInstance
{
    [self performSelector:NSSelectorFromString(@"_methodDescription") withObject:nil afterDelay:0.01];
}
@end
