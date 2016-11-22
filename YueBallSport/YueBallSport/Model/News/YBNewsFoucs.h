//
//  YBNewsFoucs.h
//  YueBallSport
//
//  Created by Minlay on 16/11/21.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface YBNewsFoucs : BaseModel
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *imgUrl;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, assign)NSInteger articleId;
@property(nonatomic, assign)NSInteger videoId;

+ (instancetype)requestNewsFoucs:(Success)success error:(Error)error;
@end
