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
#import "YBUnderlineTextField.h"
#import "YBRegisterViewController.h"


@interface YBLoginViewController ()<UITextFieldDelegate>
@property(nonatomic, strong)UILabel *logoTip;
@property(nonatomic, strong)YBUnderlineTextField *iphoneField;
@property(nonatomic, strong)YBUnderlineTextField *pwdField;
@property(nonatomic, strong)UIButton *catEye;
@property(nonatomic, strong)UIButton *loginBtn;
@property(nonatomic, strong)UIButton *closeBtn;
@property(nonatomic, strong)UIButton *registerBtn;
@property(nonatomic, strong)UIButton *weiboLoginBtn;
@property(nonatomic, strong)UIButton *qqLoginBtn;
@property(nonatomic, strong)UIButton *wxLoginBtn;
@end

@implementation YBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self popVc];
}

#pragma mark - method
- (void)popVc {
    self.spring = YES;
    [self popViewcontrollerAnimationType:UIViewAnimationTypeSlideOut];
}

// 登录信息发生改变
- (void)loginMessageChange {
    // 输入完整信息登录可交互
    if (self.iphoneField.text.length > 0 &&
        self.pwdField.text.length > 0) {
        self.loginBtn.userInteractionEnabled = YES;
        self.loginBtn.selected = YES;
        self.loginBtn.backgroundColor = ThemeColor;
    }else {
        self.loginBtn.userInteractionEnabled = NO;
        self.loginBtn.selected = NO;
        self.loginBtn.backgroundColor = RGBACOLOR(222, 222, 222, 1);
    }
}
// 本平台登录
- (void)login {
    [[YBUserLogin getInstance]userLogin:self.iphoneField.text password:self.pwdField.text callBack:^(BOOL success, YBUser *user) {
        if (success) {
            [self popVc];
        }else {
            // 提示用户名密码错误
            NSLog(@"用户名密码错误");
        }
    }];
}
// 查看密码
- (void)watchPwd {
    self.pwdField.secureTextEntry = self.pwdField.selected;
    self.pwdField.selected = !self.pwdField.secureTextEntry;
}
// 注册跳转
- (void)registerJump {
    [self pushToController:[[YBRegisterViewController alloc]init] animated:YES];
}
- (void)weiboLogin {
    [[YBUserLogin getInstance]thirdLogin:ThirdPlatformTypeWeibo callBack:^(BOOL success, YBUser *user) {
        if (success) {
            [self popVc];
        }else {
            NSLog(@"登录失败");
        }
    }];
}

- (void)qqLogin {
    [[YBUserLogin getInstance]thirdLogin:ThirdPlatformTypeQQ callBack:^(BOOL success, YBUser *user) {
        if (success) {
            [self popVc];
        }else {
            NSLog(@"登录失败");
        }
    }];
}
- (void)wxLogin {
    [[YBUserLogin getInstance]thirdLogin:ThirdPlatformTypeWX callBack:^(BOOL success, YBUser *user) {
        if (success) {
            [self popVc];
        }else {
            NSLog(@"登录失败");
        }
    }];
}
- (void)setupUI {

}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    static CGFloat margin = 20;
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-margin);
        make.top.equalTo(self.view).offset(35);
    }];
    [self.logoTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(125);
    }];
    [self.iphoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
        make.top.equalTo(self.logoTip.mas_bottom).offset(65);
        make.height.offset(50);
    }];
    [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iphoneField);
        make.right.equalTo(self.iphoneField);
        make.height.offset(50);
        make.top.equalTo(self.iphoneField.mas_bottom).offset(0);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdField);
        make.right.equalTo(self.pwdField);
        make.top.equalTo(self.pwdField.mas_bottom).offset(20);
        make.height.offset(44);
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
- (UILabel *)logoTip {
    if (!_logoTip) {
        _logoTip = [UILabel labelWithText:@"登录阿拉丁" fontSize:23 textColor:RGBACOLOR(0, 186, 89, 1)];
//        _logoTip.font = [UIFont boldSystemFontOfSize:23];
        [self.view addSubview:_logoTip];
    }
    return _logoTip;
}
- (YBUnderlineTextField *)iphoneField {
    if (!_iphoneField) {
        _iphoneField = [[YBUnderlineTextField alloc]init];
        _iphoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号/邮箱/用户名" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(194, 194, 194,1)}];
        _iphoneField.font = [UIFont systemFontOfSize:15];
        _iphoneField.textAlignment = NSTextAlignmentLeft;
        _iphoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _iphoneField.delegate = self;
        [_iphoneField addTarget:self action:@selector(loginMessageChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_iphoneField];
    }
    return _iphoneField;
}
- (YBUnderlineTextField *)pwdField {
    if (!_pwdField) {
        _pwdField = [[YBUnderlineTextField alloc]init];
        _pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(194, 194, 194,1)}];
        _pwdField.font = [UIFont systemFontOfSize:15];
        _pwdField.textAlignment = NSTextAlignmentLeft;
        _pwdField.secureTextEntry = YES;
        _pwdField.delegate = self;
        [_pwdField addTarget:self action:@selector(loginMessageChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_pwdField];
    }
    return _pwdField;
}
- (UIButton *)catEye {
    if (!_catEye) {
        _catEye = [[UIButton alloc]init];
        [_catEye addTarget:self action:@selector(watchPwd) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_catEye];
    }
    return _catEye;
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithTitle:@"登录" fontSize:16 titleColor:RGBACOLOR(107, 107, 107, 1)];
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.backgroundColor = RGBACOLOR(222, 222, 222, 1);
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view addSubview:_loginBtn];
    }
    return _loginBtn;
}
- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithTitle:@"注册" fontSize:16 titleColor:RGBACOLOR(107, 107, 107, 1)];
        [_registerBtn addTarget:self action:@selector(registerJump) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registerBtn];
    }
    return _registerBtn;
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
- (UIButton *)wxLoginBtn {
    if (!_wxLoginBtn) {
        _wxLoginBtn = [UIButton buttonWithTitle:@"微信登录" fontSize:13 titleColor:[UIColor whiteColor]];
        [_wxLoginBtn addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_wxLoginBtn];
    }
    return _wxLoginBtn;
}
@end
