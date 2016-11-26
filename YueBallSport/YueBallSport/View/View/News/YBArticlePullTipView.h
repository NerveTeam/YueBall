//
//  SPArticlePullTipView.h
//  sinaSports
//
//  Created by 磊 on 16/6/21.
//  Copyright © 2016年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>


static const CGFloat EdgeValue = 100;

typedef NS_ENUM(NSInteger, PullTipStyle) {
    PullTipStyleDefault,
    PullTipStyleClose
};
@interface YBArticlePullTipView : UIView
/**
 *  关闭此页更新状态
 *
 *  @param style 状态
 */
- (void)updateTipStyle:(PullTipStyle)style;
@end
