//
//  AppDelegate.m
//  ThirdLib
//
//  Created by 王博 on 2018/6/8.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDBViewController.h"
#import "LocationViewController.h"
#import "RefreshTableViewController.h"
#import "PayViewController.h"
#import "GCDViewController.h"
#import "ReplayViewController.h"
#import "LAContextViewController.h"
#import "XHPoemViewController.h"
@interface AppDelegate ()
@property (nonatomic, assign) NSInteger *count;
@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIden;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[GCDViewController alloc] init]];
    self.window.rootViewController = nav;
    //设置最小后台获取时间间隔
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)countAction:(NSTimer *)timer
{
    _count++;
    NSLog(@"_count = %ld", _count);
    if (_count > 100) {
        [_timer invalidate];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    [self beginBackgroundTask];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countAction:) userInfo:nil repeats:YES];
    });
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countAction:) userInfo:nil repeats:YES];

//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        static NSInteger i = 0;
//        while (i < 10) {
////            NSLog(@"backgroundTimeRemaining = %f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
//            NSLog(@"i = %ld", i);
//            [NSThread sleepForTimeInterval:1];
//            i++;
//        }
//        [self endBackgroundTask];
//    });
    
    [self endBackgroundTask];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -------------- 后台获取  --------------
/*
 后台获取是IOS7新增内容，它的核心作用是设定一个间隔，然后每隔一段时间唤醒应用处理相应地任务，比如我们使用的社交软件，可以每个一定时间获取最新的信息，这样下次我们进入后就不需要等待刷新，使用后台获取的步骤如下：
 
 1：添加应用对后台获取的支持，可以在plist文件中修改UIBackgroundMode一项，增加fetch，或者在应用信息的capabilities->background modes中勾选background fetch
 2：设置最小后台获取时间间隔
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
 return YES;
 }
 如果不设置的话默认为UIApplicationBackgroundFetchIntervalNever，表示不获取，而且这个值代表"最小"后台获取时间间隔，这里所指定的时间间隔只是代表了“在上一次获取或者关闭应用之后，在这一段时间内一定不会去做后台获取”，IOS并不会为了每一个应用频频唤醒CPU，具体唤醒时间得看系统调度，设置为UIApplicationBackgroundFetchIntervalMinimum表示尽可能的对我们的应用进行后台唤醒，这样设置的缺点是耗电。
 3：实现application:performFetchWithCompletionHandler
 */

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cnblogs.com/zanglitao/"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [task resume];
}

#pragma mark -------------- 后台任务 --------------

- (void)beginBackgroundTask
{
    _taskIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask];
    }];
}

- (void)endBackgroundTask
{
    [[UIApplication sharedApplication] endBackgroundTask:_taskIden];
    _taskIden = UIBackgroundTaskInvalid;
}


@end
