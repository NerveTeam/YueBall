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
#import "NSArray+Safe.h"
@interface YBContactManager ()

//@property (strong, nonatomic) NSMutableArray *contactIDs;

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
            _contactIDs = [[NSMutableArray alloc]init];
            
            YBMessageConfig * config = [[YBMessageConfig alloc]init];
            
            for (YBMessageModel * model in [config LCCKContactProfilesArr]) {
                
                  [_contactIDs safeAddObject:model.uid];
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


-(NSString *)getFiledPathFriendList{
    NSString * filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/friendList.text"];
    
    return filePath;
}

-(void)delegateFile:(NSString *)filePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = nil;
    BOOL isRemove = [manager removeItemAtPath:filePath error:&error];
    if (isRemove==YES) {
        
        NSLog(@"删除文件成功");
    }else {
        NSLog(@"删除失败-----%@",error);
    }
}
-(void)wirte:(NSArray *)resultDic writeTo:(NSString *)file{
    
    BOOL isExists1 = [[NSFileManager defaultManager] fileExistsAtPath:file];
    if (isExists1 == NO) {
        // 返回值类型,创建成功返回YES,创建失败返回NO
        // 可以根据error看到错误原因
        
        // 可变的数据对象
        NSMutableData * pData = [[NSMutableData alloc]init];
        // 编码器
        NSKeyedArchiver * archiver  = [[NSKeyedArchiver alloc]initForWritingWithMutableData:pData];
        // 编码
        //    [archiver encodeObject:array forKey:@"ARRAY"];
        [archiver encodeObject:resultDic forKey:@"friendlist"];
        // 编码结束的方法
        [archiver finishEncoding];
        // 这时候,pData已经有内容了,可以进行存储
        [pData writeToFile:file atomically:YES];
    }

}

-(NSArray *)getArrary:(NSString *)filePath
{
    // 根据文件路径创建一个NSData
    NSData * pData = [[NSData alloc]initWithContentsOfFile:filePath];
    
    // 解码器
    // 把要解码的data传进去
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:pData];
    // 解码调用方法
    // 解码后得到一个对象,对象类型为编码时的类型
    //    for (int i=0; i<resultDic.count; i++) {
    //
    //        [archiver encodeObject:resultDic[i] forKey:[NSString stringWithFormat:@"%d",i]];
    //    }
    NSArray * arr= [unarchiver decodeObjectForKey:@"friendlist"];
    
    
    return arr;
}



@end
