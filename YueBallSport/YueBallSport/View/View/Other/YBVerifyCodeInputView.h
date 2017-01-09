//
//  YBVerifyCodeInputView.h
//  YueBallSport
//
//  Created by Minlay on 16/12/28.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBVerifyCodeInputViewDelegate <NSObject>
@optional
- (void)verifyInputDidFinish:(NSString *)code;
@end
@interface YBVerifyCodeInputView : UIView
@property(nonatomic, weak)id<YBVerifyCodeInputViewDelegate> delegate;
@property(nonatomic, assign)NSInteger numberOfVertifyCode;
- (void)hideKeyBoard;
@end
