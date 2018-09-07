//
//  ViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/6/8.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "ViewController.h"
@import MessageUI;

#import "EventBuilder.h"
#import "POPViewController.h"

@interface ViewController ()<MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sendB;
@property (weak, nonatomic) IBOutlet UIButton *popButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _sendB.layer.borderColor = [UIColor yellowColor].CGColor;
    _sendB.layer.borderWidth = .8;
    _sendB.layer.cornerRadius = 10;
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
//    Event *ev = Event.eventBuilder(@"name").needDispatch(true).build();
//    ev.completionBlock();
    
    //定时器
    /*
    __block NSInteger total = 100;
    dispatch_queue_t timerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
            //更新UI
            if (total <= 0) {
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_sendB setTitle:@"时间到" forState:UIControlStateNormal];

                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_sendB setTitle:[NSString stringWithFormat:@"%ld:%ld",total / 60, total % 60] forState:UIControlStateNormal];
                });
                total--;

            }
    });
    
    dispatch_resume(timer);//开启定时器
    */
    

    
    if (@available(iOS 11.0, *)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIEdgeInsets ed = self.view.safeAreaInsets;
            UILayoutGuide *gu = self.view.safeAreaLayoutGuide;
            UIView *blackV = [[UIView alloc] initWithFrame:gu.layoutFrame];
            blackV.backgroundColor = [UIColor blackColor];
//            [self.view addSubview:blackV];
            blackV.tag = 1000;
        });
        

    } else {
        // Fallback on earlier versions
    }
    
    NSBlockOperation *oper = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1");
    }];
//    [oper addExecutionBlock:^{
//        NSLog(@"2");
//    }];
    NSBlockOperation *oper2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3");
    }];
//    [oper start];
//    [oper2 start];
    [oper addDependency:oper2];

    NSOperationQueue *allQueue = [NSOperationQueue new];
    [allQueue addOperation:oper];
    [allQueue addOperation:oper2];
    
    
}

#pragma mark -------------- CADisplayLink --------------
- (void)displayLinker
{
    NSRunLoop *runL = [NSRunLoop mainRunLoop];
    CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTimer:)];
    [dl addToRunLoop:runL forMode:NSRunLoopCommonModes];
    
    if (@available(iOS 10.0, *)) {
        dl.preferredFramesPerSecond = 1;
    } else {
        dl.frameInterval = 60;
    }
}

- (void)displayLinkTimer:(CADisplayLink *)displayLink
{
    if (@available(iOS 10.0, *)) {
        NSLog(@"timestamp = %f, targetTimestamp = %f, duration = %f",displayLink.timestamp, displayLink.targetTimestamp, displayLink.duration);
    } else {
        NSLog(@"timestamp = %f, duration = %f",displayLink.timestamp, displayLink.duration);
    }
    [_sendB setTitle:[NSString stringWithFormat:@"%f, %f", displayLink.timestamp, displayLink.duration] forState:UIControlStateNormal];
    UIColor *textC = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
//    [_sendB setBackgroundColor:textC];
    [_sendB setTitleColor:textC forState:UIControlStateNormal];

}

#pragma mark -------------- CADisplayLink END --------------

- (void)animation
{
    CABasicAnimation *animation = [CABasicAnimation new];
    animation.keyPath = @"position.y";
//    CAValueFunction *fuc = [CAValueFunction functionWithName:kCAValueFunctionScaleY];
//    animation.valueFunction = fuc;
    animation.fromValue = @(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 64);
    animation.toValue = @(CGRectGetHeight(self.view.frame));
//    animation.keyPath = @"size.width";
//    animation.fromValue = @(CGRectGetWidth(_sendB.frame));
//    animation.toValue = @(CGRectGetWidth(self.view.frame));
    animation.duration = 5;
//    animation.removedOnCompletion = NO; //动画完成了是否移除
//    animation.fillMode = kCAFillModeForwards;
//    animation.repeatCount = 10;
    animation.speed = 2;
    animation.autoreverses = YES;
    [_sendB.layer addAnimation:animation forKey:@"size"];
//    _sendB.layer.position = CGPointMake(CGRectGetMinX(_sendB.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(_sendB.frame));
    
    
}

