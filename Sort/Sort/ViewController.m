//
//  ViewController.m
//  Sort
//
//  Created by 王博 on 2018/5/31.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *blackV;
@property (weak, nonatomic) IBOutlet UIView *yellowV;
@property (weak, nonatomic) IBOutlet UIView *redV;
@property (weak, nonatomic) IBOutlet UIView *whiteV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *aa = bubble_sort(@[@100,@4,@2,@2,@5,@7,@10,@73,@52], YES);

    NSInteger dd = gcd(3, 88);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/**
 冒泡排序

 @param array 待排序
 @param max_pre YES 最大值在前
 @return 排序后
 */
NSArray * bubble_sort(NSArray *array, bool max_pre)
{
    NSInteger count = 0;
    NSMutableArray *muArray = array.mutableCopy;
    for (NSInteger i = 0; i < muArray.count; i++) {
        for (NSInteger j = i; j < muArray.count; j++) {
            if (max_pre) {//降序
                if ([muArray[i] integerValue] < [muArray[j] integerValue]) {
                    NSNumber *temp = muArray[i];
                    muArray[i] = muArray[j];
                    muArray[j] = temp;
                    count ++;
                }
            }else{//升序
                if ([muArray[i] integerValue] > [muArray[j] integerValue]) {
                    NSNumber *temp = muArray[i];
                    muArray[i] = muArray[j];
                    muArray[j] = temp;
                    count ++;
                }
            }
            
        }
    }
    
    NSLog(@"count = %ld",count);
    return muArray.copy;
}
NSInteger gcd(NSInteger a, NSInteger b)
{
    NSInteger temp = 0;
    if (a < b) {
        temp = a;
        a = b;
        b = temp;
    }
    if (b != 0) {
        temp = a % b;
        a = b;
        b = temp;
    }
    return a;
}


@end
