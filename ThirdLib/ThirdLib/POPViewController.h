//
//  POPViewController.h
//  ThirdLib
//
//  Created by 王博 on 2018/6/25.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionBlock)(UIColor *radomColor, NSInteger num);
@interface POPViewController : UIViewController

@property (nonatomic, copy) CompletionBlock colorBlock;
@end
