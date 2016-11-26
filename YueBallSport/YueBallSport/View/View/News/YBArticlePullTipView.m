//
//  SPArticlePullTipView.m
//  sinaSports
//
//  Created by 磊 on 16/6/21.
//  Copyright © 2016年 sina.com. All rights reserved.
//

#import "YBArticlePullTipView.h"
#import "UILabel+Extention.h"
@interface YBArticlePullTipView ()
@property(nonatomic, strong)UIImageView *tipView;
@property(nonatomic, strong)UILabel *tipLabel;
@end
@implementation YBArticlePullTipView


- (void)updateTipStyle:(PullTipStyle)style {
    if (style == PullTipStyleDefault) {
        self.tipView.image = [UIImage imageNamed:@"release-ic-close.png"];
        [self.tipView sizeToFit];
        self.tipLabel.text = @"上拉关闭当前页";
    }
    else {
        self.tipView.image = [UIImage imageNamed:@"pullup-ic-close.png"];
        [self.tipView sizeToFit];
        self.tipLabel.text = @"释放关闭当前页";

    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    [self addSubview:self.tipView];
    [self addSubview:self.tipLabel];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(-50);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.tipView.mas_right).offset(10);
    }];
}

- (UIImageView *)tipView {
    if (!_tipView) {
        _tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"release-ic-close.png"]];
        [_tipView sizeToFit];
    }
    return _tipView;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithText:@"上拉关闭当前页" fontSize:13 textColor:RGBACOLOR(153, 153, 153, 1)];
    }
    return _tipLabel;
}
@end
