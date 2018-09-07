//
//  ReplayViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/20.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "ReplayViewController.h"
#import "RefreshTableViewController.h"
#import "XHCanCopyLabel.h"
#import "XHCanCopyImage.h"
#import "XHTool.h"
#import "XHDebugManager.h"


@import ReplayKit;
@interface ReplayViewController ()<RPPreviewViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *discardButton;
@property (weak, nonatomic) IBOutlet UIButton *frontButton;
@property (weak, nonatomic) IBOutlet XHCanCopyLabel *canLabel;
@property (weak, nonatomic) IBOutlet XHCanCopyImage *sourceImage;
@property (weak, nonatomic) IBOutlet XHCanCopyImage *desImage;

@end

@implementation ReplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
//    char *pr = malloc(5);
//    pr[12] = 0;
    const char *pp = "kl"; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *ss = [NSString stringWithUTF8String:pp];
        NSLog(@"ss = %@", ss);
    });
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStyleDone target:self action:@selector(pushAction)];
    if (@available(iOS 12.0, *)) {
        //添加一个view 可以点击录制屏幕
//        RPSystemBroadcastPickerView *view = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(0, 64, 40, 40)];
//        view.backgroundColor = [UIColor redColor];
//        view.showsMicrophoneButton = YES;
//        [self.view addSubview:view];
    } else {
        // Fallback on earlier versions
    }
    NSDecimalNumber *num = DecimalCalculate(@"10", @"21.56", @"*");
    double dd = [num doubleValue];
    NSLog(@"%@, dd = %f", num, dd);

    //加阴影
    _startButton.layer.shadowColor = [UIColor orangeColor].CGColor;
    _startButton.layer.shadowRadius = 4;
    _startButton.layer.shadowOpacity = 0.8;
    _startButton.layer.shadowOffset = CGSizeMake(5, 5);
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(10, 5, 10, 5);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-edgeInset.left, -edgeInset.top, CGRectGetWidth(_startButton.frame) + edgeInset.left + edgeInset.right, CGRectGetHeight(_startButton.frame) + edgeInset.top + edgeInset.bottom)];
    _startButton.layer.shadowPath = path.CGPath;
    
}


/**
 十进制计算

 @param d1 参与计算的NSDecimalNumber1
 @param d2 参与计算的NSDecimalNumber2
 @param calculateType + - * /
 @return NSDecimalNumber
 */
NSDecimalNumber* DecimalCalculate(NSString *d1, NSString *d2, NSString *calculateType)
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:d1 locale:@{NSLocaleDecimalSeparator : @","}];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:d2 locale:@{NSLocaleDecimalSeparator : @","}];
    NSDecimalNumber *result;
    if ([calculateType isEqualToString:@"+"]) {
        result = [num1 decimalNumberByAdding:num2 withBehavior:getDecimalNumberHandler(NSRoundPlain, 2, NO, NO, NO, NO)];
    }else if ([calculateType isEqualToString:@"-"]) {
        result = [num1 decimalNumberBySubtracting:num2 withBehavior:getDecimalNumberHandler(NSRoundPlain, 2, NO, NO, NO, NO)];
    }else if ([calculateType isEqualToString:@"/"]) {
        result = [num1 decimalNumberByDividingBy:num2 withBehavior:getDecimalNumberHandler(NSRoundPlain, 2, NO, NO, NO, NO)];
    }else if ([calculateType isEqualToString:@"*"]) {
        result = [num1 decimalNumberByMultiplyingBy:num2 withBehavior:getDecimalNumberHandler(NSRoundPlain, 2, NO, NO, NO, NO)];
    }
    return result;
}

NSDecimal getDecimal(NSString *sourceStr)
{
    NSDecimal result;
    NSScanner *scanner = [NSScanner scannerWithString:sourceStr];
    [scanner scanDecimal:&result];
    return result;
}

 NSDecimalNumberHandler* getDecimalNumberHandler(NSRoundingMode model, short scale, BOOL exact, BOOL overflow, BOOL underflow, BOOL divideByZero)
{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:model scale:scale raiseOnExactness:exact raiseOnOverflow:overflow raiseOnUnderflow:underflow raiseOnDivideByZero:divideByZero];
    return handler;
}

- (void)pushAction
{
    RefreshTableViewController *replayVC = [[RefreshTableViewController alloc] init];
    [self.navigationController pushViewController:replayVC animated:YES];
}

#pragma mark -------------- RPPreviewViewControllerDelegate --------------

- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet<NSString *> *)activityTypes
{
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        [previewController dismissViewControllerAnimated:YES completion:nil];
    }
   
}

- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController
{
    [previewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)startAction:(UIButton *)sender {

    if ([RPScreenRecorder sharedRecorder].recording) {
        
        return;
    }
    [sender setTitle:@"recording" forState:UIControlStateNormal];
    sender.transform = CGAffineTransformMakeScale(.8, .8);
    [UIView animateWithDuration:.3 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 animations:^{
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
    if (@available(iOS 10.0, *)) {
        [[RPScreenRecorder sharedRecorder] startRecordingWithHandler:^(NSError * _Nullable error) {
            
        }];
    } else {
        // Fallback on earlier versions
    }
}
- (IBAction)stopAction:(UIButton *)sender {
    
    [_startButton setTitle:@"start" forState:UIControlStateNormal];

//    __weak typeof(self) weakSelf = self;
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
//                previewViewController.view.frame = [UIScreen mainScreen].bounds;
//                previewViewController.view.backgroundColor = [UIColor orangeColor];
//                [weakSelf.view addSubview:previewViewController.view];
//                [weakSelf addChildViewController:previewViewController];
                previewViewController.previewControllerDelegate = self;

                [self presentViewController:previewViewController animated:YES completion:^{

                }];
            });

        }
    }];
}
- (IBAction)discardAction:(UIButton *)sender {
    [[RPScreenRecorder sharedRecorder] discardRecordingWithHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_startButton setTitle:@"start" forState:UIControlStateNormal];
        });
    }];
}

- (IBAction)frontAction:(UIButton *)sender {
    
    if (@available(iOS 11.0, *)) {
        if ([RPScreenRecorder sharedRecorder].cameraPosition == RPCameraPositionBack) {
            [RPScreenRecorder sharedRecorder].cameraPosition = RPCameraPositionFront;
        }else{
            [RPScreenRecorder sharedRecorder].cameraPosition = RPCameraPositionBack;
        }
    } else {
        // Fallback on earlier versions
    }
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
