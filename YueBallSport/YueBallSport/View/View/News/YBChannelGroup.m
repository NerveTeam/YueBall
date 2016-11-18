//
//  YBChannelGroup.m
//  YueBallSport
//
//  Created by Minlay on 16/11/16.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBChannelGroup.h"
#import "NSDictionary+Safe.h"

@interface YBChannelGroup ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic, copy)YBChannelGroupBlock block;
@property(nonatomic, strong)NSArray *dataList;
@end

@implementation YBChannelGroup
- (instancetype)initWithItemSize:(CGRect)frame
                      identifier:(NSString *)identifier
           itemHorizontalSpacing:(CGFloat)horizontalSpacing
             itemVerticalSpacing:(CGFloat)verticalSpacing
                 scrollDirection:(UICollectionViewScrollDirection)direction itemClick:(YBChannelGroupBlock)callBack {
    if (self = [super initWithItemSize:frame
                            identifier:identifier
                 itemHorizontalSpacing:horizontalSpacing
                   itemVerticalSpacing:verticalSpacing
                       scrollDirection:direction]) {
     self.block = callBack;
    }
    return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.dataList[indexPath.row];
    NSString *name = [info objectForKeyNotNull:@"channelName"];
    NSInteger cid = [[info objectForKeyNotNull:@"channelId"] longValue];
    if (_block) {
        _block(cid,name);
    }
}
@end
