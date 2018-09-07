//
//  XHTwoCircleView.h
//  ThirdLib
//
//  Created by 王博 on 2018/8/17.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHTwoCircleView : UIView
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *frontColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
