//
//  YBNewsSportListViewController.m
//  YueBallSport
//
//  Created by Minlay on 16/11/12.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewsSportListViewController.h"

@interface YBNewsSportListViewController ()

@end

@implementation YBNewsSportListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(int)(arc4random() % (255))/255.0 green:(int)(arc4random() % (255))/255.0 blue:(int)(arc4random() % (255))/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
