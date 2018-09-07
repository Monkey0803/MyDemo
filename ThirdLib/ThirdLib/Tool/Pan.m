//
//  Pan.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/8.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "Pan.h"
@interface Pan ()
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) CGPoint PrevisonP;
@end
@implementation Pan

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:pan];
        self.backgroundColor = [UIColor whiteColor];
        _path = [UIBezierPath bezierPath];
    }
    return self;
}

static CGPoint midPoint(CGPoint p0, CGPoint p1)
{
    return (CGPoint) {
        (p0.x + p1.x) / 2,
        (p0.y + p1.y) / 2
    };
}

- (void)pan:(UIPanGestureRecognizer *)sender
{
    CGPoint currnetP = [sender locationInView:self];
    CGPoint midP = midPoint(currnetP, _PrevisonP);
    if (sender.state == UIGestureRecognizerStateBegan) {
        [_path moveToPoint:currnetP];
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        [_path addQuadCurveToPoint:midP controlPoint:_PrevisonP];
    }
    _PrevisonP = currnetP;
    [self setNeedsDisplay];
}

- (void)remove
{
    [_path removeAllPoints];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor redColor] setStroke];
    [_path stroke];
//    [[UIColor yellowColor] setFill];
//    [_path fill];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
