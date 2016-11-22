//
//  YBNewsViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewsViewController.h"
#import "MLMeunView.h"


@interface YBNewsViewController ()
// 菜单
@property(nonatomic, strong)MLMeunView *meunView;
// 频道数据
@property(nonatomic, strong)NSArray *channelData;
// 导航背景
@property(nonatomic, strong)UIView *topBarView;
@end

@implementation YBNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopBar];
}


// init菜单
- (void)initTopBar {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBarView];
    [self.view addSubview:self.meunView];
    [self.meunView show];
}


#pragma mark - lazy
- (MLMeunView *)meunView {
    if (!_meunView) {
        _meunView = [[MLMeunView alloc]initWithFrame:CGRectMake(0, StatusBarHeight, self.topBarView.width, TopBarHeight) titles:@[@"新闻",@"直播"] viewcontrollersInfo:self.channelData isParameter:NO];
    }
    return _meunView;
}
- (NSArray *)channelData {
    if (!_channelData) {
        _channelData = @[@"YBHotNewsViewController",@"YBLiveViewController"];
    }
    return _channelData;
}
- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView.backgroundColor = RGBACOLOR(4, 147, 71, 1);
    }
    return _topBarView;
}
@end
