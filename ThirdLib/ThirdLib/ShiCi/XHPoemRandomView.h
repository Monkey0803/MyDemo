//
//  XHPoemRandomView.h
//  ThirdLib
//
//  Created by 王博 on 2018/8/9.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Shimmer/FBShimmeringView.h>
#import "XHPoemRandomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XHPoemRandomView : FBShimmeringView
@property (nonatomic, strong) XHPoemRandomModel *model;
@end

NS_ASSUME_NONNULL_END
