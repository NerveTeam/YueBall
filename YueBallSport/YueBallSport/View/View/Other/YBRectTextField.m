//
//  YBRectTextField.m
//  YueBallSport
//
//  Created by Minlay on 16/12/27.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBRectTextField.h"

@implementation YBRectTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, RGBACOLOR(235, 235, 235, 1).CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 30, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
    return inset;
}
//-(CGRect)textRectForBounds:(CGRect)bounds
//{
//    CGRect inset = CGRectMake(bounds.origin.x + 190, bounds.origin.y, bounds.size.width -10, bounds.size.height);
//    
//    return inset;
//    
//}
//控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 30, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
    return inset;
}
@end
