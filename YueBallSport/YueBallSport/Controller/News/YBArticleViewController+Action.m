//
//  YBArticleViewController+Action.m
//  YueBallSport
//
//  Created by Minlay on 16/11/27.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBArticleViewController+Action.h"
#import <objc/runtime.h>
#import "YBAlbumViewController.h"
#import "YBLoginViewController.h"
#import "MLTransition.h"
#import "YBCommentViewController.h"

@interface YBArticleViewController ()<SNArticleActionProtocal>
@property(nonatomic, strong)YBAlbumViewController *albumViewController;
@end

@implementation YBArticleViewController (Action)
static const NSString *albumViewControllerKey = @"albumViewController";

/**
 *  图片点击
 *
 *  @param image         图片
 *  @param frame         点击的坐标
 */
- (void)sn_imageClick:(SNArticleImage *)image startFrame:(CGRect)frame callbackBlock:(SNGotImageBlock)callbackBlock {
    self.albumViewController.url = image.url;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    self.albumViewController.frameString = NSStringFromCGRect(newFrame);
    self.albumViewController.placeholderImage = nil;
    self.albumViewController.album.weiboImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.albumViewController.view];
    
}



- (void)sn_requestCallback:(NSDictionary *)userInfo {
    self.spring = YES;
    [self pushViewcontroller:[[YBLoginViewController alloc]init] animationType:UIViewAnimationTypeFall];
}

- (void)sn_commentReply:(SNComment *)comment {
    [self.commentInputView replayComment:[NSString stringWithFormat:@"%ld",comment.mId] name:comment.userName];
}

- (void)sn_commentMoreClick {
    YBCommentViewController *commentVc = [[YBCommentViewController alloc]init];
    commentVc.newsId = self.newsId;
    [self.navigationController pushViewController:commentVc animated:YES];
}


- (YBAlbumViewController *)albumViewController {
    YBAlbumViewController *albumVc = objc_getAssociatedObject(self, (__bridge void *)(albumViewControllerKey));
    if (!albumVc) {
        albumVc = [[YBAlbumViewController alloc]init];
        objc_setAssociatedObject(self, (__bridge void *)(albumViewControllerKey), albumVc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return  albumVc;
}

@end
