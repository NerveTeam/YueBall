//
//  YBMessageMapViewController.h
//  LeanCloudIMKit-iOS
//
//  v0.8.0 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/3/30.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

@import UIKit;
@import MapKit;
@import CoreLocation;

@interface YBMessageMapViewController : UIViewController

@property (nonatomic, strong) CLLocation *location;
- (instancetype)initWithLocation:(CLLocation *)location;
+ (instancetype)initWithLocation:(CLLocation *)location;



@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;

@end
