//
//  YBGroupChatDetailCollectionViewCell.m
//  YueBallSport
//
//  Created by 韩森 on 2016/12/14.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBGroupChatDetailCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Crop.h"

#define item_Width (SCREEN_WIDTH-20)/4-10-20

#define item_Height (SCREEN_WIDTH-20)/4+10
@implementation YBGroupChatDetailCollectionViewCell

-(void)setModel:(YBMessageModel *)model{
    
    _titleLab.text = model.userName;
    //占位图
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:model.headIcon] placeholderImage:[UIImage imageNamed:@""]];
    
    [_headIcon.image imageByScalingAndCroppingForSize:CGSizeMake(item_Width, item_Width)];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
