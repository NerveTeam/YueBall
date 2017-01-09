//
//  YBVerifyViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/12/28.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBVerifyViewController.h"
#import "YBUserLogin.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "YBVerifyCodeInputView.h"
#import "MLTransition.h"

@interface YBVerifyViewController ()<YBVerifyCodeInputViewDelegate>
@property(nonatomic, strong)UILabel *logoTip;
@property(nonatomic, strong)YBVerifyCodeInputView *verifyInputView;
@property(nonatomic, strong)UILabel *iphoneTip;
@property(nonatomic, strong)UILabel *verifyTip;
@end

@implementation YBVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.verifyInputView hideKeyBoard];
}
- (void)popVc {
    self.spring = YES;
    [self popViewcontrollerAnimationType:UIViewAnimationTypeSlideOut];
}
- (void)verifyInputDidFinish:(NSString *)code {
    [[YBUserLogin getInstance]verifyCodeResult:code callBack:^(BOOL success) {
        if (success) {
           YBInputPasswordViewController *inputPwd =  [[YBInputPasswordViewController alloc]init];
            inputPwd.module = _module;
            [self pushToController:inputPwd animated:YES];
        }else {
        // 提示验证码错误
        }
    }];
}
- (void)viewWillLayoutSubviews {
    [self.logoTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(85);
        make.centerX.equalTo(self.view);
    }];
    [self.iphoneTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoTip.mas_bottom).offset(30);
        make.centerX.equalTo(self.logoTip);
    }];
    [self.verifyInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iphoneTip.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.height.offset(50);
    }];
    [self.verifyTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.verifyInputView.mas_bottom).offset(20);
    }];
}

#pragma mark - lazy
- (UILabel *)logoTip {
    if (!_logoTip) {
        _logoTip = [UILabel labelWithText:_module == ModuleTypeRegister ? @"注册阿拉丁" : @"找回密码" fontSize:23 textColor:RGBACOLOR(0, 186, 89, 1)];
        //        _logoTip.font = [UIFont boldSystemFontOfSize:23];
        [self.view addSubview:_logoTip];
    }
    return _logoTip;
}
- (UILabel *)iphoneTip {
    if (!_iphoneTip) {
        _iphoneTip = [UILabel labelWithText:self.iphoneNumber fontSize:15 textColor:RGBACOLOR(26, 26, 26, 1)];
        [self.view addSubview:_iphoneTip];
        _iphoneTip.hidden = _module == ModuleTypeRegister ? NO : YES;
    }
    return _iphoneTip;
}
- (YBVerifyCodeInputView *)verifyInputView {
    if (!_verifyInputView) {
        _verifyInputView = [[YBVerifyCodeInputView alloc]init];
        _verifyInputView.numberOfVertifyCode = 4;
        _verifyInputView.backgroundColor = [UIColor whiteColor];
        _verifyInputView.delegate = self;
        [self.view addSubview:_verifyInputView];
    }
    return _verifyInputView;
}
- (UILabel *)verifyTip {
    if (!_verifyTip) {
        _verifyTip = [UILabel labelWithText:@"验证码已发送" fontSize:12 textColor:RGBACOLOR(107, 107, 107, 1)];
        [self.view addSubview:_verifyTip];
    }
    return _verifyTip;
}
@end
