//
//  ReplayViewController.h
//  ThirdLib
//
//  Created by 王博 on 2018/7/20.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReplayViewController : BaseViewController
FOUNDATION_EXPORT NSDecimalNumberHandler* getDecimalNumberHandler(NSRoundingMode model, short scale, BOOL exact, BOOL overflow, BOOL underflow, BOOL divideByZero);
FOUNDATION_EXPORT NSDecimal getDecimal(NSString *sourceStr);
/**
 十进制计算
 
 @param d1 参与计算的NSDecimalNumber1
 @param d2 参与计算的NSDecimalNumber2
 @param calculateType + - * /
 @return NSDecimalNumber
 */
FOUNDATION_EXPORT NSDecimalNumber* DecimalCalculate(NSString *d1, NSString *d2, NSString *calculateType);
@end

NS_ASSUME_NONNULL_END
