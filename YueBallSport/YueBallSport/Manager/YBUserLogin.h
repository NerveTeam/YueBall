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
    UserLoginModeThisPlatform = 3
};
typedef void(^thirdLoginBlock)(BOOL success, YBUser *user);

@interface YBUserLogin : NSObject

+ (instancetype)getInstance;

- (void)thirdLogin:(ThirdPlatformType)type callBack:(thirdLoginBlock)block;

- (void)userLogout;
@end

@interface YBUserLogin(User)
@property(nonatomic, strong)YBUser *userInfo;
@property(nonatomic, assign, readonly)UserLoginMode loginMode;
@end
