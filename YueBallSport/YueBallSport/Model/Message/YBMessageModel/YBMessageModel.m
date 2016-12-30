//
//  YBMessageModel.m
//  YueBallSport
//
//  Created by 韩森 on 2016/12/2.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageModel.h"

@implementation YBMessageModel

+ (YBMessageModel *) modelWithName:(NSString *)userName friendId:(NSString *)uid image:(NSString *)image{
    
    YBMessageModel *newDemoModel = [[self alloc]init];
    newDemoModel.userName = userName;
    newDemoModel.uid = uid;
    newDemoModel.headIcon = image;
    return newDemoModel;
    
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.uid = [decoder decodeObjectForKey:@"uid"];
    self.userName = [decoder decodeObjectForKey:@"userName"];
    self.headIcon = [decoder decodeObjectForKey:@"headIcon"];
//    self.categories = [decoder decodeObjectForKey:@"categories"];
//    self.available = [decoder decodeBoolForKey:@"available"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.headIcon forKey:@"headIcon"];
//    [encoder encodeObject:self.categories forKey:@"categories"];
//    [encoder encodeBool:[self isAvailable] forKey:@"available"];
}

@end
