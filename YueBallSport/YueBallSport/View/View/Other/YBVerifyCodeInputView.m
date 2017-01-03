//
//  YBVerifyCodeInputView.m
//  YueBallSport
//
//  Created by Minlay on 16/12/28.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBVerifyCodeInputView.h"
#import "YBUnderLineLabel.h"
#import "NSArray+Safe.h"

@interface YBVerifyCodeInputView ()<UITextFieldDelegate>
@property(nonatomic, strong)UITextField *placeholderTextField;
@property(nonatomic, strong)NSMutableArray *verifyCodeArray;
@end
@implementation YBVerifyCodeInputView


- (void)hideKeyBoard {
    [self.placeholderTextField resignFirstResponder];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    static const CGFloat itemW = 60;
    static const CGFloat itemH = 50;
    [self addSubview:self.placeholderTextField];
    CGFloat margin = (self.width - itemW * self.numberOfVertifyCode) / (self.numberOfVertifyCode - 1);
    NSMutableArray *temp = [[NSMutableArray alloc]initWithCapacity:self.numberOfVertifyCode];
    for (NSInteger i = 0; i < self.numberOfVertifyCode; i++) {
        YBUnderLineLabel *label = [[YBUnderLineLabel alloc]init];
        label.font = [UIFont systemFontOfSize:31];
        label.textColor = RGBACOLOR(26, 26, 26, 1);
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = self.bounds;
        label.width = itemW;
        label.height = itemH;
        label.x = i * (margin + itemW);
        [self addSubview:label];
        [temp addObject:label];
    }
    self.verifyCodeArray = temp;
    [self.placeholderTextField becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.placeholderTextField becomeFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 判断是不是“删除”字符
    if (string.length != 0) {
        
        // 判断验证码/密码的位数是否达到预定的位数
        if (textField.text.length + 1 > self.numberOfVertifyCode) {
            return NO;
        }
        YBUnderLineLabel *label = [self.verifyCodeArray safeObjectAtIndex:range.location];
        label.text = string;
        if (textField.text.length + 1 == self.numberOfVertifyCode) {
            if ([_delegate respondsToSelector:@selector(verifyInputDidFinish:)]) {
                [_delegate verifyInputDidFinish:[textField.text stringByAppendingString:string]];
            }
        }
        
        return YES;
    }else {
       YBUnderLineLabel *label = [self.verifyCodeArray safeObjectAtIndex:range.location];
        label.text = string;
        return YES;
    }
    return YES;
}
- (UITextField *)placeholderTextField {
    if (!_placeholderTextField) {
        _placeholderTextField = [[UITextField alloc]init];
        _placeholderTextField.borderStyle = UITextBorderStyleNone;
        _placeholderTextField.backgroundColor = [UIColor clearColor];
        _placeholderTextField.delegate = self;
        _placeholderTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _placeholderTextField;
}
@end
