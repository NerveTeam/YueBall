//
//  YBMessageViewController.h
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBBaseViewController.h"
#import "DataManager.h"

#import "YBMessageConstant.h"
#import "YBMessageMapViewController.h"
#import "YBContactManager.h"
#import "YBPopupMenu.h"
#import "YBGroupChatDetailViewController.h"
//#import "YBMessageSearchViewController.h"
#import "SearchMainTableViewController.h"
#import "DemoModel.h"
@interface YBMessageViewController : YBBaseViewController

@property (nonatomic,strong)UISegmentedControl * segmentedCtrol;

@property (strong, nonatomic) DataManager *dataManager;
@property (nonatomic,strong)NSMutableArray * allPersonIds;

-(void)initSettingConversationVC;

@end