- (void)GCD
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"taskA");
        sleep(10);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"taskB");
        dispatch_semaphore_signal(semaphore);
    });
    //dispatch_apply
    NSArray *array = @[@1, @2, @4];
    dispatch_queue_t queue = dispatch_queue_create("com.hxh.lib", DISPATCH_QUEUE_SERIAL);
    dispatch_apply(array.count, queue, ^(size_t index) {
        
    });
    
    //dispatch_block_t
    dispatch_block_t dsblock = dispatch_block_create(0, ^{
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), dsblock);
    
    //等待block执行完
    dispatch_block_wait(dsblock, DISPATCH_TIME_FOREVER);
    //取消block的执行
    dispatch_block_cancel(dsblock);
    //block执行完收到通知
    dispatch_block_notify(dsblock, queue, ^{
        NSLog(@"执行block完毕");
    });
    
    NSMutableArray *muArray = @[].mutableCopy;
    dispatch_barrier_async(queue, ^{
        [muArray addObject:@"A"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
    });
    dispatch_resume(timer);
}
- (void)viewLayoutMarginsDidChange
{
    UIView *bv = [self.view viewWithTag:1000];
    UIEdgeInsets ed = self.view.safeAreaInsets;
    UILayoutGuide *gu = self.view.safeAreaLayoutGuide;
    if (gu.layoutFrame.size.width > gu.layoutFrame.size.height) {
        bv.backgroundColor = [UIColor redColor];

    }else{
        bv.backgroundColor = [UIColor orangeColor];

    }
    NSLog(@"safeAreaInsets = %@\n,layoutFrame = %@",NSStringFromUIEdgeInsets(ed) ,NSStringFromCGRect(gu.layoutFrame));
    bv.frame = gu.layoutFrame;
    [super viewLayoutMarginsDidChange];
}

#pragma mark -------------- action --------------

