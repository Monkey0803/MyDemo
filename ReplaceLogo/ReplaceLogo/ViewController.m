//
//  ViewController.m
//  ReplaceLogo
//
//  Created by 王博 on 2018/2/7.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *iconB;
@property (nonatomic, strong) UILabel *iconLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 100, 60)];
    _iconLabel.font = [UIFont fontWithName:@"iconfont" size:20];
//    _iconLabel.text = @"\U0000e77f \U0000e65c";
//    _iconLabel.text = @"\U0000e65c";
    _iconLabel.text = @"#icon-AppStore";
   [self.view addSubview:_iconLabel];
}
- (IBAction)changIcon:(UIButton *)sender {
    if (@available(iOS 10.3, *)) {
        BOOL supports = [[UIApplication sharedApplication] supportsAlternateIcons];
        if (supports) {
            [[UIApplication sharedApplication] setAlternateIconName:@"晴天" completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"替换失败");
                }else{
//                    UILocalNotification *loc = [[UILocalNotification alloc] init];
////                    loc.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
//                    loc.alertBody = @"icon改变了";
//                    loc.alertTitle = @"icon";
//                    loc.alertAction = @"tap me";
//                    loc.alertLaunchImage = @"晴20x20";
//                    [[UIApplication sharedApplication] scheduleLocalNotification:loc];
                    NSString *file = [[NSBundle mainBundle] pathForResource:@"000VWEXSlx07kJynDHgY01040200cGTu0k010.mp4" ofType:nil];
                    NSURL *fileUrl = [NSURL fileURLWithPath:file];
                    NSDictionary *muDic = @{
                                                   UNNotificationAttachmentOptionsTypeHintKey : (__bridge NSString *)(kUTTypeMPEG4),
                                                   UNNotificationAttachmentOptionsThumbnailTimeKey : (@10),
                                                   UNNotificationAttachmentOptionsThumbnailHiddenKey : @NO,
                                                   UNNotificationAttachmentOptionsThumbnailClippingRectKey : (__bridge id _Nullable)(CGRectCreateDictionaryRepresentation(CGRectMake(0, 0, 1, 1))),
                                                   
                                                   };
                    UNNotificationAttachment *attach = [UNNotificationAttachment attachmentWithIdentifier:@"attach" URL:fileUrl options:muDic error:nil];
                    
                    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                    
                    content.attachments = @[attach];
                    content.badge = @10;
                    content.body = @"icon改变了";
                    content.sound = [UNNotificationSound defaultSound];
                    content.title = @"icon";
                    //关于通知的介绍
//                    https://www.jianshu.com/p/3d602a60ca4f
                    UNTimeIntervalNotificationTrigger *tirrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
                    /*
                     上面的方法是指5秒钟之后执行。repeats这个属性，如果需要为重复执行的，则TimeInterval必须大于60s,否则会报*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'time interval must be at least 60 if repeating'的错误!
                     */

                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"icon" content:content trigger:tirrigger];
                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                        
                    }];
                }
            }];
        }
    } else {
        // Fallback on earlier versions
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
