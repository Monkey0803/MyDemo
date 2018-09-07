//
//  XHTwoCircleView.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/17.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHTwoCircleView.h"
@interface XHTwoCircleView ()
@property (nonatomic, strong) UILabel *numLabel;
@end
@implementation XHTwoCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.numLabel];
    }
    return self;
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    [self setNeedsDisplay];
}

- (void)setFrontColor:(UIColor *)frontColor
{
    _frontColor = frontColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _numLabel.text = title;
    CGFloat width = (self.frame.size.width - _lineWidth * 2) / 2;
    _numLabel.frame = CGRectMake(_lineWidth, _lineWidth, width, width);
    _numLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.backgroundColor = [UIColor yellowColor];
    _numLabel.backgroundColor = [UIColor blueColor];
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    
    //这里是计算要s显示的那块
    //圆的半径
    CGFloat radius = (self.frame.size.height - _lineWidth * 2) / 2;
    //    圆的周长
    CGFloat perimeter = 2 * M_PI * radius;
    
    //    要画的值
    //计算占比 = 给定的要显示的值（比如100）除以 圆的半周长((perimeter / 2))
    
    CGFloat rate = value / (perimeter);
    _value = rate;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *backPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:(self.frame.size.height - _lineWidth * 2) / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [[UIColor whiteColor] setFill];
    backPath.lineWidth = _lineWidth;

    [_backColor setStroke];
    [backPath fill];
    [backPath stroke];
    
    UIBezierPath *frontPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:(self.frame.size.height - _lineWidth * 2) / 2 startAngle:0 endAngle:2 * _value clockwise:YES];
    [[UIColor whiteColor] setFill];
    [_frontColor setStroke];
    frontPath.lineWidth = _lineWidth;
    [frontPath fill];
    [frontPath stroke];
}

#pragma mark -------------- getter --------------

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.numberOfLines = 2;
        _numLabel.adjustsFontSizeToFitWidth = YES;
        _numLabel.font = [UIFont systemFontOfSize:16];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
