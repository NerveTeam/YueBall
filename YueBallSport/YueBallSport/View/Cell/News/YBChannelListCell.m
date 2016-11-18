//
//  SPFollowHomeListCell.m
//  sinaSports
//
//  Created by 磊 on 15/12/29.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import "YBChannelListCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+Extention.h"
#define longPressColor RGBACOLOR(236, 236, 236, 1)
@interface YBChannelListCell ()
// 球队icon
@property(nonatomic, strong)UIImageView *teamIcon;
@property(nonatomic, strong)UILabel *teamName;
@property(nonatomic, strong)CALayer *separateLine;
@end
@implementation YBChannelListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}


#pragma mark - init
- (void)setUpUI {
    [self.contentView addSubview:self.teamIcon];
    [self.contentView addSubview:self.teamName];
    [self.contentView.layer addSublayer:self.separateLine];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:gesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.teamIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.centerX.equalTo(self.contentView);
    }];
    [self.teamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.teamIcon.mas_bottom).offset(5);
    }];
}


- (void)setModel:(id)model {
    _teamIcon.image = nil;
    self.teamIcon.image = [UIImage imageNamed:[model objectForKey:@"icon"]];
    self.teamName.text = [model objectForKey:@"title"];
}

- (void)longPress:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.backgroundColor = longPressColor;
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        self.backgroundColor = [UIColor whiteColor];
    }
}
#pragma mark - lazy
// 球队icon
- (UIImageView *)teamIcon {
    if (!_teamIcon) {
        _teamIcon = [[UIImageView alloc]init];
    }
    return _teamIcon;
}
- (UILabel *)teamName {
    if (!_teamName) {
        _teamName = [UILabel labelWithText:nil fontSize:15];
    }
    return _teamName;
}
- (CALayer *)separateLine {
    if (!_separateLine) {
        _separateLine = [CALayer layer];
        _separateLine.backgroundColor = [UIColor lightGrayColor].CGColor;
        CGFloat height = 30;
        CGFloat Y = (self.contentView.height - height) / 2;
        _separateLine.frame = CGRectMake(self.contentView.width - 1, Y, 1, height);
    }
    return _separateLine;
}
@end
