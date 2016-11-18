//
//  YBNewsSport.m
//  YueBallSport
//
//  Created by Minlay on 16/11/13.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewsSport.h"
#import "MJExtension.h"
#import "DataRequest.h"
#import "NSDictionary+Safe.h"

@interface YBNewsSport ()<DataRequestDelegate>

@end
@implementation YBNewsSport
+ (instancetype)requestNewsList:(NSDictionary *)parameter
                        success:(Success)success
                      errorBack:(Error)error {
    YBNewsSport *sport = [[self alloc]init];
    NewsSportListRequest *request = [NewsSportListRequest requestDataWithParameters:parameter successBlock:^(YTKRequest *request) {
        NSDictionary *status = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"status"];
        NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
        if (!code) {
            NSDictionary *data = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"data"];
            NSArray *list = [YBNewsSport mj_objectArrayWithKeyValuesArray:data];
            if (success) {
                   success(list.copy);
            }
        }
    } failureBlock:^(YTKRequest *request) {
        if (error) {
            error(request.error);
        }
    }];
    return sport;
}
+ (instancetype)requestHotNewsList:(NSDictionary *)parameter success:(Success)success errorBack:(Error)error {
    YBNewsSport *sport = [[self alloc]init];
    HotNewsSportListRequest *request = [HotNewsSportListRequest requestDataWithParameters:parameter successBlock:^(YTKRequest *request) {
        NSDictionary *status = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"status"];
        NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
        if (!code) {
            NSDictionary *data = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"data"];
            NSArray *list = [YBNewsSport mj_objectArrayWithKeyValuesArray:data];
            if (success) {
                success(list.copy);
            }
        }
    } failureBlock:^(YTKRequest *request) {
        if (error) {
            error(request.error);
        }
    }];
    return sport;
}

- (void)setImg:(NSArray *)img {
    _img = img;
    NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:img.count];
    for (NSDictionary *dict in img) {
        [temp addObject:[dict objectForKeyNotNull:@"url"]];
    }
    self.imgUrl = temp.copy;
}
@end
