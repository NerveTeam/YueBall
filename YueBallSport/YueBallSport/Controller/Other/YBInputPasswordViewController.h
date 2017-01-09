//
//  YBInputPasswordViewController.h
//  YueBallSport
//
//  Created by Minlay on 16/12/29.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBBaseViewController.h"

typedef NS_ENUM(NSUInteger, ModuleType) {
    ModuleTypeRegister,
    ModuleTypeResetPassword
};
@interface YBInputPasswordViewController : YBBaseViewController
@property(nonatomic, assign)ModuleType module;
@end
