//
//  YBUnderLineLabel.m
//  YueBallSport
//
//  Created by Minlay on 16/12/28.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBUnderLineLabel.h"

@implementation YBUnderLineLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, RGBACOLOR(107, 107, 107, 1).CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
