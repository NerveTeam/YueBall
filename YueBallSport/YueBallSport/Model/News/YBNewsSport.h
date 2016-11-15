//
//  YBNewsSport.h
//  YueBallSport
//
//  Created by Minlay on 16/11/13.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface YBNewsSport : BaseModel
@property(nonatomic, assign)NSInteger newsId; // 新闻id
@property(nonatomic, copy)NSString *title;    // 标题
@property(nonatomic, copy)NSString *summary; // 摘要
@property(nonatomic, copy)NSString *link; // url
@property(nonatomic, strong)NSArray *img; // 图集
@property(nonatomic, copy)NSString *type; // 类型
@property(nonatomic, assign)NSInteger pubDate;
@property(nonatomic, assign)NSInteger commentCount; // 评论数
@property(nonatomic, strong)NSArray *imgUrl; // img集合

+ (instancetype)requestNewsList:(NSDictionary *)parameter
                        success:(Success)success
                      errorBack:(Error)error;



@end

