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
typedef void(^thirdLoginBlock)(BOOL success, YBUser *user);

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
 *  第三方登录/注册
 */
- (void)thirdLogin:(ThirdPlatformType)type callBack:(thirdLoginBlock)block;
/**
 *  用户登出
 */
- (void)userLogout;
/**
 *  用户短信注册
 */
- (void)userMessageRegister;
/**
 *  用户登录
 */
- (void)userLogin:(NSString *)account password:(NSString *)pwd;
/**
 *  判断用户是否登录
 */
- (BOOL)isLoginIn;
@end


