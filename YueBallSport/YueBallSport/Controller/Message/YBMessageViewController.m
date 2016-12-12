//
//  YBMessageViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageViewController.h"
#import "YBMessageConstant.h"
#import "YBMessageMapViewController.h"
#import "YBContactManager.h"
#import "YBPopupMenu.h"
#define NavgationCenterY 40


#define TITLES @[@"添加好友", @"发起群聊", @"扫一扫",@"添加球队"]
#define ICONS  @[@"motify",@"delete",@"saoyisao",@"pay"]
@interface YBMessageViewController ()<YBPopupMenuDelegate>

@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UISegmentedControl * segmentedCtrol;
@property (nonatomic,strong)UIButton * infoBtn;
@property (nonatomic,strong)UIButton * contactBtn;
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIView * contactView;
@property (nonatomic,strong)LCCKConversationListViewController *conversationListVC;
@property (nonatomic,strong)LCCKContactListViewController *contactListViewController;


@property (nonatomic,strong)NSMutableArray * allPersonIds;

//@property (nonatomic, strong) CCZTableButton *table;
@end

@implementation YBMessageViewController
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //配置信息
    [self initSettingConversationVC];
    
    self.conversationListVC = [[LCCKConversationListViewController alloc] init];

    
    [self.conversationListVC configureBarButtonItemStyle:LCCKBarButtonItemStyleAdd action:^(UIBarButtonItem *sender, UIEvent *event) {
//        [self showPopOverMenu:sender event:event];
    }];

