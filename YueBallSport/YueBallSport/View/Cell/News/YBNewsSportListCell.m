//
//  YBNewsSportListCell.m
//  YueBallSport
//
//  Created by Minlay on 16/11/14.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBNewsSportListCell.h"
#import "Masonry.h"
#import "UILabel+Extention.h"
#import "YBNewsSport.h"
#import "UIImageView+WebCache.h"
#import "MLTool.h"
#import "UIImage+Stretch.h"

@interface YBNewsSportListCell ()
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *img;
@property(nonatomic, strong)UILabel *commentCount;
@property(nonatomic, strong)UILabel *postDate;
@property(nonatomic, strong)UIImageView *commentIcon;
@end
@implementation YBNewsSportListCell
static const CGFloat marginLeft = 10;
static const CGFloat marginTop = 15;
static const CGFloat imgW = 120;
static const CGFloat imgH = 80;
+ (instancetype)newsSportListCellWithTableView:(UITableView *)tableView {
    YBNewsSportListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.postDate];
        [self.contentView addSubview:self.commentCount];
        [self.contentView addSubview:self.commentIcon];
        [self viewLayout];
    }
    return self;
}

- (void)setSportList:(YBNewsSport *)sportList {
    _sportList = sportList;
    self.titleLabel.text = sportList.title;
    [self.titleLabel sizeToFit];
    __block typeof(self.img)blockImageView = self.img;
    [self.img sd_setImageWithURL:[NSURL URLWithString:sportList.imgUrl.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image.size.height > image.size.width) {
            blockImageView.contentMode = UIViewContentModeTop;
            blockImageView.image = [image scaleToSize:CGSizeMake(imgW, imgH)];
        }else {
            blockImageView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
    self.commentCount.text = [NSString stringWithFormat:@"%ld",sportList.commentCount];
    [self.commentCount sizeToFit];
    NSDate *commentDate = [NSDate dateWithTimeIntervalSince1970:sportList.pubDate];
    self.postDate.text = [MLTool humanizeDateFormatFromDate:commentDate];

}
- (void)viewLayout {
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(marginLeft);
        make.top.equalTo(self.contentView).offset(marginTop);
        make.bottom.equalTo(self.contentView).offset(-marginTop);
        make.width.offset(imgW);
        make.height.offset(imgH);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img);
        make.left.equalTo(self.img.mas_right).offset(marginLeft);
        make.right.equalTo(self.contentView).offset(-marginLeft);
//        make.width.offset(200);
    }];
    
        [self.postDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.img);
        }];
    
        [self.commentIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-marginLeft);
            make.bottom.equalTo(self.postDate);
        }];
    
        [self.commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commentIcon.mas_left).offset(-marginLeft/2);
            make.bottom.equalTo(self.commentIcon);
        }];

}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:nil fontSize:16];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = RGBACOLOR(20, 20, 20, 1);
    }
    return _titleLabel;
}
- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.contentMode = UIViewContentModeScaleAspectFill;
        _img.clipsToBounds = YES;
    }
    return _img;
}
- (UILabel *)postDate {
    if (!_postDate) {
        _postDate = [UILabel labelWithText:nil fontSize:12];
        _postDate.textColor = RGBACOLOR(194, 194, 194, 1);
    }
    return _postDate;
}
- (UILabel *)commentCount {
    if (!_commentCount) {
        _commentCount = [UILabel labelWithText:nil fontSize:12];
        _commentCount.textColor = RGBACOLOR(194, 194, 194, 1);
    }
    return _commentCount;
}
- (UIImageView *)commentIcon {
    if (!_commentIcon) {
        _commentIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment"]];
    }
    return _commentIcon;
}
@end
