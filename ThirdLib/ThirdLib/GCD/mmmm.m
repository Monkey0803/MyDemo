//
//  mmmm.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/17.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "mmmm.h"

@implementation mmmm

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self pathRadius];
}

- (void)pathRadius
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, 10)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 10, 10)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width - 10, 10 + 10 / 2) radius:5 startAngle:M_PI * 3 / 2 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width - 10, 10 + 10)];
    [path addLineToPoint:CGPointMake(10, 10 + 10)];
    [path addArcWithCenter:CGPointMake(10, 10 + 10 / 2) radius:5 startAngle:M_PI_2 endAngle:M_PI * 3 / 2 clockwise:YES];
    path.lineWidth = 2;
    [[UIColor redColor] setFill];
    [path fill];

}

- (void)pathCircle
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:(self.frame.size.height - 10) / 2 startAngle:M_PI endAngle:0 clockwise:YES];
    path.lineWidth = 3;
    [[UIColor redColor] setStroke];
    [path stroke];
    
    //这里是计算要s显示的那块
    //圆的半径
    CGFloat radius = (self.frame.size.height - 10) / 2;
    //    圆的周长
    CGFloat perimeter = 2 * M_PI * radius;
    
    //    要画的值
    //计算占比 = 给定的要显示的值（比如100）除以 圆的半周长((perimeter / 2))
    CGFloat x = 100.0;
    CGFloat rate = x / (perimeter / 2);
    
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:(self.frame.size.height - 10) / 2 startAngle:M_PI endAngle:M_PI + rate * M_PI clockwise:YES];
    path2.lineWidth = 3;
    [[UIColor blueColor] setStroke];
    [path2 stroke];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
