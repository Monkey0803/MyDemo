//
//  XHPoemRandomView.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/9.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHPoemRandomView.h"
#import <KLCPopup/KLCPopup.h>
@interface XHPoemRandomView ()
@property (nonatomic, strong) UILabel *nameLabel;

@end
@implementation XHPoemRandomView

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;

        
        self.contentView = self.nameLabel;
        self.shimmeringDirection = FBShimmerDirectionUp;
        self.shimmering = YES;
    }
    return self;
}

- (void)setModel:(XHPoemRandomModel *)model
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@", model.content, model.origin, model.author, model.category];

    KLCPopup *pop = [KLCPopup popupWithContentView:self showType:KLCPopupShowTypeShrinkIn dismissType:KLCPopupDismissTypeShrinkOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:YES];
    [pop show];
}

#pragma mark -------------- getter --------------
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _nameLabel.font = [UIFont italicSystemFontOfSize:24];
        _nameLabel.textColor = [UIColor orangeColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = [UIColor blackColor];
    }
    return _nameLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
