//
//  DataRequest.m
//  MLTools
//
//  Created by Minlay on 16/9/23.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "DataRequest.h"

@implementation TestRequest

- (NSString *)requestUrl {
//    示例，我们的注册接口
//    return @"/zhuce.php?";
    return @"http://platform.sina.com.cn/sports_client/comment?";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}
@end

@implementation NewsSportListRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/News/feed?";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end


@implementation HotNewsSportListRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/News/hotlist?";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end
