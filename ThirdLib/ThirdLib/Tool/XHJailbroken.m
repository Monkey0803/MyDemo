//
//  XHJailbroken.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/8.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHJailbroken.h"
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
@implementation XHJailbroken
+ (BOOL)isJailBroken
{
    /*
     首先，你可以尝试使用NSFileManager判断设备是否安装了如下越狱常用工具：
     /Applications/Cydia.app
     /Library/MobileSubstrate/MobileSubstrate.dylib
     /bin/bash
     /usr/sbin/sshd
     /etc/apt
     
     
     但是不要写成BOOL开关方法，给攻击者直接锁定目标hook绕过的机会
     */
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        return YES;
    }else{
        //你可以尝试打开cydia应用注册的URL scheme：
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]) {
            NSLog(@"Device is jailBroken");
            return YES;
        }else{
            //不是所有的工具都会注册URL scheme，而且攻击者可以修改任何应用的URL scheme
            //你可以尝试读取下应用列表，看看有无权限获取
            if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
                NSLog(@"Device is jailbroken");
                NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/User/Applications/"
                                                                                       error:nil];
                NSLog(@"applist = %@",applist);
                return YES;
            }
            return NO;
        }
        return NO;
    }
    
}


/**
 可以回避 NSFileManager，使用stat系列函数检测Cydia等工具
 */
void checkCydia(void){
    struct stat stat_info;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        NSLog(@"Device is jailbroken");
    }
}

/**
 可以看看stat是不是出自系统库，有没有被攻击者换掉
 */
void checkInjection(void){
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char *, struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        NSLog(@"lib :%s", dylib_info.dli_fname);
    }
    //如果结果不是 /usr/lib/system/libsystem_kernel.dylib 的话，那就100%被攻击了。

}

/**
 你可能会想，我该检索一下自己的应用程序是否被链接了异常动态库
 */
void checkDylib(void) {
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; ++i) {
        NSString *name = [NSString stringWithUTF8String:_dyld_get_image_name(i)];
        NSLog(@"%@", name);
    }
    //通常情况下，会包含越狱机的输出结果会包含字符串： Library/MobileSubstrate/MobileSubstrate.dylib
}

/**
 攻击者可能会给MobileSubstrate改名，但是原理都是通过DYLD_INSERT_LIBRARIES注入动态库
 可以通过检测当前程序运行的环境变量
 */
void printENV(void) {
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    NSLog(@"%s", env);
//    未越狱设备返回结果是null
}

@end
