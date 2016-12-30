//
//  YBMessageConfig.m
//  YueBallSport
//
//  Created by 韩森 on 2016/11/9.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageConfig.h"
#import "YBMessageConstant.h"

#if __has_include(<ChatKit/LCChatKit.h>)
#import <ChatKit/LCChatKit.h>
#else
#import "LCChatKit.h"
#endif

#import "YBMessageModel.h"
#import "MJExtension.h"
#import "YBMessageViewController.h"
#import "DataRequest.h"
#import "NSDictionary+Safe.h"
#import "YBContactManager.h"
//#import "LCCKLoginViewController.h"
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
/// Notification become independent from UIKit
@import UserNotifications;
#endif

@interface YBMessageConfig ()

#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
<UNUserNotificationCenterDelegate>
#endif

@end

static NSString * const YBMessagesLeanCloudAPPID = @"TEO6zwvQtqkfIhKp97KST1q0-gzGzoHsz";
static NSString * const YBMessagesLeanCloudAPPKEY = @"niorDKoncl9M166yh9B3kRn7";

@implementation YBMessageConfig

//程序启动时调用
+(void)AVOSCloudConfig{
    
    [AVOSCloud setApplicationId:YBMessagesLeanCloudAPPID clientKey:YBMessagesLeanCloudAPPKEY];
    
#ifdef DEBUG
    [AVOSCloud setAllLogsEnabled:YES];
#endif
    
   
}

//每次启用ChatKit 服务都需要调用
+(void)ChatKitConfig{
    
    
    [LCChatKit setAppId:YBMessagesLeanCloudAPPID appKey:YBMessagesLeanCloudAPPKEY];
    
    [YBMessageConfig registerRemoteNotification];
    //不配置要崩溃
    [YBMessageConfig lcck_setFetchProfiles];
    
    
}

//注册远程通知
+(void)registerRemoteNotification{
    
    YBMessageConfig * config = [[YBMessageConfig alloc]init];
    [config registerForRemoteNotification];
}

#pragma mark - 初始化UNUserNotificationCenter
///=============================================================================
/// @name 初始化UNUserNotificationCenter
///=============================================================================

/**
 * 初始化UNUserNotificationCenter
 */
-(void)registerForRemoteNotification {
    // iOS 10 兼容
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
        
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
        // 监听回调事件
        [uncenter setDelegate:self];
        //iOS 10 使用以下方法注册，才能得到授权
        [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                                completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                    //TODO:授权状态改变
                                    NSLog(@"%@" , granted ? @"授权成功" : @"授权失败");
                                }];
        // 获取当前的通知授权状态, UNNotificationSettings
        [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%s\nline:%@\n-----\n%@\n\n", __func__, @(__LINE__), settings);
            /*
             UNAuthorizationStatusNotDetermined : 没有做出选择
             UNAuthorizationStatusDenied : 用户未授权
             UNAuthorizationStatusAuthorized ：用户已授权
             */
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                NSLog(@"未选择");
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                NSLog(@"未授权");
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                NSLog(@"已授权");
            }
        }];
        
#endif
        
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
#pragma clang diagnostic pop
}

#pragma mark UNUserNotificationCenterDelegate

#pragma mark - 添加处理 APNs 通知回调方法
///=============================================================================
/// @name 添加处理APNs通知回调方法
///=============================================================================

#pragma mark -
#pragma mark - UNUserNotificationCenterDelegate Method

#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8

/**
 * Required for iOS 10+
 * 在前台收到推送内容, 执行的方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //TODO:处理远程推送内容
        NSLog(@"%@", userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
}

/**
 * Required for iOS 10+
 * 在后台和启动之前收到推送内容, 执行的方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //TODO:处理远程推送内容
        NSLog(@"%@", userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionBadge + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionAlert);
}

#endif

#pragma mark -
#pragma mark - UIApplicationDelegate Method

/*!
 * Required for iOS 7+
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //TODO:处理远程推送内容
    NSLog(@"%@", userInfo);
    // Must be called when finished
    completionHandler(UIBackgroundFetchResultNewData);
}

//#pragma mark - 实现注册APNs失败接口（可选）
/////=============================================================================
///// @name 实现注册APNs失败接口（可选）
/////=============================================================================
//
///**
// * also used in iOS10
// */
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"%s\n[无法注册远程提醒, 错误信息]\nline:%@\n-----\n%@\n\n", __func__
//}


