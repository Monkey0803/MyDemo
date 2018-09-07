//
//  XHPoemCollectionViewCell.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/9.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "XHPoemCollectionViewCell.h"
#import <Shimmer/FBShimmeringView.h>
@interface XHPoemCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end
@implementation XHPoemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        FBShimmeringView *shimmerView = [[FBShimmeringView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:shimmerView];
        shimmerView.shimmering = YES;
        shimmerView.contentView = self.nameLabel;

        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

#pragma mark -------------- setter --------------

- (void)setNameStr:(NSString *)nameStr
{
    _nameStr = nameStr;
    _nameLabel.text = nameStr;
    
}

#pragma mark -------------- getter --------------

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _nameLabel.font = [UIFont italicSystemFontOfSize:16];
        _nameLabel.textColor = [UIColor orangeColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        
        _nameLabel.layer.cornerRadius = 4;
        _nameLabel.layer.borderWidth = .5;
        _nameLabel.layer.borderColor = [UIColor colorWithRed:((arc4random() % 255) / 255.0) green:((arc4random() % 255) / 255.0) blue:((arc4random() % 255) / 255.0)  alpha:1].CGColor;
        _nameLabel.layer.masksToBounds = YES;
    }
    return _nameLabel;
}

@end
