
//
//  YBUserLogin.m
//  YueBallSport
//
//  Created by Minlay on 16/12/8.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBUserLogin.h"
#import "DataRequest.h"
#import "NSFileManager+Utilities.h"
#import <ShareSDK/ShareSDK.h>
#import "NSDictionary+Safe.h"
#import <SMS_SDK/SMSSDK.h>
#import "NSString+Utilities.h"

NSString *const UserLoginSuccess = @"UserLoginSuccess";
NSString *const UserLoginError = @"UserLoginError";

@interface YBUserLogin ()<DataRequestDelegate>
@property(nonatomic, copy)loginBlock loginBlock;
@property(nonatomic, copy)NSString *account;
@property(nonatomic, assign)BOOL isVerify;
@end
static  NSString *DiskUserLoginInfo = @"DiskUserLoginInfo";
@implementation YBUserLogin

static YBUserLogin *_instance;
+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YBUserLogin alloc]init];
    });
    return _instance;
}

#pragma mark - 登录组件
- (void)thirdLogin:(ThirdPlatformType)type callBack:(loginBlock)block {
    self.loginBlock = block;
    [ShareSDK getUserInfo:[self matchPlatformType:type]
     
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             _loginMode = (UserLoginMode)type;
             NSDictionary *param = @{@"name":user.nickname,@"icon":user.icon,@"sex":@(user.gender),@"token":user.uid};
             [ThirdLoginRequest requestDataWithDelegate:self parameters:param];
         }
         
         else
         {
             if (block) {
                 block(NO,nil);
             }
             [self postNotification:NO];
         }
         
     }];
}
- (void)userLogin:(NSString *)account password:(NSString *)pwd callBack:(loginBlock)block {
    self.loginBlock = block;
    _loginMode = UserLoginModeThisPlatform;
    [PlatformLoginRequest requestDataWithDelegate:self parameters:@{@"account":account,@"password":[pwd md5]}];
    
}
#pragma mark - 登出组件
- (void)userLogout {
    [ShareSDK cancelAuthorize:[self matchPlatformType:(ThirdPlatformType)self.loginMode]];
    [self diskRemoveUserInfo];
    _userInfo = nil;
    _loginMode = UserLoginModeNone;
}

#pragma mark - 注册验证组件

- (BOOL)isLoginIn {
    if (self.loginMode != UserLoginModeNone && self.userInfo != nil) {
        return YES;
    }
    return NO;
}

- (void)isResister:(NSString *)account callBack:(verifyCodeBlock)block {
    [UserRegisterStatusRequest requestDataWithParameters:@{@"account":account} successBlock:^(YTKRequest *request) {
        
        NSDictionary *result = [request.responseObject objectForKey:@"result"];
        NSString *status = [result objectForKey:@"status"];
        if ([status isEqualToString:@"0"] && block) {
            block(NO);
        }else {
            block(YES);
        }
        
    } failureBlock:^(YTKRequest *request) {
        if (block) {
            block(NO);
        }
    }];
}

- (void)requestVerifyCode:(NSString *)iphoneNumber callBack:(verifyCodeBlock)block{
    self.account = iphoneNumber;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:iphoneNumber zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error && block) {
            block(YES);
        } else if(block){
            block(NO);
        }
    }];
}
- (void)verifyCodeResult:(NSString *)code callBack:(verifyCodeBlock)block {
    [SMSSDK commitVerificationCode:code phoneNumber:self.account zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error && block) {
            self.isVerify = YES;
            block(YES);
        } else if(block){
            self.isVerify = NO;
            block(NO);
        }
    }];
}

