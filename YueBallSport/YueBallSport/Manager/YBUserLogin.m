
//
//  YBUserLogin.m
//  YueBallSport
//
//  Created by Minlay on 16/12/8.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBUserLogin.h"
#import <ShareSDK/ShareSDK.h>

@interface YBUserLogin ()
@property(nonatomic, copy)thirdLoginBlock loginBlock;
@end

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
//    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [ShareSDK getUserInfo:[self matchPlatformType:type]
     
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
             if (block) {
                 block(NO,nil);
             }
         }
         
     }];
}

- (SSDKPlatformType)matchPlatformType:(ThirdPlatformType)type {
    if (type == 0) {
        return SSDKPlatformTypeQQ;
    }else if (type == 1) {
        return SSDKPlatformTypeSinaWeibo;
    }
    return SSDKPlatformTypeWechat;
}
@end
