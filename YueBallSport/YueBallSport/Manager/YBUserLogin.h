//
//  YBUserLogin.h
//  YueBallSport
//
//  Created by Minlay on 16/12/8.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBUser.h"

typedef NS_ENUM(NSUInteger, ThirdPlatformType) {
    ThirdPlatformTypeQQ     = 0,
    ThirdPlatformTypeWeibo  = 1,
    ThirdPlatformTypeWX     = 2
};
typedef NS_ENUM(NSUInteger, UserLoginMode) {
    UserLoginModeQQ     = 0,
    UserLoginModeWeibo  = 1,
    UserLoginModeWX     = 2,
    UserLoginModeThisPlatform = 3,
    UserLoginModeNone   = 4
};
typedef void(^loginBlock)(BOOL success, YBUser *user);
typedef void(^verifyCodeBlock)(BOOL success);

@protocol YBUserLoginDelegate <NSObject>
@optional
// 用户登录成功
- (void)loginFinish:(YBUser *)userInfo;
// 用户登录失败
- (void)loginError;
@end
// 用户登录成功通知
extern NSString *const UserLoginSuccess;
// 用户登录失败通知
extern NSString *const UserLoginError;

@interface YBUserLogin : NSObject
/**
 *  存储了用户的信息
 */
@property(nonatomic, strong)YBUser *userInfo;
/**
 *  当前用户登录的方式
 */
@property(nonatomic, assign, readonly)UserLoginMode loginMode;
/**
 *  登录代理
 */
@property(nonatomic, weak)id<YBUserLoginDelegate> delegate;
+ (instancetype)getInstance;

/**
 *  获取验证码
 */
- (void)requestVerifyCode:(NSString *)iphoneNumber callBack:(verifyCodeBlock)block;
/**
 *  验证码验证
 */
- (void)verifyCodeResult:(NSString *)code callBack:(verifyCodeBlock)block;
/**
 *  提交注册
 */
- (void)userPostRegister:(NSString *)password callBack:(loginBlock)block;
/**
 *  本平台用户登录
 */
- (void)userLogin:(NSString *)account password:(NSString *)pwd callBack:(loginBlock)block;
/**
 *  第三方登录/注册
 */
- (void)thirdLogin:(ThirdPlatformType)type callBack:(loginBlock)block;

/**
 *  修改密码
 */
- (void)modifyPassword:(NSString *)password callBack:(verifyCodeBlock)block;

/**
 *  判断用户是否登录
 */
- (BOOL)isLoginIn;

/**
 *  判断用户是否注册
 */
- (void)isResister:(NSString *)account callBack:(verifyCodeBlock)block;

/**
 *  用户登出
 */
- (void)userLogout;
@end