//     [YBMessageEntranceClass exampleCreateGroupConversationFromViewController:conversationListVC];
    
    
    [[LCChatKit sharedInstance] openWithClientId:@"666"
                                        callback:^(BOOL succeeded, NSError *error) {
                                            if (succeeded) {
            //可以保存用户信息
                                                
                                                
                                            } else {
        //展示 登录失败
                                            }
                                        }];
    
    [self initSubViews];
}
#pragma mark -- 切换SegmentedControl
-(void)segmentedClick:(UISegmentedControl *)segment{
        
    for (UIView * view in self.contactView.subviews) {
        [view removeFromSuperview];
    }
    
    if (segment.selectedSegmentIndex == 1) {
        
        self.title = @"联系人";
        self.contactListViewController.isInfo = YES;
        
        [self.contactView addSubview:self.contactListViewController.view];
        
    }
    
    if (segment.selectedSegmentIndex == 0) {
        self.title = @"消息";
        self.conversationListVC.isInfo = YES;
        [self.contactView addSubview:self.conversationListVC.view];
    }
}
- (void)setUpTANavBar {
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarTintColor:YBMESSAGE_NavgationBarBackGroundColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
}
-(void)initSubViews{
    
    [self contant];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setUpTANavBar];

    
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navView.backgroundColor = YBMESSAGE_NavgationBarBackGroundColor;
    [self.view addSubview:navView];
    
    _segmentedCtrol = [[UISegmentedControl alloc]initWithItems:@[@"消息",@"联系人"]];
    _segmentedCtrol.bounds =CGRectMake(0, 0, 200, 30.0);
    _segmentedCtrol.center = CGPointMake(navView.frame.size.width/2, NavgationCenterY);
    
    NSDictionary * colorAttr = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:YBMESSAGE_NavgationBarBackGroundColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"SnellRoundhand-Bold" size:15],NSForegroundColorAttributeName ,nil];
    
    [_segmentedCtrol setTitleTextAttributes:dic forState:UIControlStateSelected];
    //设置标题的颜色 字体和大小 阴影和阴影颜色
    [_segmentedCtrol setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    _segmentedCtrol.tintColor = [UIColor whiteColor];
    
    _segmentedCtrol.selectedSegmentIndex = 0;
    
    [_segmentedCtrol addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = _segmentedCtrol;
    
    [navView addSubview:_segmentedCtrol];
    
    //默认点击了第一个segment
    [self segmentedClick:_segmentedCtrol];
    
    //导航右按钮
//    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFunction)];
//    self.navigationItem.rightBarButtonItem=rightBtn;
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[[UIImage imageNamed:@"jiahao"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    rightBtn.tintColor = [UIColor whiteColor];
    
    rightBtn.bounds = CGRectMake(0, 0, 23, 23);
    rightBtn.center = CGPointMake(self.view.frame.size.width - 40+15, NavgationCenterY);
    [navView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(addFunction:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.table = [[CCZTableButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightBtn.frame)-100+23, CGRectGetMaxY(rightBtn.frame), 100, 0)];
//    self.table.backgroundColor = [UIColor blackColor];
//    self.table.offsetXOfArrow = 40;
//    self.table.wannaToClickTempToDissmiss = NO;
//    [self.table addItems:@[@"Objective-C",@"Swift",@"C++",@"C",@"Python",@"Javascript"]];
//    [self.table selectedAtIndexHandle:^(NSUInteger index, NSString *itemName) {
//        NSLog(@"%@",itemName);
//    }];
    
}
#pragma mark -- 添加好友
-(void)addFunction:(UIButton *)button{
    
//    [self.table show];
     [YBPopupMenu showRelyOnView:button titles:TITLES icons:ICONS menuWidth:120 delegate:self];
    return;
    
    NSLog(@"添加好友");//针对于只添加 userId -> 业务逻辑： 添加好友完毕，会从新刷新联系人列表（从新获取联系人数据源）
   
    
    

}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSLog(@"点击了 %@ 选项",TITLES[index]);
    
    switch (index) {
        case 0:
        {
            NSString *additionUserId = @"Harry";
            NSMutableSet *addedUserIds = [NSMutableSet setWithSet:self.contactListViewController.userIds];
            [addedUserIds addObject:additionUserId];
            self.contactListViewController.userIds = [addedUserIds copy];
        }
            break;
        case 1:
        {
            [self exampleCreateGroupConversationFromViewController:self.conversationListVC];
        }
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}


- (NSArray *)allPersonIds {
    NSArray *allPersonIds = [[YBContactManager defaultManager] fetchContactPeerIds];
    return allPersonIds;
}
#pragma mark -- 联系人列表
-(void)contant{
    NSString *currentClientID = [[LCChatKit sharedInstance] clientId];
    
    NSArray *users = [[LCChatKit sharedInstance] getCachedProfilesIfExists:self.allPersonIds shouldSameCount:YES error:nil];
    
    _contactListViewController = [[LCCKContactListViewController alloc] initWithContacts:[NSSet setWithArray:users] userIds:[NSSet setWithArray:self.allPersonIds] excludedUserIds:[NSSet setWithArray:@[currentClientID]] mode:LCCKContactListModeNormal];
    
    
    __weak typeof (self)weakSelf = self;
    //联系人界面 -- 进入聊天界面
    [_contactListViewController setSelectedContactCallback:^(UIViewController *viewController, NSString *peerId) {
        
        LCCKConversationViewController *conversationViewController =
        [[LCCKConversationViewController alloc] initWithPeerId:peerId];
        [conversationViewController
         setViewWillDisappearBlock:^(LCCKBaseViewController *viewController, BOOL aAnimated) {
//             [self lcck_hideHUDForView:viewController.view];
         }];


        conversationViewController.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:conversationViewController animated:YES];
        conversationViewController.navigationController.navigationBar.hidden = NO;

         }];
    [_contactListViewController setDeleteContactCallback:^BOOL(UIViewController *viewController, NSString *peerId) {
        [[YBContactManager defaultManager] removeContactForPeerId:peerId];
        return YES;
    }];

}

-(void)initSettingConversationVC{
    
    [YBMessageConfig ChatKitConfig];
    
    [YBMessageConfig registerRemoteNotification];
    //不配置要崩溃
    [YBMessageConfig lcck_setFetchProfiles];
    
    [self lcck_setupConversationEditActionForConversationList];
    
    [self didSelectedConversationCell];
    [self deleteConversationCell];
    
    [self lcck_setupOpenConversation];
    //设置会话界面的长按操作
    [self lcck_setupLongPressMessage];
    
    [self setPreviewLocationMessage];
    
}

#pragma mark - 最近联系人列表的设置

- (void)lcck_setupConversationEditActionForConversationList {
    // 自定义Cell菜单
    [[LCChatKit sharedInstance] setConversationEditActionBlock:^NSArray *(
                                                                          NSIndexPath *indexPath, NSArray<UITableViewRowAction *> *editActions,
                                                                          AVIMConversation *conversation, LCCKConversationListViewController *controller) {
        return [self lcck_exampleConversationEditActionAtIndexPath:indexPath
                                                      conversation:conversation
                                                        controller:controller];
    }];
}
/**
 *  自定义会话的菜单
 *
 *  @param indexPath    点击菜单的index
 *  @param conversation 会话
 *  @param controller   最近联系人列表的控制器
 *
 *  @return 返回UITableViewRowAction类型的数组
 */
- (NSArray *)lcck_exampleConversationEditActionAtIndexPath:(NSIndexPath *)indexPath
                                              conversation:(AVIMConversation *)conversation
                                                controller:(LCCKConversationListViewController *)controller {
    // 如果需要自定义其他会话的菜单，在此编辑
    return [self lcck_rightButtonsAtIndexPath:indexPath conversation:conversation controller:controller];
}

- (NSArray *)lcck_rightButtonsAtIndexPath:(NSIndexPath *)indexPath
                             conversation:(AVIMConversation *)conversation
                               controller:(LCCKConversationListViewController *)controller {
    NSString *title = nil;
    UITableViewRowActionHandler handler = nil;
    [self lcck_markReadStatusAtIndexPath:indexPath
                                   title:&title
                                  handle:&handler
                            conversation:conversation
                              controller:controller];
    UITableViewRowAction *actionItemMore =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                       title:title
                                     handler:handler];
    actionItemMore.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0];
    UITableViewRowAction *actionItemDelete = [UITableViewRowAction
                                              rowActionWithStyle:UITableViewRowActionStyleDefault
                                              title:@"删除"
                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                  [[LCChatKit sharedInstance] deleteRecentConversationWithConversationId:conversation.conversationId];
                                              }];
    
//    UITableViewRowAction *actionItemChangeGroupAvatar = [UITableViewRowAction
//                                                         rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                         title:@"改群头像"
//                                                         handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
////                                                             [[self class] lcck_exampleChangeGroupAvatarURLsForConversationId:conversation.conversationId
////                                                                                                                 shouldInsert:NO];
//                                                         }];
//    actionItemChangeGroupAvatar.backgroundColor = [UIColor colorWithRed:251 / 255.f green:186 / 255.f blue:11 / 255.f alpha:1.0];
    if (conversation.lcck_type == LCCKConversationTypeSingle) {
        return @[ actionItemDelete,actionItemMore ];
    }
    return @[ actionItemDelete];
}

