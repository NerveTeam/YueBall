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
#import "YBNewsFoucs.h"


@interface YBHotNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
// 频道数据
@property(nonatomic, strong)NSArray *channelData;
// 头部
@property(nonatomic, strong)UIView *tableviewHeader;
// 焦点图
@property(nonatomic, strong)SDCycleScrollView *cycleView;
// 子导航
@property(nonatomic, strong)UIScrollView *navigationBar;
// 列表
@property(nonatomic, strong)UITableView *hotTableView;
// 分隔
@property(nonatomic, strong)CALayer *separateLine;
// 当前data索引值
@property(nonatomic, assign)NSInteger currentIndex;
// 热门列表请求对象
@property(nonatomic,strong)YBNewsSport *sportList;
// 热门数据
@property(nonatomic, strong)NSArray *hotList;
// 焦点图请求
@property(nonatomic, strong)YBNewsFoucs *newsFoucs;

@property(nonatomic, strong)NSArray *foucsArray;
@end

@implementation YBHotNewsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 1;
    [self loadData:_currentIndex];
    [self initNavigationBar];
}
- (void)loadData:(NSInteger)page {
    
    if (page == 1) {
        self.newsFoucs = [YBNewsFoucs requestNewsFoucs:^(NSArray *dataList) {
            self.foucsArray = dataList;
            [self parseFoucs];
        } error:^{
            
        }];
    }
    
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
        [item setTitleColor:RGBACOLOR(20, 20, 20, 1) forState:UIControlStateNormal];
        item.font = [UIFont systemFontOfSize:14];
        [item addTarget:self action:@selector(channelClick:) forControlEvents:UIControlEventTouchUpInside];
        [item layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [self.navigationBar addSubview:item];
        item.tag = i;
        
        if (i == self.channelData.count - 1) {
            self.navigationBar.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), _navigationBar.height);
            break;
        }
        
       CALayer *separateLine = [CALayer layer];
        separateLine.backgroundColor = RGBACOLOR(235, 235, 235, 1).CGColor;
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
- (void)parseFoucs {
    NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
    NSMutableArray *titles = [[NSMutableArray alloc]init];
    
    for (YBNewsFoucs * foucs in self.foucsArray) {
        [imagesURLStrings addObject:foucs.imgUrl];
        [titles addObject:foucs.title];
    }
        self.cycleView.imageURLStringsGroup = imagesURLStrings.copy;
        self.cycleView.titlesGroup = titles.copy;
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
- (UIView *)tableviewHeader {
    if (!_tableviewHeader) {
        _tableviewHeader = [[UIView alloc]init];
        _tableviewHeader.backgroundColor = [UIColor clearColor];
        _tableviewHeader.frame = CGRectMake(0, 0, self.view.width, self.view.width * 0.5 + 90);
        [self.view addSubview:_tableviewHeader];
    }
    return _tableviewHeader;
}
- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, self.view.width * 0.5) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.currentPageDotColor = [UIColor whiteColor];
        _cycleView.titleLabelTextFont = [UIFont systemFontOfSize:14];
        _cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        [self.tableviewHeader addSubview:_cycleView];
    }
    return _cycleView;
}
- (UIScrollView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIScrollView alloc]init];
        _navigationBar.frame = CGRectMake(0, self.cycleView.height, self.view.width, 90);
        [self.tableviewHeader addSubview:_navigationBar];
    }
    return _navigationBar;
}
- (CALayer *)separateLine {
    if (!_separateLine) {
        _separateLine = [CALayer layer];
        _separateLine.backgroundColor = RGBACOLOR(235, 235, 235, 1).CGColor;
        _separateLine.frame = CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), self.view.width, 1);
        [self.tableviewHeader.layer addSublayer:_separateLine];
    }
    return _separateLine;
}
- (UITableView *)hotTableView {
    if (!_hotTableView) {
        _hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        [_hotTableView registerClass:[YBNewsSportListCell class] forCellReuseIdentifier:NSStringFromClass([YBNewsSportListCell class])];
        _hotTableView.tableHeaderView = self.tableviewHeader;
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
