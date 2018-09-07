//
//  RedV.m
//  Sort
//
//  Created by 王博 on 2018/6/8.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "RedV.h"

@implementation RedV
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan = %@",[self class]);
    [super touchesBegan:touches withEvent:event];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.userInteractionEnabled || self.hidden || self.alpha <= 0.01) {
        return nil;
    }
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    for (UIView *childV in self.subviews.reverseObjectEnumerator) {
        CGPoint childPoint = [self convertPoint:point toView:childV];
        UIView *fitV = [childV hitTest:childPoint withEvent:event];
        NSLog(@"hitTest = %@",[childV class]);
        if (fitV) {
            
            return fitV;
        }
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
