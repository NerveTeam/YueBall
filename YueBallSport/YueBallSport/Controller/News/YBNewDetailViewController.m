//
//  YBNewDetailViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/12.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewDetailViewController.h"
#import "MLMeunView.h"
#import "YBFileHelper.h"
#import "NSDictionary+Safe.h"
#import "SDCycleScrollView.h"

@interface YBNewDetailViewController ()
// 菜单
@property(nonatomic, strong)MLMeunView *meunView;
// 频道数据
@property(nonatomic, strong)NSDictionary *channelData;

@property(nonatomic, strong)SDCycleScrollView *cycleView;
@end

@implementation YBNewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cycleView];
    [self.view addSubview:self.meunView];
    [self.meunView show];
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"园园大傻X",
                        @"呵呵好呵呵好",
                        @"哈哈哈哈哈哈"
                        ];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _cycleView.imageURLStringsGroup = imagesURLStrings;
            _cycleView.titlesGroup = titles;
    });
}

#pragma mark - lazy
- (MLMeunView *)meunView {
    if (!_meunView) {
        _meunView = [[MLMeunView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleView.frame), self.view.width, 50) titles:[self.channelData objectForKeyNotNull:@"titles"] viewcontrollersInfo:[self.channelData objectForKeyNotNull:@"viewcontrollers"] isParameter:NO];
    }
    return _meunView;
}
- (NSDictionary *)channelData {
    if (!_channelData) {
        _channelData = [[YBFileHelper getChannelConfig] objectForKeyNotNull:@"news"];
    }
    return _channelData;
}
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, self.view.width * 0.5) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.currentPageDotColor = [UIColor whiteColor];
    }
    return _cycleView;
}
@end