- (IBAction)popAction:(UIButton *)sender {
    POPViewController *popVC = [[POPViewController alloc] init];
    [self presentViewController:popVC animated:YES completion:nil];
    
    __weak typeof(self) weakSelf = self;
    popVC.colorBlock = ^(UIColor *radomColor, NSInteger num) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.view.backgroundColor = radomColor;
        NSLog(@"%ld",num);
    };
}
- (IBAction)sendAction:(UIButton *)sender {
    [self animation];
//    [self displayLinker];
    
    return;
    NSInteger type = 3;
    switch (type) {
            case 1://发短信
        {
            [self sendMess];
        }
            break;
            case 2://发邮件
        {
            [self sendMail];
        }
            break;
            case 3://打开地图
        {
            [self openMap];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark -------------- action END --------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------- 发送短信 --------------

- (void)sendMess
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://10010"]];

    NSInteger method = 3;
    switch (method) {
            case 1:
        {
            //方法一。
            if ([MFMessageComposeViewController canSendText]) {//该iOS设备是否支持发送文本短信
                if ([MFMessageComposeViewController canSendSubject]) {//该iOS设备是否支持发送带标题的短信
                    if ([MFMessageComposeViewController canSendAttachments]) {//该iOS设备是否支持发送带附件的短信
                        MFMessageComposeViewController *messVC = [[MFMessageComposeViewController alloc] init];
                        messVC.messageComposeDelegate = self;
                        messVC.recipients = @[@"11111", @"22222"];
                        messVC.body = @"短信内容";
                        messVC.subject = @"主题";
                        messVC.navigationBar.tintColor = [UIColor orangeColor];
                        [self presentViewController:messVC animated:YES completion:nil];
                    }
                }
            }
        }
            break;
            case 2:
        {
            //方法二
            UIWebView *webView = [[UIWebView alloc] init];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];
        }
            break;
            case 3:
        {
            //方法三
            if (@available(iOS 10.0, *)) {
//                url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    
                }];
                
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
        default:
            break;
    }
    

    
    
}
#pragma mark -------------- MFMessageComposeViewControllerDelegate --------------

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
            case MessageComposeResultSent:
        {
            [self showWarn:@"短信发送成功"];
        }
            break;
            case MessageComposeResultFailed:
        {
            [self showWarn:@"短信发送失败"];
        }
            break;
            case MessageComposeResultCancelled:
        {
            [self showWarn:@"短信发送取消"];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark -------------- 发送邮件 --------------

- (void)sendMail
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://10010@126.com"]];
    
    NSInteger method = 1;
    switch (method) {
            case 1:
        {
            //方法一。
            if ([MFMailComposeViewController canSendMail]) {//该iOS设备是否支持发送邮件
                MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                mailVC.mailComposeDelegate = self;
                [mailVC setSubject:@"邮件主题"];
                [mailVC setMessageBody:@"邮件内容" isHTML:NO];
                //设置抄送地址
                [mailVC setCcRecipients:@[@"23@163.com", @"mm@gmail.com"]];
                //设置密送地址
                [mailVC setBccRecipients:@[@"11@126.com", @"123@qq.com"]];
                    mailVC.navigationBar.tintColor = [UIColor orangeColor];
                    [self presentViewController:mailVC animated:YES completion:nil];
            }else{
                NSLog(@"MFMailComposeErrorDomain = %@",MFMailComposeErrorDomain);
            }

        }
            break;
            case 2:
        {
            //方法二
            UIWebView *webView = [[UIWebView alloc] init];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];
        }
            break;
            case 3:
        {
            //方法三
            if (@available(iOS 10.0, *)) {
                //                url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    
                }];
                
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -------------- MFMailComposeViewControllerDelegate --------------

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
            case MFMailComposeResultSent:
        {
            [self showWarn:@"邮件发送成功"];
        }
            break;
            case MFMailComposeResultFailed:
        {
            [self showWarn:@"邮件发送失败"];
        }
            break;
            case MFMailComposeResultCancelled:
        {
            [self showWarn:@"邮件发送取消"];
        }
            break;
            case MFMailComposeResultSaved:
        {
            
        }
            break;
        default:
            break;
    }
    
}



#pragma mark -------------- 打开地图 --------------

- (void)openMap
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Apple Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choiceOpenMap:1];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"高德 Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choiceOpenMap:4];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"百度 Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choiceOpenMap:3];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"腾讯 Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choiceOpenMap:2];
    }]];
    
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

- (void)choiceOpenMap:(NSInteger)type
{
    NSString *str = @"";
    double latitude =45.748737;
    double longitude =126.699791;
    switch (type) {
            case 1://apple
        {
            str = @"http://maps.apple.com/maps?saddr=39.98,116.31&daddr=41.59,117.40";
        }
            break;
            case 2://QQ
        {
            str = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",latitude, longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
            break;
            case 3://baidu
        {
            str = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",latitude,longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        }
            break;
            case 4://高德
        {
            str = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",latitude,longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        }
            break;
        default:
            break;
    }
    NSURL *url = [NSURL URLWithString:str];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)openBaiduMap
{
    
}

#pragma mark -------------- 提示信息 --------------

- (void)showWarn:(NSString *)warnMess
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:warnMess message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }]];
     [self presentViewController:alertVC animated:YES completion:^{
         
     }];
}

- (void)backToVC:(NSString *)VCName animated:(BOOL)animated
{
    if (self.navigationController) {
        NSArray *viewCs = self.navigationController.viewControllers;
        
        NSArray *resluts = [viewCs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject isKindOfClass:NSClassFromString(VCName)];
        }]];
        if (resluts.count > 0) {
            [self.navigationController popToViewController:resluts[0] animated:animated];
        }
    }
}

@end
