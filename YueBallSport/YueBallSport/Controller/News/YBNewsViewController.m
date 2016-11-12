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
@end

@implementation YBNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self initTopBar];
}


// init菜单
- (void)initTopBar {
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.meunView];
}
//- (void)viewWillLayoutSubviews {
//
//}



#pragma mark - lazy
- (MLMeunView *)meunView {
    if (!_meunView) {
        _meunView = [[MLMeunView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 44) titles:@[@"新闻",@"直播"] viewcontrollersInfo:self.channelData isParameter:NO];
    }
    return _meunView;
}
- (NSArray *)channelData {
    if (!_channelData) {
        _channelData = @[@"YBNewDetailViewController",@"YBLiveViewController"];
    }
    return _channelData;
}
@end
