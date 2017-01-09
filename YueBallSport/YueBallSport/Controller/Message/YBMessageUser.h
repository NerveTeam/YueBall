//
//  YBMessageUser.h
//  YueBallSport
//
//  Created by 韩森 on 2016/11/15.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<ChatKit/LCChatKit.h>)
#import <ChatKit/LCChatKit.h>
#else
#import "LCChatKit.h"
#endif

@interface YBMessageUser : NSObject <LCCKUserDelegate>

/**
 *  检查与 aPerson 是否表示同一对象
 */
- (BOOL)isEqualToUer:(YBMessageUser *)user;

- (void)saveToDiskWithKey:(NSString *)key;

+ (id)loadFromDiskWithKey:(NSString *)key;


@end
