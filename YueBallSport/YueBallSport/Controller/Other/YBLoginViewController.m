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
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

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
//    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ
//                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
//                                       
//                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
//                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
//                                       associateHandler (user.uid, user, user);
//                                       NSLog(@"dd%@",user.rawData);
//                                       NSLog(@"dd%@",user.credential);
//                                       
//                                   }
//                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
//                                    
//                                    if (state == SSDKResponseStateSuccess)
//                                    {
//                                        
//                                    }
//                                    
//                                }];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo

           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
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
