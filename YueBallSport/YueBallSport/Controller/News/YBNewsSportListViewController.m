//
//  YBNewsSportListViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/12.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewsSportListViewController.h"
#import "YBNewsSport.h"
#import "YBNewsSportListCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
#import "YBArticleViewController.h"
#import "MLTransition.h"

@interface YBNewsSportListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)YBNewsSport *sportList;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, strong)NSArray *dataList;
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation YBNewsSportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    _currentIndex = 1;
    [self loadData:_currentIndex];
}

- (void)loadData:(NSInteger)page {
    self.sportList = [YBNewsSport requestNewsList:@{@"channelId":_channelId,@"page":@(page)} success:^(NSArray *dataList) {
        [self stopRefresh];
        if (page > 1) {
            NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:self.dataList];
            [temp addObjectsFromArray:dataList];
            self.dataList = temp.copy;
        }else {
        self.dataList = dataList;
        }
            [self.tableView reloadData];
    } errorBack:^{
        [self stopRefresh];
    }];
}

- (void)stopRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (void)initTableView {
    [self.view addSubview:self.tableView];
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
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.height = self.view.height - StatusBarHeight - 2 * TopBarHeight - 200 - TabBarHeight;
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
    }
    return _tableView;
}
@end
