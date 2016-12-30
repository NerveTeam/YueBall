//
//  YBMessageModel.h
//  YueBallSport
//
//  Created by 韩森 on 2016/12/2.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBMessageModel : NSObject<NSCoding>

@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * userName;

@property (nonatomic,copy)NSString * headIcon;

@end