typedef void (^UITableViewRowActionHandler)(UITableViewRowAction *action, NSIndexPath *indexPath);

- (void)lcck_markReadStatusAtIndexPath:(NSIndexPath *)indexPath
                                 title:(NSString **)title
                                handle:(UITableViewRowActionHandler *)handler
                          conversation:(AVIMConversation *)conversation
                            controller:(LCCKConversationListViewController *)controller {
    NSString *conversationId = conversation.conversationId;
    if (conversation.lcck_unreadCount > 0) {
        if (*title == nil) {
            *title = @"标记为已读";
        }
        *handler = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [controller.tableView setEditing:NO animated:YES];
            [[LCChatKit sharedInstance] updateUnreadCountToZeroWithConversationId:conversationId];
        };
    } else {
        if (*title == nil) {
            *title = @"标记为未读";
        }
        *handler = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [controller.tableView setEditing:NO animated:YES];
            [[LCChatKit sharedInstance] increaseUnreadCountWithConversationId:conversationId];
        };
    }
}


#pragma mark - 聊天页面的设置
/**
 *  打开一个会话的操作
 */
- (void)lcck_setupOpenConversation {
    [[LCChatKit sharedInstance] setFetchConversationHandler:^(
                                                              AVIMConversation *conversation,
                                                              LCCKConversationViewController *aConversationController) {
        if (!conversation.createAt) { //如果没有创建时间，直接return
            return;
        }
//        [[self class] lcck_showMessage:@"加载历史记录..." toView:aConversationController.view];
        //判断会话的成员是否超过两个(即是否为群聊)
        if (conversation.members.count > 2) { //设置点击rightButton为群聊Style,和对应事件
            [aConversationController configureBarButtonItemStyle:LCCKBarButtonItemStyleGroupProfile
                                                          action:^(UIBarButtonItem *sender, UIEvent *event) {
                                                              NSString *title = @"打开群聊详情";
                                                              NSString *subTitle = [NSString stringWithFormat:@"群聊id：%@", conversation.conversationId];
//                                                              [LCCKUtil showNotificationWithTitle:title
//                                                                                         subtitle:subTitle
//                                                                                             type:LCCKMessageNotificationTypeMessage];
                                                          }];
        } else if (conversation.members.count == 2) { //设置点击rightButton为单聊的Style,和对应事件
            [aConversationController
             configureBarButtonItemStyle:LCCKBarButtonItemStyleSingleProfile
             action:^(UIBarButtonItem *sender, UIEvent *event) {
                 NSString *title = @"打开用户详情";
                 NSArray *members = conversation.members;
                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", @[
                                                                                                  [LCChatKit sharedInstance].clientId
                                                                                                  ]];
                 NSString *peerId = [members filteredArrayUsingPredicate:predicate][0];
                 NSString *subTitle = [NSString stringWithFormat:@"用户id：%@", peerId];
//                 [LCCKUtil showNotificationWithTitle:title
//                                            subtitle:subTitle
//                                                type:LCCKMessageNotificationTypeMessage];
             }];
        }
        //系统对话，或暂态聊天室，成员为0，单独处理。参考：系统对话文档
        // https://leancloud.cn/docs/realtime_v2.html#%E7%B3%BB%E7%BB%9F%E5%AF%B9%E8%AF%9D_System_Conversation_
    }];
}

