//
//  YBNewDetailViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/12.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewDetailViewController.h"
#import "MLMeunView.h"

@interface YBNewDetailViewController ()
// 菜单
@property(nonatomic, strong)MLMeunView *meunView;
// 频道数据
@property(nonatomic, strong)NSArray *channelData;
@end

@implementation YBNewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.meunView];
}


#pragma mark - lazy
- (MLMeunView *)meunView {
    if (!_meunView) {
        _meunView = [[MLMeunView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) titles:@[@"中超",@"英超",@"西甲",@"德甲",@"意甲"] viewcontrollersInfo:self.channelData isParameter:NO];
    }
    return _meunView;
}
- (NSArray *)channelData {
    if (!_channelData) {
        _channelData = @[@"YBNewsSportListViewController"
                         ,@"YBNewsSportListViewController"
                         ,@"YBNewsSportListViewController"
                         ,@"YBNewsSportListViewController"
                         ,@"YBNewsSportListViewController"];
    }
    return _channelData;
}
@end
