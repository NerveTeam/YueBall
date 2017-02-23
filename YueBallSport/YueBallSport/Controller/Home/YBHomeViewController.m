//
//  YBHomeViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBHomeViewController.h"

@interface YBHomeViewController ()

@end

@implementation YBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"home.jpg"];
    self.view.layer.contents = (__bridge id _Nullable)(image.CGImage);
}

@end