#define mark -- 点击cell 进入 聊天详情
//选中某个对话后的回调,设置事件响应函数
-(void)didSelectedConversationCell{
    
    __weak __typeof(self) weakSelf = self;
    
    
    //选中某个对话后的回调,设置事件响应函数
    [[LCChatKit sharedInstance] setDidSelectConversationsListCellBlock:^(
                                                                         NSIndexPath *indexPath, AVIMConversation *conversation,
                                                                         LCCKConversationListViewController *controller) {
        [weakSelf pushConversationViewController:conversation];
        
    }];
}
-(void)pushConversationViewController:(AVIMConversation *)conversation{
    
    LCCKConversationViewController *conversationViewController =
    [[LCCKConversationViewController alloc] initWithConversationId:conversation.conversationId];
    conversationViewController.enableAutoJoin = YES;
    
    
    
    [conversationViewController
     setViewWillDisappearBlock:^(LCCKBaseViewController *viewController, BOOL aAnimated) {
         //             [self lcck_hideHUDForView:viewController.view];
     }];
    [conversationViewController
     setViewWillAppearBlock:^(LCCKBaseViewController *viewController, BOOL aAnimated) {
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                     animated:aAnimated];
     }];
    
    [conversationViewController setLoadLatestMessagesHandler:^(LCCKConversationViewController *conversationController, BOOL succeeded, NSError *error) {
        
        //            [conversationViewController.tableView reloadData];
    }];
    
    
    
    conversationViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationViewController animated:YES];
    conversationViewController.navigationController.navigationBar.hidden = NO;

}

//删除某个对话后的回调
-(void)deleteConversationCell{
    
    //删除某个对话后的回调 (一般不需要做处理)
    [[LCChatKit sharedInstance] setDidDeleteConversationsListCellBlock:^(
                                                                         NSIndexPath *indexPath, AVIMConversation *conversation,
                                                                         LCCKConversationListViewController *controller){
        // TODO:
    }];
}


/**
 *  设置会话界面的长按操作
 */
