//
//  YBNewsSportListCell.h
//  YueBallSport
//
//  Created by Minlay on 16/11/14.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBNewsSport;
@interface YBNewsSportListCell : UITableViewCell
@property(nonatomic, strong)YBNewsSport *sportList;

+ (instancetype)newsSportListCellWithTableView:(UITableView *)tableView;
@end
