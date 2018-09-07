//
//  XHCanCopyImage.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/31.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHCanCopyImage.h"

@implementation XHCanCopyImage

- (void)awakeFromNib
{
    [self canTap];
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self canTap];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        [self canTap];
    }
    return self;
}

- (void)canTap
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
}

#pragma mark -------------- tapAction --------------
- (void)showMenu
{
    [self becomeFirstResponder];
    UIMenuController *mc = [UIMenuController sharedMenuController];
    mc.arrowDirection = UIMenuControllerArrowUp;
    [mc setTargetRect:self.frame inView:self.superview];
    [mc setMenuVisible:YES animated:YES];
}

#pragma mark -------------- overread --------------

//首先要成为第一响应者
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//响应对应的操作
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:) ||
        action == @selector(paste:)
        )
    {
        return YES;
    }
    return NO;
}

- (void)copy:(id)sender
{
    [UIPasteboard generalPasteboard].image = self.image;
    NSLog(@"strings = %@", [UIPasteboard generalPasteboard].strings);
    NSLog(@"strings = %@", [UIPasteboard generalPasteboard].images);
    NSLog(@"URLs = %@", [UIPasteboard generalPasteboard].URLs);
    NSLog(@"colors = %@", [UIPasteboard generalPasteboard].colors);
}

- (void)paste:(id)sender
{
    self.image = [UIPasteboard generalPasteboard].image;
}

@end