#pragma mark - 用户体系的设置
/**
 *  设置用户体系，里面要实现如何根据 userId 获取到一个 User 对象的逻辑。
 *  ChatKit 会在需要用到 User信息时调用设置的这个逻辑。
 */
+ (void)lcck_setFetchProfiles {
#warning 注意：setFetchProfilesBlock 方法必须实现，如果不实现，ChatKit将无法显示用户头像、用户昵称。以下方法循环模拟了通过 userIds 同步查询 users 信息的过程，这里需要替换为 App 的 API 同步查询
    [[LCChatKit sharedInstance] setFetchProfilesBlock:^(NSArray<NSString *> *userIds,
                                                        LCCKFetchProfilesCompletionHandler completionHandler) {
        if (userIds.count == 0) {
            NSInteger code = 0;
            NSString *errorReasonText = @"User ids is nil";
            NSDictionary *errorInfo = @{
                                        @"code":@(code),
                                        NSLocalizedDescriptionKey : errorReasonText,
                                        };
            
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:code
                                             userInfo:errorInfo];
            
            !completionHandler ?: completionHandler(nil, error);
            return;
        }
        
//        NSMutableArray *users = [NSMutableArray arrayWithCapacity:userIds.count];
#warning 注意：以下方法循环模拟了通过 userIds 同步查询 users 信息的过程，这里需要替换为 App 的 API 同步查询
        //以下是设置用户体系
        
        //用户本身
        YBMessageUser *user_ = [YBMessageUser userWithUserId:YBMessageUserId
                                                        name:YBMessageUserId
                                                   avatarURL:[NSURL URLWithString:@"http://www.avatarsdb.com/avatars/bath_bob.jpg"]
                                                    clientId:YBMessageUserId];

        NSMutableArray * users = [[NSMutableArray alloc]initWithObjects:user_, nil];
        
        [userIds enumerateObjectsUsingBlock:^(NSString *_Nonnull clientId, NSUInteger idx,
                                              BOOL *_Nonnull stop) {
            
            
            //除去用户本身 ，其他 人的 配置信息
            
            NSLog(@"clientId-  %@",clientId);

            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid like %@", clientId];
            
            
            YBMessageConfig * config = [[YBMessageConfig alloc]init];
            [config LCCKContactProfilesArr];
            
            NSArray *searchedUsers = [[config LCCKContactProfilesArr] filteredArrayUsingPredicate:predicate];
            
            NSLog(@"searchedUsers-%@",searchedUsers);
            if (searchedUsers.count > 0) {
                YBMessageModel *user = searchedUsers[0];
                NSURL *avatarURL = [NSURL URLWithString:user.headIcon];
                YBMessageUser *user_ = [YBMessageUser userWithUserId:user.uid
                                                                name:user.userName
                                                           avatarURL:avatarURL
                                                            clientId:clientId];
                
        
                [users addObject:user_];
            } else {
                //注意：如果网络请求失败，请至少提供 ClientId！
                YBMessageUser *user_ = [YBMessageUser userWithClientId:clientId];
                [users addObject:user_];
            }
        }];
        // 模拟网络延时，3秒
        //         sleep(3);
        
#warning 重要：completionHandler 这个 Bock 必须执行，需要在你**获取到用户信息结束**后，将信息传给该Block！
        !completionHandler ?: completionHandler([users copy], nil);
    }];
}


#pragma mark - SDK Life Control
+ (void)invokeThisMethodInDidFinishLaunching {
    // 如果APP是在国外使用，开启北美节点
    // [AVOSCloud setServiceRegion:AVServiceRegionUS];
    // 启用未读消息
    [AVIMClient setUserOptions:@{ AVIMUserOptionUseUnread : @(YES) }];
    [AVIMClient setTimeoutIntervalInSeconds:20];
    //添加输入框底部插件，如需更换图标标题，可子类化，然后调用 `+registerSubclass`
    [LCCKInputViewPluginTakePhoto registerSubclass];
    [LCCKInputViewPluginPickImage registerSubclass];
    [LCCKInputViewPluginLocation registerSubclass];
    
}

#pragma mark -- 获取好友列表 数组
-(NSArray *)LCCKContactProfilesArr{
    
    
    YBContactManager * yb = [[YBContactManager alloc]init];
    [yb getFiledPathFriendList];
    [yb getArrary:[yb getFiledPathFriendList]];
    
   
    return [yb getArrary:[yb getFiledPathFriendList]];

}







@end
