//
//  YBArticleViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/14.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBArticleViewController.h"
#import "YBArticleRequestDelegate.h"

@interface YBArticleViewController ()

@end

@implementation YBArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}

/**
 *  配置相关
 */
- (void)config {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.delegate = nil;
    self.baseDelegate = [[YBArticleRequestDelegate alloc]init];
    self.actionDelegate = self;
    self.webView.frame = CGRectMake(0,
                                    44,
                                    self.view.width,
                                    self.view.height - kTabBarHeight);
}
@end