- (void)lcck_setupLongPressMessage {
    [[LCChatKit sharedInstance] setLongPressMessageBlock:^NSArray<UIMenuItem *> *(
                                                                                  LCCKMessage *message, NSDictionary *userInfo) {
        LCCKMenuItem *copyItem = [[LCCKMenuItem alloc]
                                  initWithTitle:LCCKLocalizedStrings(@"copy")
                                  block:^{
                                      UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                      [pasteboard setString:[message text]];
                                  }];
        
        LCCKConversationViewController *conversationViewController =
        userInfo[LCCKLongPressMessageUserInfoKeyFromController];
        //设置弹出的菜单选项和对应操作
        LCCKMenuItem *transpondItem = [[LCCKMenuItem alloc]
                                       initWithTitle:LCCKLocalizedStrings(@"transpond")
                                       block:^{
//                                           [self lcck_transpondMessage:message
//                                          toConversationViewController:conversationViewController];
                                       }];
        NSArray *menuItems = [NSArray array];
        if (message.mediaType == kAVIMMessageMediaTypeText) {
            menuItems = @[ copyItem, transpondItem ];
        }
        return menuItems;
    }];
}

#pragma mark -- 创建群聊
-(void)exampleCreateGroupConversationFromViewController:(UIViewController *)fromViewController {
    // FIXME: add more to allPersonIds
    NSArray *allPersonIds = [[YBContactManager defaultManager] fetchContactPeerIds];
    NSArray *users = [[LCChatKit sharedInstance] getCachedProfilesIfExists:allPersonIds
                                                           shouldSameCount:YES
                                                                     error:nil];
    NSString *currentClientID = [[LCChatKit sharedInstance] clientId];
    LCCKContactListViewController *contactListViewController =
    [[LCCKContactListViewController alloc]
     initWithContacts:[NSSet setWithArray:users]
     userIds:[NSSet setWithArray:allPersonIds]
     excludedUserIds:[NSSet setWithArray:@[ currentClientID ]]
     mode:LCCKContactListModeMultipleSelection];
    contactListViewController.title = @"创建群聊";
    [contactListViewController setSelectedContactsCallback:^(UIViewController *viewController,
                                                             NSArray<NSString *> *peerIds) {
        if (!peerIds || peerIds.count == 0) {
            return;
        }
//        [self lcck_showMessage:@"创建群聊..." toView:fromViewController.view];
        [[LCChatKit sharedInstance]
         createConversationWithMembers:peerIds
         type:LCCKConversationTypeGroup
         unique:YES
         callback:^(AVIMConversation *conversation, NSError *error) {
//             [self lcck_hideHUDForView:fromViewController.view];
             if (conversation) {
                 
                 [self pushConversationViewController:conversation];
                 
//                 [self lcck_showSuccess:@"创建成功"
//                                 toView:fromViewController.view];
//                 [self
//                  exampleOpenConversationViewControllerWithConversaionId:
//                  conversation.conversationId
//                  fromNavigationController:
//                  viewController
//                  .navigationController];
             } else {
                 NSLog(@"创建失败");
//                 [self lcck_showError:@"创建失败"
//                               toView:fromViewController.view];
             }
         }];
    }];
//    UINavigationController *navigationViewController =
//    [[UINavigationController alloc] initWithRootViewController:contactListViewController];
//    [self presentViewController:contactListViewController animated:YES completion:nil];
    [self.navigationController pushViewController:contactListViewController animated:YES];
    contactListViewController.navigationController.navigationBar.hidden = NO;
}

#pragma mark -- 进入地图界面
-(void)setPreviewLocationMessage{
    
    __weak __typeof(self) weakSelf = self;
    [[LCChatKit sharedInstance]setPreviewLocationMessageBlock:^(CLLocation *location, NSString *geolocations, NSDictionary *userInfo) {
        NSLog(@"geolocations---%@ \n  userInfo-%@",geolocations,userInfo);
        YBMessageMapViewController * locationVC = [[YBMessageMapViewController alloc]initWithLocation:location];
        locationVC.subtitle = geolocations;
        [weakSelf.navigationController pushViewController:locationVC animated:YES];
        
    }];

}

-(UIView *)contactView{
    
    if (!_contactView) {
        _contactView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64-49)];
        [self.view addSubview:_contactView];
    }
    return _contactView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
