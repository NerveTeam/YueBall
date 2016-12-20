//
//  YBContactManager.m
//  LeanCloudChatKit-iOS
//
//  v0.8.0 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/3/10.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "YBContactManager.h"
#import "YBMessageConstant.h"

#if __has_include(<ChatKit/LCChatKit.h>)
    #import <ChatKit/LCChatKit.h>
#else
    #import "LCChatKit.h"
#endif
#import "YBMessageConfig.h"
#import "YBMessageModel.h"
#import "MJExtension.h"
@interface YBContactManager ()

@property (strong, nonatomic) NSMutableArray *contactIDs;

@end

@implementation YBContactManager

/**
 * create a singleton instance of YBContactManager
 */
+ (instancetype)defaultManager {
    static YBContactManager *_sharedYBContactManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedYBContactManager = [[self alloc] init];
    });
    return _sharedYBContactManager;
}

- (NSMutableArray *)contactIDs {
    if (!_contactIDs) {
        _contactIDs = [NSMutableArray arrayWithContentsOfFile:[self storeFilePath]];
        if (!_contactIDs) {
            _contactIDs = [NSMutableArray array];
            
            YBMessageConfig * config = [[YBMessageConfig alloc]init];
            
            for (YBMessageModel * model in [config LCCKContactProfilesArr]) {
                
                  [_contactIDs addObject:model.userId];
            }
            
//            for (NSArray *contacts in __LCCKContactsOfSections) {
//                [_contactIDs addObjectsFromArray:contacts];
//            }
            [_contactIDs writeToFile:[self storeFilePath] atomically:YES];
        }
    }
    return _contactIDs;
}

- (NSArray *)fetchContactPeerIds {
    return self.contactIDs;
}

- (BOOL)existContactForPeerId:(NSString *)peerId {
    return [self.contactIDs containsObject:peerId];
}

- (BOOL)addContactForPeerId:(NSString *)peerId {
    if (!peerId) {
        return NO;
    }
    [self.contactIDs addObject:peerId];
    return [self saveContactIDs];
}

- (BOOL)removeContactForPeerId:(NSString *)peerId {
    if (!peerId) {
        return NO;
    }
    if (![self existContactForPeerId:peerId]) {
        return NO;
    }
    
    [self.contactIDs removeObject:peerId];
    
    return [self saveContactIDs];
}

- (BOOL)saveContactIDs {
    if (_contactIDs) {
        return [_contactIDs writeToFile:[self storeFilePath] atomically:YES];
    }
    return YES;
}

- (NSString *)storeFilePath {
    NSString *fileName = [NSString stringWithFormat:@"YBContacts%@.plist", [LCChatKit sharedInstance].clientId];
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    return path;
}

@end
