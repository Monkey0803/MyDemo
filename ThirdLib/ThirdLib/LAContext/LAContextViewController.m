//
//  LAContext ViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/31.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "LAContextViewController.h"

static NSString * const kEvaluatedPolicyDomainState = @"kEvaluatedPolicyDomainState";

@import LocalAuthentication;
@interface LAContextViewController ()
@property (nonatomic, assign) CGPoint targetPoint;
@end

@implementation LAContextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    UIBarButtonItem *authItem = [[UIBarButtonItem alloc] initWithTitle:@"Auth" style:UIBarButtonItemStyleDone target:self action:@selector(localAuth)];
    self.navigationItem.rightBarButtonItems = @[authItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark -------------- LocalAuthentication --------------

- (void)localAuth
{
    /*
     需要选择LAPolicy，它提供两个值:
     LAPolicyDeviceOwnerAuthenticationWithBiometrics和LAPolicyDeviceOwnerAuthentication.
     <1>. LAPolicyDeviceOwnerAuthenticationWithBiometrics是支持iOS8以上系统,使用该设备的TouchID进行验证,当输入TouchID验证5次失败后,TouchID被锁定,只能通过锁屏后解锁设备时输入正确的解锁密码来解锁TouchID。
     <2>.LAPolicyDeviceOwnerAuthentication是支持iOS9以上系统,使用该设备的TouchID或设备密码进行验证，当输入TouchID验证5次失败后，TouchID被锁定，会触发设备密码页面进行验证
     */
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_0) {
        NSLog(@"系统支持touchID");
        NSError *error = nil;
        LAContext *content = [LAContext new];
        if (@available(iOS 11.0, *)) {
            content.interactionNotAllowed = NO;
        } else {
            // Fallback on earlier versions
        }
//        LAPolicyDeviceOwnerAuthentication 生物识别+密码认证
//        LAPolicyDeviceOwnerAuthenticationWithBiometrics生物识别

        [content canEvaluatePolicy:kLAPolicyDeviceOwnerAuthentication error:&error];
        if (error) {
            if (error.code == kLAErrorBiometryNotEnrolled) {
                NSLog(@"生物（指纹或面部纹理）识别没有录入");

            }else if (error.code == kLAErrorBiometryLockout) {
                NSLog(@"生物识别被锁了");
            }
            
            NSLog(@"%@", error.localizedDescription);
//            return;
        }
        if (@available(iOS 11.0, *)) {
            /*
             只有当canEvaluatePolicy:生物识别策略成功之后才会去设置这个属性的值。简单来说意思就是 biometryType 这个属性的值只有在你调用canEvaluatePolicy:方法之后并且返回是YES没有错误的情况下才会设置，才会有值。在调用 canEvaluatePolicy: 方法前，或者调用后但是有Error的情况下，该属性均无任何有意义的值，验证之后实际为空
            
             链接：https://www.jianshu.com/p/c387614b70ce

             */
            LABiometryType type = content.biometryType;
            NSLog(@"LABiometryType = %ld", type);
        } else {
            // Fallback on earlier versions
        }
        
        NSData *state = (NSData *)[self getObjectByKey:kEvaluatedPolicyDomainState];
        if (![state isEqualToData:content.evaluatedPolicyDomainState]) {
            NSLog(@"指纹改变了");
            [self  userDefaultStoreObject:content.evaluatedPolicyDomainState key:kEvaluatedPolicyDomainState];
        }
        
        
        if (@available(iOS 10.0, *)) {
            content.localizedCancelTitle = @"取消";
        } else {
            // Fallback on earlier versions
        }
        content.localizedFallbackTitle = @"密码输入吧";
        
        [content evaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证指纹登录APP" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"验证成功");
                });
            }else{
                switch (error.code) {
                    case LAErrorPasscodeNotSet:
                        NSLog(@"没有设置密码");
                        break;
                    case LAErrorUserCancel:
                        NSLog(@"用户取消");
                        break;
                    case LAErrorSystemCancel:
                        NSLog(@"系统取消，另外一个APP进入了前台");
                        break;
                    case LAErrorAppCancel:
                        NSLog(@"app取消了");
                        break;
                    case LAErrorUserFallback:
                        NSLog(@"按了输入密码按钮");
                        break;
                    case LAErrorInvalidContext:
                        NSLog(@"违法");
                        break;
                    case LAErrorNotInteractive:
                        NSLog(@"使用了interactionNotAllowed属性");
                        break;
                    case LAErrorBiometryLockout:
                        NSLog(@"持续验证失败，被锁，要求使用密码");
                        break;

                    case LAErrorBiometryNotEnrolled:
                        NSLog(@"生物失败没有录入");
                        break;
                    case LAErrorBiometryNotAvailable:
                        NSLog(@"生物识别不可使用");
                        break;
                        case LAErrorAuthenticationFailed:
                        NSLog(@"授权失败，超过验证次数");
                        break;
                    default:
                        break;
                }
            }
        }];
    }
}

#pragma mark -------------- 存储 --------------

- (void)userDefaultStoreObject:(id)object key:(NSString *)key
{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    [us setObject:object forKey:key];
    [us synchronize];
}

- (id)getObjectByKey:(NSString *)key
{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    id object = [us objectForKey:key];
    return object;
}

- (void)removeObjectByKey:(NSString *)key
{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    [us removeObjectForKey:key];
    [us synchronize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
