//
//  YBTabBarController.m
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBTabBarController.h"
#import "YBMessageViewController.h"
#import "YBNewsViewController.h"
#import "YBHomeViewController.h"
#import "YBFindViewController.h"
#import "YBPersonViewController.h"
#import "NSArray+Safe.h"
#import "NSDictionary+Safe.h"

@interface YBTabBarController ()
@property(nonatomic,strong)NSArray *subViewControllers;
@end

@implementation YBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addChildViewControllers {
    NSMutableArray *chileControllers = [[NSMutableArray alloc]initWithCapacity:5];
    for (NSUInteger i = 0; i < self.subViewControllers.count; i++) {
        [chileControllers addObject:[self addController:[self.subViewControllers safeObjectAtIndex:i]]];
    }
    self.viewControllers = chileControllers.copy;
}
- (UIViewController *)addController:(NSDictionary *)info {
    Class className = NSClassFromString([info objectForKeyNotNull:@"class"]);
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:[[className alloc]init]];
    navController.title = [info objectForKeyNotNull:@"title"];
    return navController;
}

- (NSArray *)subViewControllers {
    if (!_subViewControllers) {
        _subViewControllers = @[
        @{@"title":@"消息",@"class":@"YBMessageViewController"},
        @{@"title":@"新闻",@"class":@"YBNewsViewController"},
        @{@"title":@"踢球",@"class":@"YBHomeViewController"},
        @{@"title":@"发现",@"class":@"YBFindViewController"},
        @{@"title":@"我的",@"class":@"YBPersonViewController"}];
    }
    return _subViewControllers;
}
@end
