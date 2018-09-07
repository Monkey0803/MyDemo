//
//  XHCanCopyLabel.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/31.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHCanCopyLabel.h"

@implementation XHCanCopyLabel

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
//    UIMenuItem *pasteItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(pasteAction)];
//    UIMenuItem *cutItem = [[UIMenuItem alloc] initWithTitle:@"剪切" action:@selector(cutAction)];
//    UIMenuItem *pasteItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(pasteAction)];
//    UIMenuItem *cutItem = [[UIMenuItem alloc] initWithTitle:@"剪切" action:@selector(cutAction)];
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
        action == @selector(paste:) ||
        action == @selector(delete:) ||
        action == @selector(select:) ||
        action == @selector(selectAll:)
        )
    {
        return YES;
    }
    return NO;
}

- (void)copy:(id)sender
{
    [UIPasteboard generalPasteboard].string = self.text;
}

- (void)cut:(id)sender
{
    [UIPasteboard generalPasteboard].string = self.text;
    self.text = nil;
}

- (void)paste:(id)sender
{
    self.text = [UIPasteboard generalPasteboard].string;
}

- (void)delete:(id)sender
{
    self.text = nil;
}

- (void)selectAll:(id)sender
{
    
}

- (void)select:(id)sender
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
