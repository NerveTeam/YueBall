//
//  YBArticleViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/14.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBArticleViewController.h"
#import "YBArticleRequestDelegate.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "MLCommentInputView.h"
#import "DataRequest.h"
#import "AFNetworking.h"
#import "YBArticlePullTipView.h"
#import "MLTransition.h"

@interface YBArticleViewController ()<MLCommentInputViewDelegate,DataRequestDelegate,SNArticleActionProtocal>

@property(nonatomic, strong)UIView *topBar;
@property(nonatomic, strong)UIButton *backItem;
@property(nonatomic, strong)UIButton *shareItem;
@property(nonatomic, strong)MLCommentInputView *commentInputView;
// 上拉提示
@property(nonatomic, strong)YBArticlePullTipView *pullTipView;
@end

@implementation YBArticleViewController
static CGFloat pullStartPosition = 20; // 下拉初始点
- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}

/**
 *  配置相关
 */
- (void)config {
    self.navigationController.delegate = nil;
    self.baseDelegate = [[YBArticleRequestDelegate alloc]init];
    self.actionDelegate = self;
    [self setupUI];

}

- (void)setupUI {
    [self initPullClosePageView];
    self.webView.frame = CGRectMake(0,
                                    0,
                                    self.view.width,
                                    self.view.height);
    [self.view addSubview:self.topBar];
}
- (void)initPullClosePageView {
    [self.webView addSubview:self.pullTipView];
    [self.pullTipView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-pullStartPosition);
        make.left.right.equalTo(self.view);
    }];
}

- (void)articleDidLoad {
    [self.commentInputView updateCommentCount:13];
}



#pragma mark - MLCommentInputViewDelegate
- (void)sendComment:(NSString *)inputText {
    NSDictionary *parameter = @{@"articleId":self.newsId,
                                @"uid":@(12),
                                @"content":inputText,
                                @"type":@"news"};
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [ReplayCommentRequest requestDataWithDelegate:self parameters:parameter];
}
// TODU: 跳转评论页
- (void)commentItemClick {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat ofset = scrollView.contentOffset.y;
    CGFloat totalOfset = scrollView.contentSize.height;
    
    CGFloat diffVaule = ofset + self.webView.height - totalOfset;
    
    if (ofset > 0 && diffVaule > EdgeValue) {
        [self.pullTipView updateTipStyle:PullTipStyleClose];
        [self.pullTipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-(pullStartPosition + diffVaule));
        }];
    }
    else if (diffVaule > 0 && diffVaule < EdgeValue) {
        [self.pullTipView updateTipStyle:PullTipStyleDefault];
        [self.pullTipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-(pullStartPosition + diffVaule));
        }];
    }else if (diffVaule < 0 && diffVaule > -200) {
        [self.pullTipView updateTipStyle:PullTipStyleDefault];
        [self.pullTipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-pullStartPosition);
        }];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat ofset = scrollView.contentOffset.y;
    CGFloat totalOfset = scrollView.contentSize.height;
    CGFloat diffVaule = ofset + self.webView.height - totalOfset;
    if (ofset > 0 && diffVaule > EdgeValue) {
        [self popViewcontrollerAnimationType:UIViewAnimationTypeRipple];
    }
}
#pragma mark - DataRequestDelegate

- (void)requestFinished:(BaseDataRequest *)request {
    if ([request isKindOfClass:[ReplayCommentRequest class]]) {
        [self.commentInputView endEditing:YES];
    }
}
- (void)requestFailed:(BaseDataRequest *)request {
    if ([request isKindOfClass:[ReplayCommentRequest class]]) {
//        [self.commentInputView endEditing:YES];
    }
}

#pragma mark - lazy
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBar = [_topBar topBarWithTintColor:nil title:nil titleColor:nil leftView:self.backItem rightView:self.shareItem responseTarget:self];
    }
    return _topBar;
}
- (UIButton *)backItem {
    if (!_backItem) {
        _backItem = [UIButton buttonWithTitle:@"返回" fontSize:16];
    }
    return _backItem;
}
- (UIButton *)shareItem {
    if (!_shareItem) {
        _shareItem = [UIButton buttonWithTitle:@"分享" fontSize:16];
    }
    return _shareItem;
}
- (MLCommentInputView *)commentInputView {
    if (!_commentInputView) {
        _commentInputView = [[MLCommentInputView alloc]init];
        _commentInputView.delegate = self;
        [self.view addSubview:_commentInputView];
    }
    return _commentInputView;
}
- (YBArticlePullTipView *)pullTipView {
    if (!_pullTipView) {
        _pullTipView = [[YBArticlePullTipView alloc]init];
    }
    return _pullTipView;
}
@end
