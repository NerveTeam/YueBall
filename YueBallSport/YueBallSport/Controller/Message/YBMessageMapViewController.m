//
//  YBMessageMapViewController.m
//  LeanCloudChatKit-iOS
//
//  v0.8.0 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/3/30.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "YBMessageMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import <MapKit/MKPointAnnotation.h>
@interface YBMessageMapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
//    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
@implementation YBMessageMapViewController

- (instancetype)initWithLocation:(CLLocation *)location {
    self = [super init];
    if (!self) {
        return nil;
    }
    _location = location;
    return self;
}

+ (instancetype)initWithLocation:(CLLocation *)location {
    YBMessageMapViewController *mapViewController = [[YBMessageMapViewController alloc] init];
    mapViewController.location = location;
    return mapViewController;
}

#pragma mark -
#pragma mark - UIViewController Life

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 1. 实例化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 2. 设置代理
    _locationManager.delegate = self;
    // 3. 定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    CLLocationDistance distance = 10.0;
    _locationManager.distanceFilter = distance;
    
    
    if (![CLLocationManager locationServicesEnabled]) {
        DLog(@"定位服务当前可能尚未打开，请设置打开！");
        
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    } else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        
        
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    // 4.请求用户权限：分为：⓵只在前台开启定位⓶在后台也可定位，
    //注意：建议只请求⓵和⓶中的一个，如果两个权限都需要，只请求⓶即可，
    //⓵⓶这样的顺序，将导致bug：第一次启动程序后，系统将只请求⓵的权限，⓶的权限系统不会请求，只会在下一次启动应用时请求⓶
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
//        [_locationManager requestWhenInUseAuthorization];//⓵只在前台开启定位
//    }
//    // 6. 更新用户位置
//    [_locationManager startUpdatingLocation];
    
    [self initGUI];
}
-(void)addCustomNavgationBar{
    
    
}

#pragma mark 添加地图控件
-(void)initGUI{
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    [self performSelector:@selector(addAnnotation) withObject:nil afterDelay:2.0f];
}

#pragma mark 添加大头针
-(void)addAnnotation{
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(_location.coordinate.latitude, _location.coordinate.longitude);
    MKPointAnnotation *annotation1=[[MKPointAnnotation alloc]init];
    annotation1.title=_subtitle;
//    annotation1.subtitle=@"Kenshin Cui's Studios";
    annotation1.coordinate=location1;
    [_mapView addAnnotation:annotation1];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
