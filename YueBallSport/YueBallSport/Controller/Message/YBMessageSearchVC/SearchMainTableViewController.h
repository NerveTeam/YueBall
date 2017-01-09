//
//  SearchMainTableViewController.h
//  UISearchController&UISearchDisplayController
//
//  Created by zml on 15/12/2.
//  Copyright © 2015年 zml@lanmaq.com. All rights reserved.
//  https://github.com/Lanmaq/iOS_HelpOther_WorkSpace


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@class DemoModel;
@protocol YBMessageSearchCellDelegate <NSObject>

- (void)selectIndex:(NSInteger)index searchModel:(DemoModel *)model;


@end

@interface SearchMainTableViewController : BaseTableViewController
@property(nonatomic,assign)id<YBMessageSearchCellDelegate>delegate;
@end
