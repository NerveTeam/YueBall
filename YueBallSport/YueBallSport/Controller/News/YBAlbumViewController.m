//
//  SPWeiboAlbumViewController.m
//  Sports
//
//  Created by SINA on 13-10-15.
//  Copyright (c) 2013年 sina.com. All rights reserved.
//

#import "YBAlbumViewController.h"
#import "UIImageView+WebCache.h"


static const NSInteger MinZoomScale =2;
static const NSInteger MAXZoomScale =20;
static const CGFloat THRESHOLD =5;



@interface YBAlbumViewController ()

@end

@implementation YBAlbumViewController

- (YBAlbum *)album {
    if (!_album) {
        _album = [[YBAlbum alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _album.delegate = self;
        _album.weiboAlbumScrollView.delegate=self;
    }
    return _album;

}
-(NSString *)url
{
    if (!_url) {
        _url = [[NSString alloc] init];
    }
    return _url;
}
-(NSString *)frameString
{
    if (!_frameString) {
        _frameString = [[NSString alloc] init];
    }
    return _frameString;
}
-(UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        _placeholderImage = [[UIImage alloc] init];
    }
    return _placeholderImage;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView
{
    self.view = self.album;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _imageActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    _imageActivityView.center = self.view.center;
    
    [self.album.weiboImageView addSubview:self.imageActivityView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.album.weiboImageView.image = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self loadimage];
}
-(void)loadimage
{
    if (_url)
    {
        NSURL *url = [NSURL URLWithString:self.url];
//        [self.spWeiboAlbum.weiboImageView setImageWithURL:url placeholderImage:self.placeholderImage];
//        [self showFromOriginalRect:CGRectFromString(self.frameString)];
        [self.imageActivityView startAnimating];
        [self.album.weiboImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.imageActivityView stopAnimating];
            [self showFromOriginalRect:CGRectFromString(self.frameString)];
        }];
        
    }
    else
    {
        self.album.weiboImageView.image = self.placeholderImage;
        [self showFromOriginalRect:CGRectFromString(self.frameString)];
    }
    //adjust weiboAlbumScrollView maximumZoomScale
    float value = self.album.weiboImageView.image.size.height/self.album.weiboImageView.image.size.width;
    self.album.weiboAlbumScrollView.maximumZoomScale = MinZoomScale;
    if (value > THRESHOLD) {
        self.album.weiboAlbumScrollView.maximumZoomScale = MAXZoomScale;
    }

}
#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    CGFloat zs = scrollView.zoomScale;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    scrollView.zoomScale = zs;
    [UIView commitAnimations];
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.album.weiboImageView;
}
#pragma mark -
#pragma mark === Animation Related ===
-(void)showFromOriginalRect:(CGRect) originalRect
{
    self.album.weiboImageView.frame = originalRect;
    self.album.weiboAlbumScrollView.zoomScale = 1.0;
    self.album.weiboImageView.contentMode = UIViewContentModeScaleAspectFit;
    [UIView animateWithDuration:0.3 animations:^
    {
        self.album.weiboImageView.frame = self.view.frame;
    } completion:^(BOOL finished)
    {

        NSLog(@"finished");
    }];
}
-(void)hideToOriginalRect:(CGRect) originalRect
{
    [UIView animateWithDuration:0.3 animations:^
     {
         self.album.weiboImageView.frame = originalRect;
     } completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         NSLog(@"finished");
     }];
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewClicked:(UIView *)view
{
    [self hideToOriginalRect:CGRectFromString(self.frameString)];
}
@end

