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
    return @"http://wu.she-cheng.com/thinkphp/news/feed?";
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
    return @"http://wu.she-cheng.com/thinkphp/news/hotlist?";
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

@implementation HotNewsFoucsRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/news/foucs";
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

@implementation ReplayCommentRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/comment/replay";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end


@implementation FriendListRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/Message/friendList";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end


@implementation AddFriendRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/Message/addfriend";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end


@implementation AddChatIdRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/Message/addChatId";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

//-(YTKRequestSerializerType *)

- (BOOL)useCDN {
    return YES;
}

@end

@implementation ChatGroupDetailRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/Message/addChatId";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}



@end










