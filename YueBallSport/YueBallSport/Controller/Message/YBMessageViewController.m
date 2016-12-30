//
//  YBMessageViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageViewController.h"
#import "YBMessageViewController+setting.h"
#import "DataRequest.h"
#import "NSDictionary+Safe.h"
#import "YBMessageModel.h"
#import "MJExtension.h"
#define NavgationCenterY 40


#define TITLES @[@"添加好友", @"发起群聊", @"扫一扫",@"添加球队"]
#define ICONS  @[@"motify",@"delete",@"saoyisao",@"pay"]
@interface YBMessageViewController ()<YBPopupMenuDelegate,YBMessageSearchCellDelegate,DataRequestDelegate>

@property (nonatomic,strong)UIView * backView;


@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIView * contactView;
@property (nonatomic,strong)LCCKConversationListViewController *conversationListVC;
@property (nonatomic,strong)LCCKContactListViewController *contactListViewController;


//@property (nonatomic, strong) CCZTableButton *table;
@end

@implementation YBMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //当从创建群聊里页面返回时，正好 是 _segmentedCtrol.selectedSegmentIndex =0；、、设置都在对应功能那里  设置
    //添加好友的时候，  _segmentedCtrol.selectedSegmentIndex 是  = 1；
    [self segmentedClick:_segmentedCtrol];
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


    [[LCChatKit sharedInstance] openWithClientId:@"21"
                                        callback:^(BOOL succeeded, NSError *error) {
                                            if (succeeded) {

                                                NSDictionary * dict = @{
                                                                        @"selfuid" : YBMessageUserId
                                                                        };
                                                [FriendListRequest requestDataWithParameters:dict successBlock:^(YTKRequest *request) {
                                                    
                                                    DLog(@"获取好友列表 数组 %@",request.responseString);
                                                    
                                                    NSString *status = [request.responseObject  objectForKeyNotNull:@"status"];
                                                    if ([status isEqualToString:@"0"]) {
                                                        NSMutableArray *data = [request.responseObject objectForKeyNotNull:@"msg"];
                                                        NSArray *list = [YBMessageModel mj_objectArrayWithKeyValuesArray:data];
                                                        
                                                        
                                                        //把获取到的好友列表 数据 存储到本地
                                                        YBContactManager * yb =[YBContactManager defaultManager];
                                                        
                                                        [yb delegateFile:[yb getFiledPathFriendList]];
                                                        
                                                        [yb wirte:list writeTo:[yb getFiledPathFriendList]];
                                                        
                                                        [YBMessageConfig lcck_setFetchProfiles];
                                                        
                                                        //配置 联系人列表  信息-- 当第一次没有好友的时候，不会执行，所以在添加好友的时候 初始化 联系人列表；**********
                                                        [self setContactListViewController];
                                                        
                                                        //此操作是说明，当_segmentedCtrol.selectedSegmentIndex == 1；且数据还没 收到的时候，重新刷新下联系人列表
                                                        if (_segmentedCtrol.selectedSegmentIndex == 1) {
                                                            [self segmentedClick:_segmentedCtrol];
                                                        }
                                                    }
                                                    
                                                } failureBlock:^(YTKRequest *request) {
                                                    DLog(@"获取好友列表 数组 失败=%@",request.error);
                                                }];
                                                
  
                                            } else {
                                                //展示 登录失败
                                            }
                                        }];
    
   
    
    [self initSubViews];
}

