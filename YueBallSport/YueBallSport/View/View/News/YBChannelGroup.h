//
//  YBChannelGroup.h
//  YueBallSport
//
//  Created by Minlay on 16/11/16.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBBaseCollectionView.h"

typedef void(^YBChannelGroupBlock)(NSInteger channelId,NSString *channelName);

@interface YBChannelGroup : YBBaseCollectionView
- (instancetype)initWithItemSize:(CGRect)frame
                      identifier:(NSString *)identifier
           itemHorizontalSpacing:(CGFloat)horizontalSpacing
             itemVerticalSpacing:(CGFloat)verticalSpacing
                 scrollDirection:(UICollectionViewScrollDirection)direction itemClick:(YBChannelGroupBlock)callBack;
@end
