//
//  YBGroupChatDetailCollectionViewCell.h
//  YueBallSport
//
//  Created by 韩森 on 2016/12/14.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBMessageModel.h"
@interface YBGroupChatDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

-(void)setModel:(YBMessageModel *)model;
@end
