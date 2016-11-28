//
//  YBNewsFoucs.m
//  YueBallSport
//
//  Created by Minlay on 16/11/21.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewsFoucs.h"

@implementation YBNewsFoucs
+ (instancetype)requestNewsFoucs:(Success)success error:(Error)error {
    YBNewsFoucs *foucs = [[self alloc]init];
    
    HotNewsFoucsRequest *request = [HotNewsFoucsRequest requestDataWithSuccessBlock:^(YTKRequest *request) {
        NSDictionary *status = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"status"];
        NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
        if (!code) {
            NSDictionary *data = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"data"];
            NSArray *list = [YBNewsFoucs mj_objectArrayWithKeyValuesArray:data];
            if (success) {
                success(list.copy);
            }
        }
    } failureBlock:^(YTKRequest *request) {
        if (error) {
            error(request.error);
        }
    }];
    
    return foucs;
}
@end
