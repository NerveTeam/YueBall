//
//  YBMessageViewController+setting.m
//  YueBallSport
//
//  Created by 韩森 on 2016/12/19.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageViewController+setting.h"
#import "YBMessageViewController.h"
#import "DataRequest.h"
#import "NSDictionary+Safe.h"

@implementation YBMessageViewController (setting)

- (void)YBMessageVC_setting{
    
    
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

#pragma mark -- 删除某个最近联系人的会话
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




#pragma mark - 聊天页面的设置 -> 打开一个会话的操作 进入群聊详情页面
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
                                                              
                                                              
                                                              
                                                              YBGroupChatDetailViewController * vc = [[YBGroupChatDetailViewController alloc]init];
                                                              vc.groupConversation = conversation;
                                                              [self.navigationController pushViewController:vc animated:YES];
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
#pragma mark -- 创建群聊把群聊ID加入数据库接口
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
                 
                
                 NSString * chatIcon = LCCKTestConversationGroupAvatarURLs[arc4random_uniform(
                                                                                (int)LCCKTestConversationGroupAvatarURLs.count -
                                                                                1)];
                 //插入数据库chat表 ---插入的conversation.conversationId     为群聊ID
                 
                 NSMutableArray * arr = [NSMutableArray arrayWithObject:currentClientID];
                 //把当前用户的id 也加入到创建群聊成员id  中，传给后台服务器
                 [arr addObjectsFromArray:peerIds];
                 
                 
                 NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                 
                 [dict setSafeObject:conversation.conversationId forKey:@"chatId"];
                 [dict setSafeObject:chatIcon forKey:@"chatIcon"];
                 [dict setSafeObject:peerIds forKey:@"member"];
                 [dict setSafeObject:@"0" forKey:@"actionType"];
                 
                 DLog(@"传入参数----+ %@",dict);
                [AddChatIdRequest requestDataWithParameters:dict successBlock:^(YTKRequest *request) {
                     
                     DLog(@"插入数据库chat表--+ %@",request.responseString);
                     
                     NSString *status = [request.responseObject  objectForKeyNotNull:@"status"];
                     if ([status isEqualToString:@"0"]) {
                         
                         self.navigationController.navigationBar.hidden = NO;
                         [self pushConversationViewController:conversation];
                         
                         self.segmentedCtrol.selectedSegmentIndex = 0;
                         //设置群头像
                         [self lcck_exampleChangeGroupAvatarURLsForConversationId:conversation.conversationId inertChatIcon:chatIcon shouldInsert:NO];
                     }
                     
                 } failureBlock:^(YTKRequest *request) {
                     DLog(@"传入参数----+ %@",request.error);
                 }];
                 
                
             } else {
                 DLog(@"创建失败");
                 
             }
         }];
    }];
    UINavigationController *navigationViewController =
    [[UINavigationController alloc] initWithRootViewController:contactListViewController];
    navigationViewController.navigationController.navigationBar.hidden = NO;
    [self presentViewController:navigationViewController animated:YES completion:nil];
    
    navigationViewController.title = @"创建群聊";
    [navigationViewController.navigationBar setTranslucent:YES];
    [navigationViewController.navigationBar setBarTintColor:YBMESSAGE_NavgationBarBackGroundColor];
    [navigationViewController.navigationBar setTintColor:[UIColor whiteColor]];
    
}
#pragma mark -- 设置群头像
- (void)lcck_exampleChangeGroupAvatarURLsForConversationId:(NSString *)conversationId
                                             inertChatIcon:(NSString *)chatIcon shouldInsert:(BOOL)shouldInsert {
    //    [self lcck_showMessage:@"正在设置群头像"];
    [[LCCKConversationService sharedInstance]
     fecthConversationWithConversationId:conversationId
     callback:^(AVIMConversation *conversation, NSError *error) {
         [conversation
          lcck_setObject:
         chatIcon
          forKey:LCCKConversationGroupAvatarURLKey
          callback:^(BOOL succeeded, NSError *error) {
              //              [self lcck_hideHUD];
              if (succeeded) {
                  //                  [self lcck_showSuccess:@"设置群头像成功"];
                  if (shouldInsert) {
                      [[LCChatKit sharedInstance]                   insertRecentConversation:conversation];
                  }
                  [[NSNotificationCenter defaultCenter]
                   postNotificationName:
                   LCCKNotificationConversationListDataSourceUpdated
                   object:self];
              } else {
                  LCCKLog(@"系统对话请通过REST API修改，或者直接到控制台修改"
                          @"APP端不支持直接修改");
                  //                  [self lcck_showError:@"设置群头像失败"];
              }
          }];
     }];
}

#pragma mark -- 进入地图界面
-(void)setPreviewLocationMessage{
    
    __weak __typeof(self) weakSelf = self;
    [[LCChatKit sharedInstance]setPreviewLocationMessageBlock:^(CLLocation *location, NSString *geolocations, NSDictionary *userInfo) {
        DLog(@"geolocations---%@ \n  userInfo-%@",geolocations,userInfo);
        YBMessageMapViewController * locationVC = [[YBMessageMapViewController alloc]initWithLocation:location];
        locationVC.subtitle = geolocations;
        [weakSelf.navigationController pushViewController:locationVC animated:YES];
        
    }];
    
}


@end
