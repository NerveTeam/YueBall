//
//  YBCommentViewController.m
//  YueBallSport
//
//  Created by Minlay on 17/3/21.
//  Copyright © 2017年 YueBall. All rights reserved.
//

#import "YBCommentViewController.h"
#import "MLCommentViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "MLCommentInputView.h"
#import "MLTransition.h"
#import "MLComment.h"
#import "DataRequest.h"

@interface YBCommentViewController ()<MLCommentInputViewDelegate,MLCommentViewControllerDelegate,DataRequestDelegate>
@property (strong, nonatomic) UIView *topBar;
@property (strong, nonatomic) UIButton *backItem;
@property (strong, nonatomic) MLCommentViewController *contentViewController;
@property(nonatomic, strong)MLCommentInputView *commentInputView;
@end

@implementation YBCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.commentInputView endEditing:YES];
}
- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.contentViewController.view];
    [self.view addSubview:self.commentInputView];
    [self addChildViewController:self.contentViewController];
}

- (void)setNewsId:(NSString *)newsId {
    if (newsId && newsId.length > 0) {
        _newsId = newsId;
    }else {
        _newsId = @"";
    }
}

#pragma mark -  MLCommentViewControllerDelegate
- (void)hideKeyBoard  {
    [self.commentInputView endEditing:YES];
}
- (void)scrollViewWillBeginDragging {
    self.commentInputView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating {
    self.commentInputView.userInteractionEnabled = YES;
}

#pragma mark - MLCommentInputViewDelegate
- (void)commentItemClick {
    self.direction = kMLTransitionFromLeft;
    [self popViewcontrollerAnimationType:UIViewAnimationTypeFlip];
}

- (void)sendComment:(NSString *)parentId text:(NSString *)inputText {
    NSDictionary *parameter = @{@"articleId":self.newsId,
                                @"uid":@(2),
                                @"content":inputText,
                                @"type":@"news",
                                @"parentId":parentId};
    [ReplayCommentRequest requestDataWithDelegate:self parameters:parameter];
}
#pragma mark - MLCommentViewControllerDelegate

// 点击回复抛出选中对象数据
- (void)commentViewController:(MLCommentViewController *)vc commentReply:(MLComment *)comment {
    [self.commentInputView replayComment:comment.mid name:comment.name];
}
// 点赞抛出选中对象数据
- (void)commentSupporController:(MLCommentViewController *)vc comment:(MLComment *)comment callBack:(supporBlock)back {

}

- (void)requestFinished:(BaseDataRequest *)request {
    if ([request isKindOfClass:[ReplayCommentRequest class]]) {
        [self.commentInputView resetComment];
        [self showMessage:@"评论成功"];
        [self.contentViewController loadCommentData];
    }
}
-(void)requestFailed:(BaseDataRequest *)request {
    if ([request isKindOfClass:[ReplayCommentRequest class]]) {
        [self.commentInputView endEditing:YES];
        [self showMessage:@"评论失败"];
    }
}




- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBar = [_topBar topBarWithTintColor:nil title:nil titleColor:nil leftView:self.backItem rightView:nil responseTarget:self];
    }
    return _topBar;
}
- (UIButton *)backItem {
    if (!_backItem) {
        _backItem = [UIButton buttonWithTitle:@"返回" fontSize:16];
    }
    return _backItem;
}
- (MLCommentViewController *)contentViewController {
    if (!_contentViewController) {
        _contentViewController = [[MLCommentViewController alloc]init];
        _contentViewController.parameter = @{@"newsId":self.newsId};
        _contentViewController.servers = @"http://wu.she-cheng.com/thinkphp/comment/lists";
        _contentViewController.delegate = self;
        _contentViewController.view.frame = CGRectMake(0, self.topBar.height, self.view.width, self.view.height - self.topBar.height - TabBarHeight);
    }
    return _contentViewController;
}
- (MLCommentInputView *)commentInputView {
    if (!_commentInputView) {
        _commentInputView = [[MLCommentInputView alloc]initWithCommentStyle:CommentStylePage];
        _commentInputView.delegate = self;
        _commentInputView.frame = CGRectMake(0, self.view.height - TabBarHeight, self.view.width, TabBarHeight);
    }
    return _commentInputView;
}

@end
