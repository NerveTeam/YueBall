//
//  YBGroupChatDetailViewController.m
//  YueBallSport
//
//  Created by 韩森 on 2016/12/13.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBGroupChatDetailViewController.h"
#import "YBMessageModel.h"
#import "MJExtension.h"
#import "YBGroupChatDetailCollectionViewCell.h"
#import "DataRequest.h"
#import <AVOSCloud/AVOSCloud.h>
#import "NSDictionary+Safe.h"

#import "YBContactManager.h"
#import "YBMessageConstant.h"
#import "YBMessageUser.h"
#import "YBMessageKickMembersViewController.h"
#define item_Width (SCREEN_WIDTH-20)/4-10
#define item_Height (SCREEN_WIDTH-20)/4-10+20

@interface YBGroupChatDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSMutableArray * sourceArray;
@property (nonatomic,strong)UICollectionView * collectionView;

@end

@implementation YBGroupChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sourceArray = [[NSMutableArray alloc]init];
    self.title = @"群聊资料";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self getGroupChatDetailSource];
    
    [self addNavgationSubViews];
}
-(void)addNavgationSubViews{
    
    UIBarButtonItem * rightBtn =[[UIBarButtonItem alloc]initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(addGroupFriend)];
    
    UIBarButtonItem * rightBtn2 =[[UIBarButtonItem alloc]initWithTitle:@"踢人" style:UIBarButtonItemStylePlain target:self action:@selector(kipGroupFriend)];
    
//    UIBarButtonItem * rightBtn2 =[[UIBarButtonItem alloc]initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(addGroupFriend2)];
    
    self.navigationItem.rightBarButtonItems = @[rightBtn,rightBtn2];
}
-(void)kipGroupFriend{
    
    YBMessageKickMembersViewController * vc = [[YBMessageKickMembersViewController alloc]init];
    vc.sourceArray = self.sourceArray;
    vc.groupConversation = self.groupConversation;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)addGroupFriend{
    
    
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
    contactListViewController.title = @"邀请好友";
    [contactListViewController setSelectedContactsCallback:^(UIViewController *viewController,
                                                             NSArray<NSString *> *peerIds) {
        
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.groupConversation.members];
        //过滤数组
        NSArray * reslutFilteredArray = [peerIds filteredArrayUsingPredicate:filterPredicate];

       
        if (!peerIds || peerIds.count == 0) {
         
#warning alert
            DLog(@"邀请的好友已在群聊里面");
            
            return;
        }
        //        [self lcck_showMessage:@"创建群聊..." toView:fromViewController.view];
        [[LCChatKit sharedInstance]
         createConversationWithMembers:reslutFilteredArray
         type:LCCKConversationTypeGroup
         unique:YES
         callback:^(AVIMConversation *conversation, NSError *error) {
             //             [self lcck_hideHUDForView:fromViewController.view];
             if (conversation) {
                 
                 
                 //向该群聊 里邀请 好友
                 
                 
                 NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                 
                 [dict setSafeObject:self.groupConversation.conversationId forKey:@"chatId"];
                 [dict setSafeObject:@"" forKey:@"chatIcon"];
                 [dict setSafeObject:reslutFilteredArray forKey:@"member"];
                 [dict setSafeObject:@"2" forKey:@"actionType"];
                 
                
                 DLog(@"邀请的好友传入参数=======%@",dict);
                 [AddChatIdRequest requestDataWithParameters:dict successBlock:^(YTKRequest *request) {
                     
                     DLog(@"邀请的好友request.responseString--+ %@",request.responseString);
                     
                     NSString *status = [request.responseObject  objectForKeyNotNull:@"status"];
                     if ([status isEqualToString:@"0"]) {
                         

                         __weak __typeof (self)weak = self;
                         
                         [weak.groupConversation addMembersWithClientIds:reslutFilteredArray callback:^(BOOL succeeded, NSError * _Nullable error) {
                             
                             if (succeeded) {
                                 DLog(@"添加好友成功！");
                                 
                                 [self getGroupChatDetailSource];
                                 
                             }else{
                                 DLog(@"添加好友失败！");
                             }
                             
                         }];

                         
                         
                     }
                     
                 } failureBlock:^(YTKRequest *request) {
                     DLog(@"传入参数request.error----+ %@",request.error);
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
    
    navigationViewController.title = @"邀请好友";
    [navigationViewController.navigationBar setTranslucent:YES];
    [navigationViewController.navigationBar setBarTintColor:YBMESSAGE_NavgationBarBackGroundColor];
    [navigationViewController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
}

//获取群聊详情内容
-(void)getGroupChatDetailSource{
    
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    
    [dict setSafeObject:self.groupConversation.conversationId forKey:@"chatId"];
    [dict setSafeObject:@"" forKey:@"chatIcon"];
    [dict setSafeObject:@"" forKey:@"member"];
    [dict setSafeObject:@"1" forKey:@"actionType"];

    
    
    [ChatGroupDetailRequest requestDataWithParameters:dict successBlock:^(YTKRequest *request) {
        
        NSLog(@"获取群聊成员信息 %@",request.responseString);
        NSString *status = [request.responseObject  objectForKeyNotNull:@"status"];
        if ([status isEqualToString:@"0"]) {
            
            NSMutableArray *data = [request.responseObject objectForKeyNotNull:@"msg"];
            NSArray *list = [YBMessageModel mj_objectArrayWithKeyValuesArray:data];
            
            self.sourceArray = [list mutableCopy];
            [self.collectionView reloadData];
        }
        
    } failureBlock:^(YTKRequest *request) {
        
    }];
    
    
}

#pragma mark <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.sourceArray.count;
    }else{
        return  2;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString * identity = @"cell";
        YBGroupChatDetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
        YBMessageModel * model  = self.sourceArray[indexPath.row];
        
        [cell setModel:model];
        
        return cell;
    }else{
        
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
        
        return cell;
        
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return CGSizeMake(item_Width, item_Height);
        
    } else {
        
        return CGSizeMake(self.view.frame.size.width, 44);
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return CGSizeMake(self.view.frame.size.width, 44);
        
    } else {
        return CGSizeZero;
    }
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        reusableview = headerView;
    }
    
    return reusableview;
}


#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * fLayout = [[UICollectionViewFlowLayout alloc]init];
        fLayout.minimumLineSpacing = 15;
        fLayout.minimumInteritemSpacing = 5;
        fLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        fLayout.itemSize = CGSizeMake(item_Width, item_Height);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:fLayout];
        _collectionView.alwaysBounceVertical = YES;
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"YBGroupChatDetailCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];

        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"item"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

//-(NSArray *)sourceArray{
//    
//    
//    //获取文件路径
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"groupscource"ofType:@"json"];
//    
//    //根据文件路径读取数据
//    NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
//    
//    //格式化成json数据
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableContainers error:nil];
//    
//    //    NSString * s = [[NSString alloc]initWithData:jdata encoding:NSUTF8StringEncoding];
//    
//    
//    NSArray * arr = [jsonObject objectForKey:@"member"];
//    
//    NSArray * modelArr = [YBMessageModel mj_objectArrayWithKeyValuesArray:arr];
//    
//    
//    return modelArr;
//    
//}

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
