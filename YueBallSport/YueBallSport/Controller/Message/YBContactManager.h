//
//  YBContactManager.h
//  LeanCloudChatKit-iOS
//
//  v0.8.0 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/3/10.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBContactManager : NSObject
@property (strong, nonatomic) NSMutableArray *contactIDs;

+ (instancetype)defaultManager;


- (NSString *)storeFilePath;

- (NSArray *)fetchContactPeerIds;
- (BOOL)existContactForPeerId:(NSString *)peerId;
- (BOOL)addContactForPeerId:(NSString *)peerId;
- (BOOL)removeContactForPeerId:(NSString *)peerId;


-(NSString *)getFiledPathFriendList;
-(void)delegateFile:(NSString *)filePath;
-(void)wirte:(NSArray *)resultDic writeTo:(NSString *)file;
-(NSArray *)getArrary:(NSString *)filePath;

@end
