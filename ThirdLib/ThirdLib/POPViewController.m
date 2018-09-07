//
//  POPViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/6/25.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "POPViewController.h"
@import iRate.iRate;

@import pop.POP;
@import GLKit;
@import Metal;

#import "NSTimer+XH_Helper.h"
#import "XHWeakTimer.h"
#define RandomColor [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:.8]

@interface POPViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *backB;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation POPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.backB];

//    __weak typeof(self) weakSelf = self;
//    _timer = [NSTimer xh_scheduledTimerWithTimeInterval:4 block:^{
//        NSLog(@"%f",weakSelf.timer.timeInterval);//这样不会造成循环引用
////        NSLog(@"%f",_timer.timeInterval);//这样会造成循环引用
//    } repeats:YES];
    
//    [XHWeakTimer scheduledTimerWithTimeInterval:5 block:^(id userInfo) {
//        NSLog(@"%@",userInfo);
//    } userInfo:@{@"nba" : @"20", @"cba" : @"10"} repeats:YES];
    
//    [XHWeakTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(log:) userInfo:@{@"nba" : @"20", @"cba" : @"10"} repeats:YES];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(log:) userInfo:@{@"nba" : @"20", @"cba" : @"10"} repeats:YES];
    
    BOOL (^YOrN)(int) = ^(int input) {
        if (input % 2 == 0) {
            return YES;
        }else {
            return NO;
        }
    };
    
//    BOOL x = YOrN(10);
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
//    [_timer invalidate];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)log:(NSTimer *)timer
{
    NSLog(@"%@",timer.userInfo);
}

#pragma mark -------------- action --------------

- (void)tapL
{
    [self pop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        POPSpringAnimation *s = [self->_label pop_animationForKey:@"addSpringA"];
        if (s) {
            s.toValue = [NSValue valueWithCGRect:CGRectMake(80, 200, 100, 100)];
        }else{
            
        }
    });
}

- (void)backAction
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        !strongSelf->_colorBlock ?: strongSelf->_colorBlock(RandomColor, 10);
    }];
}
#pragma mark -------------- pop --------------

- (void)pop
{
    POPSpringAnimation *springA = [POPSpringAnimation animation];
//    springA.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
//    springA.toValue = [NSValue valueWithCGRect:CGRectMake(10, 80, 100, 100)];
    springA.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];

    springA.toValue = [NSValue valueWithCGPoint:CGPointMake(.5, .5)];
    springA.name = @"frame";
    springA.springBounciness = 10;
    [_label pop_addAnimation:springA forKey:@"addSpringA"];
    
    
    
    
   
    
   
}



#pragma mark -------------- getter --------------

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, CGRectGetWidth(self.view.frame) - 80 * 2, 200)];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:20];
        _label.textColor = RandomColor;
        _label.text = @"arc4random";
        _label.layer.cornerRadius = 4;
        _label.layer.borderColor = RandomColor.CGColor;
        _label.layer.borderWidth = 1;
        _label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapL)];
        [_label addGestureRecognizer:tap];
    }
    return _label;
}

- (UIButton *)backB
{
    if (!_backB) {
        _backB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backB setTitle:@"back" forState:UIControlStateNormal];
        _backB.frame = CGRectMake(10, 30, 80, 40);
        _backB.layer.cornerRadius = 4;
        _backB.layer.borderColor = RandomColor.CGColor;
        _backB.layer.borderWidth = 1;
        [_backB setTitleColor:RandomColor forState:UIControlStateNormal];
        [_backB addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backB;
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
