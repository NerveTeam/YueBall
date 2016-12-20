//
//  YBMessageViewController+setting.h
//  YueBallSport
//
//  Created by 韩森 on 2016/12/19.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageViewController.h"

@interface YBMessageViewController (setting)

@property (nonatomic,strong)NSMutableArray * allPersonIds;
/**
 *  初始化需要的设置
 */
- (void)YBMessageVC_setting;


#pragma mark - 最近联系人列表的cell设置

- (void)lcck_setupConversationEditActionForConversationList;



#pragma mark - 聊天页面的设置
/**
 *  打开一个会话的操作
 */
- (void)lcck_setupOpenConversation;

#define mark -- 点击cell 进入 聊天详情
//选中某个对话后的回调,设置事件响应函数
-(void)didSelectedConversationCell;

//删除某个对话后的回调
-(void)deleteConversationCell;

/**
 *  设置会话界面的长按操作
 */
- (void)lcck_setupLongPressMessage;

#pragma mark -- 创建群聊
-(void)exampleCreateGroupConversationFromViewController:(UIViewController *)fromViewController;

#pragma mark -- 进入地图界面
-(void)setPreviewLocationMessage;
@end
