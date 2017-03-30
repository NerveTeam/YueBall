//
//  MLCommentInputView.h
//  MLCommentInputView
//
//  Created by Minlay on 16/11/20.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBPlaceholderTextView.h"

typedef NS_ENUM(NSUInteger, CommentStyle) {
    CommentStyleArticle,
    CommentStylePage,
};
@protocol MLCommentInputViewDelegate <NSObject>
@optional
- (void)commentItemClick;
- (void)sendComment:(NSString *)parentId text:(NSString *)inputText;
@end
@interface MLCommentInputView : UIView
@property(nonatomic, strong)YBPlaceholderTextView *commentInputTextView;
@property(nonatomic, weak)id<MLCommentInputViewDelegate> delegate;
- (instancetype)initWithCommentStyle:(CommentStyle)commentStyle;
- (void)updateCommentCount:(NSInteger)count;
- (void)replayComment:(NSString *)parentId name:(NSString *)replayName;
- (void)resetComment;
@end
