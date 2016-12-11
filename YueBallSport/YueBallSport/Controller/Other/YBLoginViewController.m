//
//  YBLoginViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/30.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBLoginViewController.h"
#import "UIView+TopBar.h"
#import "MLTransition.h"

@interface YBLoginViewController ()
@property(nonatomic,strong)UIView *topBar;
@end

@implementation YBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *weibo = [UIButton new];
    [weibo setTitle:@"微博登录" forState:UIControlStateNormal];
    [weibo setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    weibo.font = [UIFont systemFontOfSize:12];
    weibo.backgroundColor = [UIColor redColor];
    [weibo addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weibo];
    weibo.frame = CGRectMake(100, 100, 50, 50);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.spring = YES;
    [self dismissViewcontrollerAnimationType:UIViewAnimationTypeSlideOut completion:nil];
}
- (void)weiboLogin {
    
}
- (void)setupUI {
    [self.view addSubview:self.topBar];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(TopBarHeight + StatusBarHeight);
    }];
}


#pragma mark - lazy
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]init];
        _topBar = [_topBar topBarWithTintColor:nil title:@"登录" titleColor:[UIColor whiteColor] leftView:nil rightView:nil responseTarget:nil];
    }
    return _topBar;
}
@end