- (void)userPostRegister:(NSString *)password callBack:(loginBlock)block {
    self.loginBlock = block;
    _loginMode = UserLoginModeThisPlatform;
    // 注册
    if (_isVerify) {
        _isVerify = NO;
     [PlatformRegisterRequest requestDataWithDelegate:self parameters:@{@"account":self.account,@"password":[password md5]}];
    }else {
        if (_loginBlock) {
            _loginBlock(NO,nil);
        }
        [self postNotification:NO];
    }
}
#pragma mark - 修改组件
- (void)modifyPassword:(NSString *)password callBack:(verifyCodeBlock)block {
    if (_isVerify) {
        _isVerify = NO;
        [ModifyPasswordRequest requestDataWithParameters:@{@"account":self.account,@"password":[password md5]} successBlock:^(YTKRequest *request) {
            NSDictionary *result = [request.responseObject objectForKey:@"result"];
            NSDictionary *status = [result objectForKey:@"status"];
            NSInteger code = [[status objectForKey:@"code"] longValue];
            if (!code && block) {
                    block(YES);
            }
            
        } failureBlock:^(YTKRequest *request) {
            if (block) {
                block(NO);
            }
        }];
    }else {
        if (block) {
            block(NO);
        }
    }
}

#pragma mark - 磁盘存储用户信息组件
- (YBUser *)diskLoadUserInfo {
    NSString *homePath  = [NSHomeDirectory() stringByAppendingPathComponent:DiskUserLoginInfo];//添加储存的文件名
   return  (YBUser *)[NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
}

- (void)diskRemoveUserInfo {
    NSString *path  = [NSHomeDirectory() stringByAppendingPathComponent:DiskUserLoginInfo];
    if (![FILEMANAGER isDeletableFileAtPath:path]) {
        [NSFileManager removeItemAtPath:path];
    }
}
- (void)saveUserInfo {
    NSString *homeDictionary = NSHomeDirectory();//获取根目录
    NSString *homePath  = [homeDictionary stringByAppendingPathComponent:DiskUserLoginInfo];//添加储存的文件名
    [NSKeyedArchiver archiveRootObject:self.userInfo toFile:homePath];
}
#pragma mark - 辅助组件
- (SSDKPlatformType)matchPlatformType:(ThirdPlatformType)type {
    if (type == 0) {
        return SSDKPlatformTypeQQ;
    }else if (type == 1) {
        return SSDKPlatformTypeSinaWeibo;
    }
    return SSDKPlatformTypeWechat;
}
- (YBUser *)userInfo {
    if (!_userInfo) {
        _userInfo = [self diskLoadUserInfo];
    }
    return _userInfo;
}
#pragma mark - 网络回调
- (void)requestFinished:(BaseDataRequest *)request {
    // 解析
    [self parseLogin:request.json];
//    if ([request isKindOfClass:[ThirdLoginRequest class]]) {
//
//    }else if ([request isKindOfClass:[PlatformLoginRequest class]]) {
//        [self parseLogin:request.json];
//    }
}

- (void)requestFailed:(BaseDataRequest *)request {
    _loginMode = UserLoginModeNone;
    if (_loginBlock) {
        _loginBlock(NO,nil);
    }
    [self postNotification:NO];
//    if ([request isKindOfClass:[ThirdLoginRequest class]]) {
//        if (_loginBlock) {
//            _loginBlock(NO,nil);
//        }
//    }else if ([request isKindOfClass:[PlatformLoginRequest class]]) {
//        if (_loginBlock) {
//            _loginBlock(NO,nil);
//        }
//        [self postNotification:NO];
//    }
}

#pragma mark - 解析组件
- (void)parseLogin:(NSDictionary *)json {
    NSDictionary *result = [json objectForKeyNotNull:@"result"];
    NSDictionary *status = [result objectForKeyNotNull:@"status"];
    NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
    if (code) {
        if (_loginBlock) {
            _loginBlock(NO,nil);
            return;
        }
        [self postNotification:NO];
    }
    NSDictionary *data = [result objectForKeyNotNull:@"data"];
    _userInfo = [YBUser mj_objectWithKeyValues:data];
    [self saveUserInfo];
    if (_loginBlock) {
        _loginBlock(YES,self.userInfo);
    }
    [self postNotification:YES];
    
}
#pragma mark - 通知组件
- (void)postNotification:(BOOL)success {
    if (success) {
        if ([_delegate respondsToSelector:@selector(loginFinish:)]) {
            [_delegate loginFinish:self.userInfo];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:UserLoginSuccess object:nil];
    }else {
        if ([_delegate respondsToSelector:@selector(loginError)]) {
            [_delegate loginError];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:UserLoginError object:nil];
    }
}
@end

