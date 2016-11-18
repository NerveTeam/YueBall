//
//  YBArticleViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/14.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBArticleViewController.h"
#import "YBArticleRequestDelegate.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"

@interface YBArticleViewController ()

@property(nonatomic, strong)UIView *topBar;
@property(nonatomic, strong)UIButton *backItem;
@property(nonatomic, strong)UIButton *shareItem;
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
    self.navigationController.delegate = nil;
    self.baseDelegate = [[YBArticleRequestDelegate alloc]init];
    self.actionDelegate = self;
    self.webView.frame = CGRectMake(0,
                                    self.topBar.height,
                                    self.view.width,
                                    self.view.height - self.topBar.height);
}

#pragma mark - lazy
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBar = [_topBar topBarWithTintColor:nil title:nil titleColor:nil leftView:self.backItem rightView:self.shareItem responseTarget:self];
        [self.view addSubview:_topBar];
    }
    return _topBar;
}
- (UIButton *)backItem {
    if (!_backItem) {
        _backItem = [UIButton buttonWithTitle:@"返回" fontSize:16];
    }
    return _backItem;
}
- (UIButton *)shareItem {
    if (!_shareItem) {
        _shareItem = [UIButton buttonWithTitle:@"分享" fontSize:16];
    }
    return _shareItem;
}
@end
