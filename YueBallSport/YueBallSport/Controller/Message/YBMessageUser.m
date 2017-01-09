//
//  YBMessageUser.m
//  YueBallSport
//
//  Created by 韩森 on 2016/11/15.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageUser.h"

@interface YBMessageUser ()

@end

@implementation YBMessageUser

@synthesize userId = _userId;
@synthesize name = _name;
@synthesize avatarURL = _avatarURL;
@synthesize clientId = _clientId;

- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)name avatarURL:(NSURL *)avatarURL clientId:(NSString *)clientId {
    self = [super init];
    if (!self) {
        return nil;
    }
    _userId = userId;
    _name = name;
    _avatarURL = avatarURL;
    _clientId = clientId;
    return self;
}

+ (instancetype)userWithUserId:(NSString *)userId name:(NSString *)name avatarURL:(NSURL *)avatarURL clientId:(NSString *)clientId{
    YBMessageUser *user = [[YBMessageUser alloc] initWithUserId:userId name:name avatarURL:avatarURL clientId:clientId];
    return user;
}

- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)name avatarURL:(NSURL *)avatarURL {
    return [self initWithUserId:userId name:name avatarURL:avatarURL clientId:userId];
}

+ (instancetype)userWithUserId:(NSString *)userId name:(NSString *)name avatarURL:(NSURL *)avatarURL {
    return [self userWithUserId:userId name:name avatarURL:avatarURL clientId:userId];
}

- (instancetype)initWithClientId:(NSString *)clientId {
    return [self initWithUserId:nil name:nil avatarURL:nil clientId:clientId];
}

+ (instancetype)userWithClientId:(NSString *)clientId {
    return [self userWithUserId:nil name:nil avatarURL:nil clientId:clientId];
}

- (BOOL)isEqualToUer:(YBMessageUser *)user {
    return (user.userId == self.userId);
}

- (id)copyWithZone:(NSZone *)zone {
    return [[YBMessageUser alloc] initWithUserId:self.userId
                                       name:self.name
                                  avatarURL:self.avatarURL
                                   clientId:self.clientId
            ];
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
    [aCoder encodeObject:self.clientId forKey:@"clientId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]){
        _userId = [aDecoder decodeObjectForKey:@"userId"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
        _clientId = [aDecoder decodeObjectForKey:@"clientId"];
    }
    return self;
}

- (void)saveToDiskWithKey:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)loadFromDiskWithKey:(NSString *)key {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    id result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return result;
}

@end
