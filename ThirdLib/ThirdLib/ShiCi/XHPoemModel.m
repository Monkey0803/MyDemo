//
//  XHPoemModel.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/9.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHPoemModel.h"
#import <YYModel/YYModel.h>
@implementation XHPoemModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"apiDocument" : @"api-document"};
}
@end
