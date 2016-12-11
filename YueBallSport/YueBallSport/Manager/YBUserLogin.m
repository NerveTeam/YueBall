
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

@interface YBUserLogin ()<DataRequestDelegate>
@property(nonatomic, copy)thirdLoginBlock loginBlock;
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

- (void)thirdLogin:(ThirdPlatformType)type callBack:(thirdLoginBlock)block {
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
         }
         
     }];
}

- (void)userLogout {
    [ShareSDK cancelAuthorize:[self matchPlatformType:(ThirdPlatformType)self.loginMode]];
    [self diskRemoveUserInfo];
    _userInfo = nil;
    _loginMode = UserLoginModeNone;
}

- (void)userLogin {

}

- (void)userMessageRegister {

}

- (BOOL)isLoginIn {
    if (self.loginMode != UserLoginModeNone && self.userInfo != nil) {
        return YES;
    }
    return NO;
}
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

- (void)requestFinished:(BaseDataRequest *)request {
    if ([request isKindOfClass:[ThirdLoginRequest class]]) {
        // 解析
        if (_loginBlock) {
            _loginBlock(YES,nil);
        }
    }
}

- (void)requestFailed:(BaseDataRequest *)request {
    if ([request isKindOfClass:[ThirdLoginRequest class]]) {
        // 解析
        
        if (_loginBlock) {
            _loginBlock(NO,nil);
        }
    }
}
@end

