//
//  SPWeiboAblumn.h
//  Sports
//
//  Created by SINA on 13-10-15.
//  Copyright (c) 2013年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBAlbumDelegate <NSObject>
-(void)viewClicked:(UIView*)view;
@end


@interface YBAlbum : UIView
@property(nonatomic,retain) UIImageView *weiboImageView;
@property(nonatomic,retain) UIScrollView *weiboAlbumScrollView;
@property(nonatomic,assign) id<YBAlbumDelegate> delegate;
@end
