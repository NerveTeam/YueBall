//
//  SPWeiboAblumn.m
//  Sports
//
//  Created by SINA on 13-10-15.
//  Copyright (c) 2013年 sina.com. All rights reserved.
//

#import "YBAlbum.h"

@implementation YBAlbum

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeViewBackground];
        [self addScrollView];
        [self addImageInView];
        [self addSingleGestureRecognizerInView];
        
    }
    return self;
}


-(void)makeViewBackground
{
    self.backgroundColor = [UIColor blackColor];
}
-(void)addScrollView
{
    self.weiboAlbumScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.weiboAlbumScrollView.maximumZoomScale = 2.0;//允许放大2倍
    self.weiboAlbumScrollView.minimumZoomScale = 0.5;//允许放大到0.5倍
    [self addSubview:self.weiboAlbumScrollView];
}
-(void)addImageInView
{
    self.weiboImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.contentMode = UIViewContentModeScaleAspectFit;
    [self.weiboAlbumScrollView addSubview:self.weiboImageView];

    
}
-(void)addSingleGestureRecognizerInView
{
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleRecognizer];
    
    UIPanGestureRecognizer * gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self addGestureRecognizer:gestureRecognizer];
}

-(void)handleSingleTapFrom
{
    if ([self.delegate respondsToSelector:@selector(viewClicked:)]) {
        [self.delegate viewClicked:self];
    }
}


@end
