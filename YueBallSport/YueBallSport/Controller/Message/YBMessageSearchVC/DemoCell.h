//
//  DemoCell.h
//  UISearchController&UISearchDisplayController
//
//  Created by zml on 15/12/2.
//  Copyright © 2015年 zml@lanmaq.com. All rights reserved.
//  https://github.com/Lanmaq/iOS_HelpOther_WorkSpace


#import <UIKit/UIKit.h>

@interface DemoCell : UITableViewCell
//该用户的昵称
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
//球队的名字
@property (weak, nonatomic) IBOutlet UILabel *friendIdLabel;

@property (weak, nonatomic) IBOutlet UIImageView *groupHeadIcon;


//该用户的头像
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end
