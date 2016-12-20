//
//  DemoModel.h
//  UISearchController&UISearchDisplayController
//
//  Created by zml on 15/12/2.
//  Copyright © 2015年 zml@lanmaq.com. All rights reserved.
//  https://github.com/Lanmaq/iOS_HelpOther_WorkSpace


#import <Foundation/Foundation.h>

@interface DemoModel : NSObject<NSCoding>

/**
  查询该朋友 的 昵称
 */
@property (nonatomic,copy)   NSString *friendName;

/**
 该朋友 的 uid
 */
@property (nonatomic,copy)   NSString *friendId;

/**
 该朋友 的 头像
 */
@property (nonatomic,copy)   NSString *headIcon;
/**
   该朋友的 头像
 */
@property (nonatomic,strong) NSData   *imageData;

/**
 该朋友 的 球队昵称
 */
@property (nonatomic,copy)   NSString *groupName;
/**
 该朋友 的 球队头像
 */
@property (nonatomic,copy)   NSString *chatIcon;


+ (DemoModel *) modelWithName:(NSString *)friendName friendId:(NSString *)friendId imageData:(NSData *)imageData;

@end
