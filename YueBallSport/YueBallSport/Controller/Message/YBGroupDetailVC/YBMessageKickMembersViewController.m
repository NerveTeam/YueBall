//
//  YBMessageKickMembersViewController.m
//  YueBallSport
//
//  Created by 韩森 on 2016/12/28.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBMessageKickMembersViewController.h"
#import "DemoModel.h"
@interface YBMessageKickMembersViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    long index;
}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation YBMessageKickMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"踢出群聊";
    self.tableView.backgroundColor = [UIColor whiteColor];
    
}
#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    YBMessageModel * model = self.sourceArray[indexPath.row];
    cell.textLabel.text = model.uid;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    index = indexPath.row;
    YBMessageModel * model = self.sourceArray[index];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"踢人操作" message:[NSString stringWithFormat:@"detail: %@",model.uid ] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];

    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //确定
    if (buttonIndex == 1) {
        
        YBMessageModel * model = self.sourceArray[index];
        [self.groupConversation removeMembersWithClientIds:@[model.uid] callback:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                DLog(@"踢人成功");
            }else{
                DLog(@"踢人失败");
            }
        }];
    }
}
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
