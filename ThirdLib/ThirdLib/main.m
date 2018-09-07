//
//  main.m
//  ThirdLib
//
//  Created by 王博 on 2018/6/8.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        NSInteger num = 10;
        void (^block)(NSInteger a, NSInteger b) = ^(NSInteger a, NSInteger b) {
            NSLog(@"a = %ld, b = %ld", a, b);
            NSLog(@"num = %ld", num);
            
        };
        block(3, 5);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
