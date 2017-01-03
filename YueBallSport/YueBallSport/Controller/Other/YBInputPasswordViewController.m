//
//  YBInputPasswordViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/12/29.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBInputPasswordViewController.h"
#import "YBUserLogin.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "YBUnderlineTextField.h"
#import "MLTransition.h"
#import "YBLoginViewController.h"
#import "YBRegisterViewController.h"
#import "YBVerifyViewController.h"
#import "NSArray+Safe.h"


@interface YBInputPasswordViewController ()<UITextFieldDelegate>
@property(nonatomic, strong)UILabel *logoTip;
@property(nonatomic, strong)YBUnderlineTextField *pwdField;
@property(nonatomic, strong)UIButton *catEye;
@property(nonatomic, strong)UIButton *enterBtn;
@property(nonatomic, strong)UIButton *closeBtn;
@end

@implementation YBInputPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pwdField becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.pwdField resignFirstResponder];
}
#pragma mark - method
// 登录信息发生改变
- (void)pwdMessageChange {
    // 输入完整信息登录可交互
    if (self.pwdField.text.length > 5) {
        self.enterBtn.userInteractionEnabled = YES;
        self.enterBtn.selected = YES;
        self.enterBtn.backgroundColor = ThemeColor;
    }else {
        self.enterBtn.userInteractionEnabled = NO;
        self.enterBtn.selected = NO;
        self.enterBtn.backgroundColor = RGBACOLOR(222, 222, 222, 1);
    }
}
// 查看密码
- (void)watchPwd {
    self.pwdField.secureTextEntry = self.pwdField.selected;
    self.pwdField.selected = !self.pwdField.secureTextEntry;
}
- (void)popVc {
    
    self.spring = YES;
    [self popViewcontrollerAnimationType:UIViewAnimationTypeSlideOut];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *subVc in self.navigationController.viewControllers) {
        if ([subVc isKindOfClass:[YBLoginViewController class]] ||
            [subVc isKindOfClass:[YBRegisterViewController class]] ||
            [subVc isKindOfClass:[YBVerifyViewController class]]) {
            [subVc popViewControllerAnimated:NO];
            [array removeObject:subVc];
        }
    }
    self.navigationController.viewControllers = array.copy;
    
}
- (void)enter {
    [[YBUserLogin getInstance]userPostRegister:self.pwdField.text callBack:^(BOOL success, YBUser *user) {
        if (success) {
            [self popVc];
        }else {
        // 提示网络开小差
        }
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    static CGFloat margin = 20;
    [self.logoTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(125);
    }];
    [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
        make.top.equalTo(self.logoTip.mas_bottom).offset(65);
        make.height.offset(50);
    }];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdField.mas_bottom).offset(100);
        make.left.right.equalTo(self.pwdField);
        make.height.offset(44);
    }];
    
}


#pragma mark - lazy
- (UILabel *)logoTip {
    if (!_logoTip) {
        _logoTip = [UILabel labelWithText:@"注册阿拉丁" fontSize:23 textColor:RGBACOLOR(0, 186, 89, 1)];
        [self.view addSubview:_logoTip];
    }
    return _logoTip;
}
- (YBUnderlineTextField *)pwdField {
    if (!_pwdField) {
        _pwdField = [[YBUnderlineTextField alloc]init];
        _pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请创建一个密码" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(194, 194, 194,1)}];
        _pwdField.font = [UIFont systemFontOfSize:15];
        _pwdField.textAlignment = NSTextAlignmentLeft;
        _pwdField.secureTextEntry = YES;
        _pwdField.delegate = self;
        [_pwdField addTarget:self action:@selector(pwdMessageChange) forControlEvents:UIControlEventEditingChanged];
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
- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithTitle:@"开始体验" fontSize:16 titleColor:RGBACOLOR(107, 107, 107, 1)];
        [_enterBtn addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
        _enterBtn.backgroundColor = RGBACOLOR(222, 222, 222, 1);
        _enterBtn.userInteractionEnabled = NO;
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.view addSubview:_enterBtn];
    }
    return _enterBtn;
}
@end
