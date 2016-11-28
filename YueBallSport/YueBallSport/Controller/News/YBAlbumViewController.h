//
//  YBAlbumViewController.h
//  Sports
//
//  Created by SINA on 13-10-15.
//  Copyright (c) 2013年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBAlbum.h"
@interface YBAlbumViewController : UIViewController<YBAlbumDelegate,UIScrollViewDelegate>
@property(nonatomic,retain) YBAlbum *album;
@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain) NSString *frameString;
@property(nonatomic,retain) UIImage *placeholderImage;
@property (nonatomic ,retain) UIActivityIndicatorView* imageActivityView;

@end
