//
//  YBGroupChatDetailViewController.h
//  YueBallSport
//
//  Created by 韩森 on 2016/12/13.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
@interface YBGroupChatDetailViewController : UIViewController
@property (nonatomic,strong)AVIMConversation * groupConversation;
@end
