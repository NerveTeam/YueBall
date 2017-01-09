//
//  YBResetPasswordViewController.m
//  YueBallSport
//
//  Created by Minlay on 17/1/4.
//  Copyright © 2017年 YueBall. All rights reserved.
//

#import "YBResetPasswordViewController.h"
#import "YBUserLogin.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "YBUnderlineTextField.h"
#import "YBVerifyViewController.h"

@interface YBResetPasswordViewController ()<UITextFieldDelegate>
@property(nonatomic, strong)UILabel *logoTip;
@property(nonatomic, strong)YBUnderlineTextField *iphoneField;
@property(nonatomic, strong)UIButton *iphoneTip;
@property(nonatomic, strong)UIButton *verifyCodeBtn;
@property(nonatomic, strong)UIButton *backBtn;
@end

@implementation YBResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.iphoneField becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.iphoneField resignFirstResponder];
}

- (void)verifyClick {
    [[YBUserLogin getInstance]isResister:self.iphoneField.text callBack:^(BOOL success) {
        if (success) {
            YBVerifyViewController *verify = [[YBVerifyViewController alloc]init];
            verify.module = ModuleTypeResetPassword;
            verify.iphoneNumber = self.iphoneField.text;
            [[YBUserLogin getInstance]requestVerifyCode:self.iphoneField.text callBack:^(BOOL success) {
                if (success) {
                    [self pushToController:verify animated:YES];
                }else {
                    // 提示该获取验证码失败
                }
            }];
        }else {
            // 提示该帐号未注册
            
        }
    }];
    
}

- (void)iphoneMessageChange {
    // 输入完整信息登录可交互
    if (self.iphoneField.text.length > 10) {
        if ([self checkPhone:self.iphoneField.text]) {
            self.verifyCodeBtn.userInteractionEnabled = YES;
            self.verifyCodeBtn.selected = YES;
            self.verifyCodeBtn.backgroundColor = ThemeColor;
        }
    }else {
        self.verifyCodeBtn.userInteractionEnabled = NO;
        self.verifyCodeBtn.selected = NO;
        self.verifyCodeBtn.backgroundColor = RGBACOLOR(222, 222, 222, 1);
    }
}
// 正则过滤手机号
- (BOOL)checkPhone:(NSString *)phoneNumber

{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    if (!isMatch)
    {
        return NO;
    }
    
    return YES;
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    static CGFloat margin = 20;
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
    [self.verifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.iphoneField);
        make.top.equalTo(self.iphoneField.mas_bottom).offset(55);
        make.height.offset(44);
    }];
}

#pragma mark - lazy
- (UILabel *)logoTip {
    if (!_logoTip) {
        _logoTip = [UILabel labelWithText:@"找回密码" fontSize:23 textColor:RGBACOLOR(0, 186, 89, 1)];
        //        _logoTip.font = [UIFont boldSystemFontOfSize:23];
        [self.view addSubview:_logoTip];
    }
    return _logoTip;
}
- (YBUnderlineTextField *)iphoneField {
    if (!_iphoneField) {
        _iphoneField = [[YBUnderlineTextField alloc]init];
        _iphoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号/邮箱/帐号" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(194, 194, 194,1)}];
        _iphoneField.font = [UIFont systemFontOfSize:15];
        _iphoneField.textAlignment = NSTextAlignmentLeft;
        _iphoneField.keyboardType = UIKeyboardTypeNumberPad;
        _iphoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _iphoneField.delegate = self;
        [_iphoneField addTarget:self action:@selector(iphoneMessageChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_iphoneField];
    }
    return _iphoneField;
}
- (UIButton *)verifyCodeBtn {
    if (!_verifyCodeBtn) {
        _verifyCodeBtn = [UIButton buttonWithTitle:@"获取验证码" fontSize:16 titleColor:RGBACOLOR(107, 107, 107, 1)];
        [_verifyCodeBtn addTarget:self action:@selector(verifyClick) forControlEvents:UIControlEventTouchUpInside];
        _verifyCodeBtn.backgroundColor = RGBACOLOR(222, 222, 222, 1);
        _verifyCodeBtn.userInteractionEnabled = NO;
        [_verifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view addSubview:_verifyCodeBtn];
    }
    return _verifyCodeBtn;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"已有阿拉丁帐号,去登录" fontSize:16 titleColor:RGBACOLOR(107, 107, 107, 1)];
        [_backBtn addTarget:self action:@selector(loginJump) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}
@end
