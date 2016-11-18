//
//  YBHotNewsViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/16.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBHotNewsViewController.h"
#import "YBFileHelper.h"
#import "NSDictionary+Safe.h"
#import "SDCycleScrollView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YBNewDetailViewController.h"
#import "NSArray+Safe.h"
#import "YBNewsSportListCell.h"
#import "YBNewsSport.h"
#import "YBArticleViewController.h"

@interface YBHotNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
// 频道数据
@property(nonatomic, strong)NSArray *channelData;
// 焦点图
@property(nonatomic, strong)SDCycleScrollView *cycleView;
// 子导航
@property(nonatomic, strong)UIScrollView *navigationBar;
// 列表
@property(nonatomic, strong)UITableView *hotTableView;
// 分隔
@property(nonatomic, strong)CALayer *separateLine;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic,strong)YBNewsSport *sportList;
@property(nonatomic, strong)NSArray *hotList;
@end

@implementation YBHotNewsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
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
        self.cycleView.imageURLStringsGroup = imagesURLStrings;
        self.cycleView.titlesGroup = titles;
    });
    _currentIndex = 1;
    [self loadData:_currentIndex];
    [self initNavigationBar];
}
- (void)loadData:(NSInteger)page {
    self.sportList = [YBNewsSport requestHotNewsList:@{@"page":@(page)} success:^(NSArray *dataList) {
        [self stopRefresh];
        if (page > 1) {
            if (dataList.count < 20) {
                [self.hotTableView.mj_footer endRefreshingWithNoMoreData];
            }
            NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:self.hotList];
            [temp addObjectsFromArray:dataList];
            self.hotList = temp.copy;
        }else {
            if (dataList.count < 20) {
                [self.hotTableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.hotList = dataList;
        }
        [self.hotTableView reloadData];
    } errorBack:^{
        [self stopRefresh];
    }];
}

- (void)stopRefresh {
    [self.hotTableView.mj_header endRefreshing];
    [self.hotTableView.mj_footer endRefreshing];
}
- (void)initNavigationBar {
    CGFloat margin = 10;
    CGFloat width = 40;
    CGFloat height = 55;
    CGFloat top = 15;
    for (NSInteger i = 0; i < self.channelData.count; i++) {
        CGFloat x = margin + i * width + i * 4 * margin;
        UIButton *item = [[UIButton alloc]initWithFrame:CGRectMake(x, top, width, height)];
        NSDictionary *info = [self.channelData safeObjectAtIndex:i];
        [item setImage:[UIImage imageNamed:[info objectForKeyNotNull:@"icon"]] forState:UIControlStateNormal];
        [item setTitle:[info objectForKeyNotNull:@"title"] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        item.font = [UIFont systemFontOfSize:12];
        [item addTarget:self action:@selector(channelClick:) forControlEvents:UIControlEventTouchUpInside];
        [item layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [self.navigationBar addSubview:item];
        item.tag = i;
        
        if (i == self.channelData.count - 1) {
            self.navigationBar.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), _navigationBar.height);
            break;
        }
        
       CALayer *separateLine = [CALayer layer];
        separateLine.backgroundColor = [UIColor lightGrayColor].CGColor;
        CGFloat height = 30;
        CGFloat Y = (self.navigationBar.height - height) / 2;
        separateLine.frame = CGRectMake(CGRectGetMaxX(item.frame) + 2 * margin, Y, 1, height);
        [self.navigationBar.layer addSublayer:separateLine];

    }
}

- (void)channelClick:(UIButton *)item {
    YBNewDetailViewController *detail = [[YBNewDetailViewController alloc]init];
    detail.channelId = [[[self.channelData safeObjectAtIndex:item.tag] objectForKeyNotNull:@"channelId"] longValue];
    detail.channelName = [[self.channelData safeObjectAtIndex:item.tag] objectForKeyNotNull:@"channelName"];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBNewsSportListCell *cell = [YBNewsSportListCell newsSportListCellWithTableView:tableView];
    cell.sportList = self.hotList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"YBNewsSportListCell" cacheByIndexPath:indexPath configuration:^(YBNewsSportListCell *cell) {
        cell.sportList = self.hotList[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YBNewsSport *sport = self.hotList[indexPath.row];
    YBArticleViewController *article = [[YBArticleViewController alloc]initWithNewsId:[NSString stringWithFormat:@"%ld",sport.newsId]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:article animated:YES];
}

#pragma mark - lazy
- (NSArray *)channelData {
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
        [self.view addSubview:_cycleView];
    }
    return _cycleView;
}
- (UIScrollView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIScrollView alloc]init];
        _navigationBar.frame = CGRectMake(0, self.cycleView.height, self.view.width, 90);
        [self.view addSubview:_navigationBar];
    }
    return _navigationBar;
}
- (CALayer *)separateLine {
    if (!_separateLine) {
        _separateLine = [CALayer layer];
        _separateLine.backgroundColor = [UIColor lightGrayColor].CGColor;
        _separateLine.frame = CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), self.view.width, 1);
        [self.view.layer addSublayer:_separateLine];
    }
    return _separateLine;
}
- (UITableView *)hotTableView {
    if (!_hotTableView) {
        CGFloat Y = CGRectGetMaxY(self.separateLine.frame);
        _hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Y, self.view.width, self.view.height - Y)];
        [_hotTableView registerClass:[YBNewsSportListCell class] forCellReuseIdentifier:NSStringFromClass([YBNewsSportListCell class])];
        _hotTableView.delegate = self;
        _hotTableView.dataSource = self;
        _hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentIndex = 1;
            [self loadData:_currentIndex];
        }];
        _hotTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadData:++_currentIndex];
        }];
        [self.view addSubview:_hotTableView];
    }
    return _hotTableView;
}
@end
