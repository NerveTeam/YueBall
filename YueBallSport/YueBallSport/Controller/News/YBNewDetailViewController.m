//
//  YBNewDetailViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/12.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewDetailViewController.h"
#import "YBNewsSport.h"
#import "YBNewsSportListCell.h"
#import "YBArticleViewController.h"
#import "MLTransition.h"
#import "UIView+TopBar.h"

@interface YBNewDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)YBNewsSport *sportList;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *topBar;

@end

@implementation YBNewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 1;
    [self loadData:_currentIndex];
    [self showHUD:self.tableView.frame inView:self.view];
}

- (void)loadData:(NSInteger)page {
    self.sportList = [YBNewsSport requestNewsList:@{@"channelId":@(_channelId),@"page":@(page)} success:^(NSArray *dataList) {
        [self stopRefresh];
        [self removeHUD];
        [self removeReloadHUD];
        if (page > 1) {
            if (dataList.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:self.dataList];
            [temp addObjectsFromArray:dataList];
            self.dataList = temp.copy;
        }else {
            if (dataList.count < 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.dataList = dataList;
        }
        [self.tableView reloadData];
    } errorBack:^{
        [self showMessage:@"网络异常"];
        [self stopRefresh];
        [self removeHUD];
        [self showReloadHUD:self.tableView callBack:^{
            [self showHUD];
            [self loadData:0];
        }];
    }];
}

- (void)stopRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBNewsSportListCell *cell = [YBNewsSportListCell newsSportListCellWithTableView:tableView];
    cell.sportList = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"YBNewsSportListCell" cacheByIndexPath:indexPath configuration:^(YBNewsSportListCell *cell) {
        cell.sportList = self.dataList[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YBNewsSport *sport = self.dataList[indexPath.row];
    YBArticleViewController *article = [[YBArticleViewController alloc]initWithNewsId:[NSString stringWithFormat:@"%ld",sport.newsId]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:article animated:YES];
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topBar.height, self.view.width, self.view.height - self.topBar.height)];
        [_tableView registerClass:[YBNewsSportListCell class] forCellReuseIdentifier:NSStringFromClass([YBNewsSportListCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentIndex = 1;
            [self loadData:_currentIndex];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadData:++_currentIndex];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBar = [_topBar topBarWithTintColor:nil title:self.channelName titleColor:[UIColor whiteColor] leftView:nil rightView:nil responseTarget:self];
        [self.view addSubview:_topBar];
    }
    return _topBar;
}
@end