-(void)getFriendsSource{
    
  
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
#pragma mark 删除好友
-(void)setContactListViewController{
    NSString *currentClientID = [[LCChatKit sharedInstance] clientId];

    
    NSArray *users = [[LCChatKit sharedInstance] getCachedProfilesIfExists:self.allPersonIds shouldSameCount:YES error:nil];

    
    [self.contactListViewController.view removeFromSuperview];
    self.contactListViewController = nil;
    
    
    
    self.contactListViewController = [[LCCKContactListViewController alloc] initWithContacts:[NSSet setWithArray:users] userIds:[NSSet setWithArray:self.allPersonIds] excludedUserIds:[NSSet setWithArray:@[currentClientID]] mode:LCCKContactListModeNormal];
    
   
    __weak typeof (self)weakSelf = self;
    //联系人界面 -- 进入聊天界面
    [self.contactListViewController setSelectedContactCallback:^(UIViewController *viewController, NSString *peerId) {
        
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
        
        
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setSafeObject:currentClientID forKey:@"muid"];
        [dict setSafeObject:peerId forKey:@"fuid"];
        [dict setSafeObject:@"2" forKey:@"actionType"];
        
        
        [AddFriendRequest requestDataWithParameters:dict successBlock:^(YTKRequest *request) {
            //            DLog(@"删除好友   成功---+ %@",request.responseString);
            
            //删除好友的接口
            //            DLog(@"删除好友---+ %@",peerId);
            
            [[YBContactManager defaultManager] removeContactForPeerId:peerId];
            
        } failureBlock:^(YTKRequest *request) {
            //            DLog(@"删除好友-  失败--+ %@",request.error);
        }];
        
#warning 删除对方的同时，也把当前用户从对方好友列表里面删除掉
        NSMutableDictionary * dict2 = [[NSMutableDictionary alloc]init];
        [dict2 setSafeObject:peerId forKey:@"muid"];
        [dict2 setSafeObject:currentClientID forKey:@"fuid"];
        [dict2 setSafeObject:@"2" forKey:@"actionType"];
        
        
        [AddFriendRequest requestDataWithParameters:dict2 successBlock:^(YTKRequest *request) {
            //            DLog(@"删除好友   成功---+ %@",request.responseString);
            //
            //            //删除好友的接口
            //            DLog(@"删除好友---+ %@",peerId);
            
            [[YBContactManager defaultManager] removeContactForPeerId:peerId];
            
        } failureBlock:^(YTKRequest *request) {
            //            DLog(@"删除好友-  失败--+ %@",request.error);
        }];
        
        
        
        
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
#pragma mark 添加好友
-(void)selectIndex:(NSInteger)index searchModel:(DemoModel *)model{
    

    if (model.friendId.length>0) {
        
        if ([model.friendId isEqualToString:YBMessageUserId]) {
  
#warning 不能添加自己为好友
            DLog(@"不能添加自己为好友");
            
            return;
        }
        
    }

    
    //添加好友接口 -> 添加成功后再重新获取好友列表（数据库操作完毕后），然后进行 leanCloud 的业务逻辑
    
//    NSDictionary * dict = @{};
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setSafeObject:YBMessageUserId forKey:@"muid"];
    [dict setSafeObject:model.friendId forKey:@"fuid"];
    [dict setSafeObject:@"1" forKey:@"actionType"];
    
    [AddFriendRequest requestDataWithParameters:dict successBlock:^(YTKRequest *request) {
        
         DLog(@"添加好友接口 %@",request.responseString);
        
        NSString *status = [request.responseObject objectForKeyNotNull:@"status"];
        
        DLog(@"添加好友接口status=====%@",status);
        DLog(@"添加好友接口msg=====%@",[request.responseObject objectForKeyNotNull:@"msg"]);
        if ([status isEqualToString:@"-2"]) {
            
            NSString * msg = [request.responseObject objectForKeyNotNull:@"msg"];
            DLog(@"添加好友  =%@",msg);
            
            return ;
        }
        
        if ( [status isEqualToString:@"0"]) {
            
            {
            

                NSMutableDictionary * dict33 = [[NSMutableDictionary alloc]init];
                
                [dict33 setSafeObject:YBMessageUserId forKey:@"selfuid"];
                
    
               
                [FriendListRequest requestDataWithParameters:dict33 successBlock:^(YTKRequest *request) {
                    
                    NSLog(@"获取好友列表 数组 %@",request.responseString);
                    
                    NSString *status = [request.responseObject  objectForKeyNotNull:@"status"];
                    if ([status isEqualToString:@"0"]) {
                        NSMutableArray *data = [request.responseObject objectForKeyNotNull:@"msg"];
                        NSArray *list = [YBMessageModel mj_objectArrayWithKeyValuesArray:data];
                        
                        
                        //重新获取好友列表，然后重新存储
                        
                        YBContactManager * yb =[YBContactManager defaultManager];
                        
                        [yb delegateFile:[yb getFiledPathFriendList]];
                        [yb wirte:list writeTo:[yb getFiledPathFriendList]];
                        
                        
                        [yb delegateFile:[yb storeFilePath]];
                        
                        [YBContactManager defaultManager].contactIDs = nil;
                        
    //当第一次添加好友的时候 才会创建 联系人列表
                        static int  a = 0;
                        if (a==0) {
                            [self setContactListViewController];
                            [YBMessageConfig lcck_setFetchProfiles];
                        }

    //    添加完毕，然后刷新联系人界面
                        NSString *additionUserId = model.friendId;
                        NSMutableSet *addedUserIds = [NSMutableSet setWithSet:self.contactListViewController.userIds];
                        [addedUserIds addObject:additionUserId];
                        self.contactListViewController.userIds = [addedUserIds copy];
                        
                        
                        _segmentedCtrol.selectedSegmentIndex =1;
                        //默认点击了第 二个segment 跳转到 联系人列表
                        [self segmentedClick:_segmentedCtrol];

                       
                    }
                    
                } failureBlock:^(YTKRequest *request) {
                    DLog(@"获取好友列表 dictGetGroup数组 %@",request.error);
                }];
            
            }

        }
    } failureBlock:^(YTKRequest *request) {
         DLog(@"添加好友接口request.error %@",request.error);
    }];
   
#warning //让对方  也把当前用户成为好友
    //让对方  也把当前用户成为好友
    
    NSMutableDictionary * dict2 = [[NSMutableDictionary alloc]init];
    [dict2 setSafeObject:model.friendId forKey:@"muid"];
    [dict2 setSafeObject:YBMessageUserId forKey:@"fuid"];
    [dict2 setSafeObject:@"1" forKey:@"actionType"];
    [AddFriendRequest requestDataWithParameters:dict2 successBlock:^(YTKRequest *request) {
        
        DLog(@"添加好友接口 %@",request.responseString);
        
        NSString *status = [request.responseObject objectForKeyNotNull:@"status"];
        
        DLog(@"添加好友接口status=====%@",status);
        DLog(@"添加好友接口msg=====%@",[request.responseObject objectForKeyNotNull:@"msg"]);
        if ([status isEqualToString:@"-2"]) {
            
            NSString * msg = [request.responseObject objectForKeyNotNull:@"msg"];
            DLog(@"添加好友  =%@",msg);
            
            return ;
        }
        
        if ( [status isEqualToString:@"0"]) {
            
            {
                
            }
            
        }
    } failureBlock:^(YTKRequest *request) {
        DLog(@"添加好友接口request.error %@",request.error);
    }];


}


-(void)initSettingConversationVC{
    
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
