//
//  YBUnderlineTextField.m
//  YueBallSport
//
//  Created by Minlay on 16/12/26.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBUnderlineTextField.h"

@implementation YBUnderlineTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, RGBACOLOR(235, 235, 235, 1).CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
