//
//  YBMessageViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageViewController.h"
#import "YBMessageViewController+setting.h"
#define NavgationCenterY 40


#define TITLES @[@"添加好友", @"发起群聊", @"扫一扫",@"添加球队"]
#define ICONS  @[@"motify",@"delete",@"saoyisao",@"pay"]
@interface YBMessageViewController ()<YBPopupMenuDelegate,YBMessageSearchCellDelegate>

@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UISegmentedControl * segmentedCtrol;

@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIView * contactView;
@property (nonatomic,strong)LCCKConversationListViewController *conversationListVC;
@property (nonatomic,strong)LCCKContactListViewController *contactListViewController;


//@property (nonatomic, strong) CCZTableButton *table;
@end

@implementation YBMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //配置信息
//    [self initSettingConversationVC];
    
    self.conversationListVC = [[LCCKConversationListViewController alloc] init];

    
    [self.conversationListVC configureBarButtonItemStyle:LCCKBarButtonItemStyleAdd action:^(UIBarButtonItem *sender, UIEvent *event) {
//        [self showPopOverMenu:sender event:event];
    }];

//     [YBMessageEntranceClass exampleCreateGroupConversationFromViewController:conversationListVC];
    [[LCChatKit sharedInstance] openWithClientId:@"666"
                                        callback:^(BOOL succeeded, NSError *error) {
                                            if (succeeded) {
                                                
                                                [self initSettingConversationVC];
                                                
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
        
        self.contactListViewController.isInfo = YES;
        
        [self.contactView addSubview:self.contactListViewController.view];
        
    }
    
    if (segment.selectedSegmentIndex == 0) {
        
        self.conversationListVC.isInfo = YES;
        [self.contactView addSubview:self.conversationListVC.view];
    }
}

- (NSArray *)allPersonIds {
    NSArray *allPersonIds = [[YBContactManager defaultManager] fetchContactPeerIds];
    return allPersonIds;
}
#pragma mark -- 联系人列表
-(void)setContactListViewController{
    NSString *currentClientID = [[LCChatKit sharedInstance] clientId];

    
    NSArray *users = [[LCChatKit sharedInstance] getCachedProfilesIfExists:self.allPersonIds shouldSameCount:YES error:nil];
    
    self.contactListViewController = [[LCCKContactListViewController alloc] initWithContacts:[NSSet setWithArray:users] userIds:[NSSet setWithArray:self.allPersonIds] excludedUserIds:[NSSet setWithArray:@[currentClientID]] mode:LCCKContactListModeNormal];
    
    
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
        
        //删除好友的接口
        NSLog(@"删除好友---+ %@",peerId);
        
        [[YBContactManager defaultManager] removeContactForPeerId:peerId];
        
        return YES;
    }];
    
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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setUpTANavBar];

    _segmentedCtrol = [[UISegmentedControl alloc]initWithItems:@[@"消息",@"联系人"]];
    _segmentedCtrol.frame =CGRectMake(0, 0, self.view.frame.size.width/5*2.0, 28.0);

    
    NSDictionary * colorAttr = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:YBMESSAGE_NavgationBarBackGroundColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"SnellRoundhand-Bold" size:15],NSForegroundColorAttributeName ,nil];
    
    [_segmentedCtrol setTitleTextAttributes:dic forState:UIControlStateSelected];
    //设置标题的颜色 字体和大小 阴影和阴影颜色
    [_segmentedCtrol setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    _segmentedCtrol.tintColor = [UIColor whiteColor];
    
    _segmentedCtrol.selectedSegmentIndex = 0;
    
    [_segmentedCtrol addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedCtrol;
    
    
    //默认点击了第一个segment
    [self segmentedClick:_segmentedCtrol];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 23, 23);
    [rightBtn setImage:[[UIImage imageNamed:@"jiahao"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addFunction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tintColor = [UIColor whiteColor];

    //导航右按钮
    UIBarButtonItem *rightB =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightB;
    
    
}
#pragma mark -- 右上角 加号
-(void)addFunction:(UIButton *)button{
    
     [YBPopupMenu showRelyOnView:button titles:TITLES icons:ICONS menuWidth:150 delegate:self];
   
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    
    switch (index) {
        case 0:
        {
            //添加好友——> 针对于只添加 userId -> 业务逻辑： 添加好友完毕，会从新刷新联系人列表（从新获取联系人数据源）
            self.navigationController.navigationBar.hidden = NO;
            self.dataManager = [[DataManager alloc]init];
            
            SearchMainTableViewController * vc = [[SearchMainTableViewController alloc]init];
            vc.delegate = self;
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
            //创建群聊
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


#pragma mark -- 点击searchTableViewController上的cell
-(void)selectIndex:(NSInteger)index searchModel:(DemoModel *)model{
    
    //添加好友接口
    
    
    
    NSString *additionUserId = model.friendName;
    NSMutableSet *addedUserIds = [NSMutableSet setWithSet:self.contactListViewController.userIds];
    [addedUserIds addObject:additionUserId];
    self.contactListViewController.userIds = [addedUserIds copy];

}


-(void)initSettingConversationVC{
    
    //配置 联系人列表  信息
    [self setContactListViewController];
    
    [self lcck_setupConversationEditActionForConversationList];
    
    [self didSelectedConversationCell];
    [self deleteConversationCell];
    
    [self lcck_setupOpenConversation];
    //设置会话界面的长按操作
    [self lcck_setupLongPressMessage];
    
    [self setPreviewLocationMessage];
    
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
