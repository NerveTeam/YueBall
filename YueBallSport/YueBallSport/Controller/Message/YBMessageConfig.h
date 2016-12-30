//
//  YBMessageConfig.h
//  YueBallSport
//
//  Created by 韩森 on 2016/11/9.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBMessageConfig : NSObject
@property (nonatomic,strong)NSMutableArray * friendListArray;

/**
 LeanCloud 配置的相关信息
 */
+(void)AVOSCloudConfig;

//每次启用ChatKit 服务都需要调用
+(void)ChatKitConfig;

//注册远程通知
+(void)registerRemoteNotification;

//用户体系
+ (void)lcck_setFetchProfiles;

/*!
 *  入口胶水函数：初始化入口函数
 *
 *  程序完成启动，在appdelegate中的 `-[AppDelegate didFinishLaunchingWithOptions:]`
 * 一开始的地方调用.
 */
+ (void)invokeThisMethodInDidFinishLaunching;

-(NSArray *)LCCKContactProfilesArr;
@end
