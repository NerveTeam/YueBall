//
//  YBMessageKickMembersViewController.h
//  YueBallSport
//
//  Created by 韩森 on 2016/12/28.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBMessageModel.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
@interface YBMessageKickMembersViewController : UIViewController

@property (nonatomic,strong)NSMutableArray<YBMessageModel *> *sourceArray;
@property (nonatomic,strong)AVIMConversation * groupConversation;


@end
