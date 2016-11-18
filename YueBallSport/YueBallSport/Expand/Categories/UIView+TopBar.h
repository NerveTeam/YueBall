//
//  UIView+TopBar.h
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TintColor  RGBACOLOR(49, 179, 93, 1)
@interface UIView (TopBar)
- (instancetype)topBarWithTintColor:(UIColor *)tintColor
                              title:(NSString *)title
                         titleColor:(UIColor *)titleColor
                           leftView:(UIView *)leftView
                          rightView:(UIView *)rightView
                     responseTarget:(UIViewController *)target;
@end
