//
//  UIViewController+AnimationHUD.m
//  MLTools
//
//  Created by Minlay on 16/9/20.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "UIViewController+AnimationHUD.h"

#define SHOWTAG 1
#define NODATATAG 2
#define LOGINTAG 3
#define RELOADTAG 4
@implementation UIViewController (ShowHUD)

- (void)showHUD {
    [self showHUD:self.view.bounds inView:self.view];
}
- (void)showHUD:(CGRect)frame {
    [self showHUD:frame inView:self.view];
}
- (void)showHUD:(CGRect)frame inView:(UIView *)targetView {
    UIView *mlRefreshView = [targetView viewWithTag:SHOWTAG];
    if (mlRefreshView) {
        [targetView bringSubviewToFront:mlRefreshView];
        return;
    }
    mlRefreshView = [[UIView alloc]initWithFrame:frame];
    mlRefreshView.center = targetView.center;
    mlRefreshView.tag = SHOWTAG;
    mlRefreshView.userInteractionEnabled = NO;
    
    [targetView addSubview:mlRefreshView];
    [targetView bringSubviewToFront:mlRefreshView];
}
@end

@implementation UIViewController (HideHUD)
- (void)removeHUD {
    [self removeHUD:self.view];
}
- (void)removeHUD:(UIView *)targetView {
    if (!targetView) {
        return;
    }
    UIView *mlRefreshView = [targetView viewWithTag:SHOWTAG];
    if (!mlRefreshView) {
        return;
    }
    [mlRefreshView removeFromSuperview];
}
@end

@implementation UIViewController (NoDataHUD)

@end

@implementation UIViewController (ReloadHUD)

@end

@implementation UIViewController (LoginHUD)

@end

@implementation UIViewController (Message)
- (void)showMessage:(NSString *)message {
    CGFloat SCREEN_WIDTH=[[UIScreen mainScreen] bounds].size.width;
    CGFloat SCREEN_HEIGHT=[[UIScreen mainScreen] bounds].size.height;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, SCREEN_HEIGHT/2, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
@end