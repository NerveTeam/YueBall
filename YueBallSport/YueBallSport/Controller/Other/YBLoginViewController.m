//
//  YBLoginViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/30.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBLoginViewController.h"
#import "MLTransition.h"
#import "YBUserLogin.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"

@interface YBLoginViewController ()
@property(nonatomic ,strong)UILabel *iphoneLabel;
@property(nonatomic, strong)UILabel *verifiedLabel;
@property(nonatomic, strong)UITextField *iphoneField;
@property(nonatomic, strong)UITextField *pwdField;
@property(nonatomic, strong)UIButton *closeBtn;
@property(nonatomic, strong)UIButton *registerBtn;
@property(nonatomic, strong)UIButton *weiboLoginBtn;
@property(nonatomic, strong)UIButton *qqLoginBtn;
@end

@implementation YBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBg.jpg"]];
    [self setupUI];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.spring = YES;
    [self dismissViewcontrollerAnimationType:UIViewAnimationTypeSlideOut completion:nil];
}
- (void)weiboLogin {
    [[YBUserLogin getInstance]thirdLogin:ThirdPlatformTypeWeibo callBack:^(BOOL success, YBUser *user) {
        self.spring = YES;
        [self dismissViewcontrollerAnimationType:UIViewAnimationTypeSlideOut completion:nil];
    }];
}

- (void)qqLogin {
[[YBUserLogin getInstance]thirdLogin:ThirdPlatformTypeQQ callBack:^(BOOL success, YBUser *user) {
    self.spring = YES;
    [self dismissViewcontrollerAnimationType:UIViewAnimationTypeSlideOut completion:nil];
}];
}
- (void)setupUI {

}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.iphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.top.equalTo(self.view).offset(100);
    }];
    [self.verifiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iphoneLabel);
        make.top.equalTo(self.iphoneLabel.mas_bottom).offset(10);
    }];
    [self.weiboLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.top.equalTo(self.view).offset(250);
    }];
    [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weiboLoginBtn.mas_right).offset(30);
        make.top.equalTo(self.weiboLoginBtn);
    }];
}


#pragma mark - lazy
- (UILabel *)iphoneLabel {
    if (!_iphoneLabel) {
        _iphoneLabel = [UILabel labelWithText:@"手机号" fontSize:16 textColor:[UIColor whiteColor]];
        [self.view addSubview:_iphoneLabel];
    }
    return _iphoneLabel;
}
- (UILabel *)verifiedLabel {
    if (!_verifiedLabel) {
        _verifiedLabel = [UILabel labelWithText:@"验证码" fontSize:16 textColor:[UIColor whiteColor]];
        [self.view addSubview:_verifiedLabel];
    }
    return _verifiedLabel;
}
- (UIButton *)weiboLoginBtn {
    if (!_weiboLoginBtn) {
        _weiboLoginBtn = [UIButton buttonWithTitle:@"微博登录" fontSize:13 titleColor:[UIColor whiteColor]];
        [_weiboLoginBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_weiboLoginBtn];
    }
    return _weiboLoginBtn;
}
- (UIButton *)qqLoginBtn {
    if (!_qqLoginBtn) {
        _qqLoginBtn = [UIButton buttonWithTitle:@"QQ登录" fontSize:13 titleColor:[UIColor whiteColor]];
        [_qqLoginBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_qqLoginBtn];
    }
    return _qqLoginBtn;
}
@end
