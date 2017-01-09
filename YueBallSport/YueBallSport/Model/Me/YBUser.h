//
//  YBUser.h
//  YueBallSport
//
//  Created by Minlay on 16/12/8.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface YBUser : BaseModel
@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)NSInteger uid;
@property(nonatomic, copy)NSString *icon;
@property(nonatomic, assign)NSInteger teamId;
@property(nonatomic, assign)NSInteger sex;
//@property(nonatomic, assign)NSString *location;
@property(nonatomic, copy)NSString *personality;
//@property(nonatomic, copy)NSString *token;
@end
