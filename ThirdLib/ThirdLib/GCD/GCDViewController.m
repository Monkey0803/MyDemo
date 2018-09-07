//
//  GCDViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/19.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "GCDViewController.h"
#import "ReplayViewController.h"
#import "mmmm.h"
#import "XHTwoCircleView.h"


@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self wait3];
    [self formatter];
    [self layer];  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------- <#mark#> --------------

- (void)layer
{
//    mmmm *mm = [[mmmm alloc] initWithFrame:CGRectMake(10, 100, 200, 80)];
//    [self.view addSubview:mm];
    
    XHTwoCircleView *twoView = [[XHTwoCircleView alloc] initWithFrame:CGRectMake(10, 100, 150, 150)];
    twoView.frontColor = [UIColor redColor];
    twoView.backColor = [UIColor orangeColor];
    twoView.lineWidth = 20;
    twoView.title = @"89/20 文档";
    twoView.value = 180;
    [self.view addSubview:twoView];
  
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.frame = self.view.frame;
//
//    layer.fillColor = [UIColor redColor].CGColor;
//    layer.strokeColor = [UIColor blueColor].CGColor;
//    layer.lineWidth = 3;
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.frame.size.width / 2, 200) radius:30 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//
//
//    [path fill];
//    [path stroke];
//    layer.path = path.CGPath;
//    [self.view.layer addSublayer:layer];
    
}


#pragma mark -------------- 夏令时 --------------

- (void)formatter
{
    /*
     「 关于NSDate中夏令时的坑」
     
     举个例子：
     NSString *birthDay = @"1986-05-04";
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"yyyy-MM-dd"];
     NSDate *date = [formatter dateFromString: birthDay];
     
     你会发现，1986-05-04这个日期拿到的date是null，测几个其他的生日，发现上面这串代码又是ok的。经查找资料，发现是因为夏令时引起的原因。关于夏令时的解释，由于篇幅限制这边就不再赘述，可自行百度。夏令时时间段如下：
     
     1986年4月13日至9月14日
     1987年4月12日至9月13日
     1988年4月10日至9月11日
     1989年4月16日至9月17日
     1990年4月15日至9月16日
     1991年4月14日至9月15日
     
     经过多次测试，这其中有些日子是可以转化为NSDate的。由于没有做覆盖测试，目前只发现了6个日期会有问题，可能会有更多。 1986-05-04, 1987-04-12, 1988-04-10, 1989-04-16, 1990-04-15，1991-04-14。
     
     解决方案：
     1、使用GMT零时区
     [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
     
     2、设置lenient属性
     formatter.lenient = YES;
     关于lenient，这个属性没有官方的解释，个人理解为：如果当前时间不存在的话，会默认获取距离最近的整点时间。
     
     以上两种方法，择一即可。

     */
    NSString *timerS = @"1987-04-12";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    [formatter setTimeZone:timeZone];
//    formatter.lenient = YES;//这个字段设置为YES 系统会自动去推断可能的值，会有差别
    NSDate *date = [formatter dateFromString:timerS];
//    NSString *reslut =  [timeZone abbreviationForDate:date];
    NSLog(@"%@", date);
    
}



- (void)wait
{
    //加入到group
    /*
     线程同步 -- 组队列（dispatch_group）。
     先建一个全局队列queue，并新建一个group(用dispatch_group_create())，然后向Group Queue依次追加block，最后用dispatch_group_notify添加block。当前面的block全部执行完，就会执行最后的block
     说明：如果队列queue是 DISPATCH_QUEUE_SERIAL （串行），就会一次执行 group中的任务 ，等group中的任务都执行完毕了，就会dispatch_group_notify执行里面的block
          如果队列queue是 DISPATCH_QUEUE_CONCURRENT (并行),加到group中的任务就会不按照添加顺序执行 ，而是利用多线程进行并行执行，等group中的任务都执行完毕了，就会dispatch_group_notify执行里面的block
     */
    dispatch_queue_t queue = dispatch_queue_create("const char * _Nullable label", DISPATCH_QUEUE_SERIAL);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"执行任务1");
        NSLog(@"thread name = %@", [NSThread currentThread].name);
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"执行任务2");
        NSLog(@"thread name = %@", [NSThread currentThread].name);
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"执行任务3");
        NSLog(@"thread name = %@", [NSThread currentThread].name);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"group中的任务都执行完成后执行");
        NSLog(@"thread name = %@", [NSThread currentThread].name);
    });
    
}

- (void)wait2
{
    /*
     线程同步 --任务阻塞（dispatch_barrier）。
     通过dispatch_barrier_async添加的操作会暂时阻塞当前队列，即等待前面的并发操作都完成后执行该阻塞操作，待其完成后后面的并发操作才可继续。使用dispatch_barrier_async可以实现类似组队列的效果
     */
    /*
     说明：如果队列queue是 DISPATCH_QUEUE_SERIAL （串行），就会依次执行任务，不会起到阻塞的作用
     如果队列queue是 DISPATCH_QUEUE_CONCURRENT (并行), 最后才会执行dispatch_barrier_async的任务
     */
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    queue = dispatch_queue_create("const char * _Nullable label", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"任务1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"任务2");
    });
    //添加barrier障碍操作，会等待前面的操作结束，并暂时阻塞后面的操作直到其完成
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"前面的任务已经执行完毕,可以执行本次任务了");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"任务3");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"任务4");
    });
}
- (void)wait3
{
    /*
     线程同步 -- 信号量机制（dispatch_semaphore）。
     除了任务阻塞，还可以利用信号量实现这种阻塞效果：在异步开启任务1和任务2之前，初始化一个信号量并设置为0，然后在任务1的block中写好请求操作，操作执行完后对前面的信号量加1，在任务2的block中，需要在开始请求之前加上等待信号量的操作。这样一来，只有任务1中的请求执行完后，任务2等到了信号量加1才接着执行它的请求
     */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_queue_t queue = dispatch_queue_create("const char * _Nullable label", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"任务1开始");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务1结束");
        //任务1 结束，发送信号量任务2就可以开始执行了
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(queue, ^{
        //等待任务获得信号量，无限等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务2开始");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务2结束");
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(queue, ^{
        //等待获得信号量，无限等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务3开始");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"任务3结束");
        dispatch_semaphore_signal(semaphore);
    });
    NSLog(@"NBA");
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
