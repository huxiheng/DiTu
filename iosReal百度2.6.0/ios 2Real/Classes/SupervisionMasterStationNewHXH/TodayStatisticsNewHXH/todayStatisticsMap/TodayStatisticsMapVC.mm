//
//  TodayStatisticsMapVC.m
//  XieshiPrivate
//
//  Created by Tesiro on 16/10/10.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import "TodayStatisticsMapVC.h"
#import <CoreLocation/CoreLocation.h>

@interface TodayStatisticsMapVC ()

@end

@implementation TodayStatisticsMapVC
#pragma mark ---系统方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithNibName:nil bundle:nil]) {
//        [self setSubViewsForUserLocation];
        [self setSubViews];
    }
    return self;
}

-(instancetype)init{
    if (self==[super init]) {
//        [self setSubViewsForUserLocation];
        [self setSubViews];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [super loadView];
//    [self setSubViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    [locationM startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    [locationM stopUpdatingLocation];
    [super viewWillDisappear:animated];
}

#pragma mark:-- 布置view的ui界面
-(void)setSubViews{
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-kscaleIphone6DeviceHeight(50)-64)];
    [self.view addSubview:_mapView];
        
        self.mapView.showsUserLocation = YES;
        [_mapView setZoomLevel:11];
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    CLLocationCoordinate2D clocation2D=self.locationUser?self.locationUser.coordinate:CLLocationCoordinate2DMake(31.14, 121.30);
        [_mapView setCenterCoordinate:clocation2D];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        _mapView.showsUserLocation = NO;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.showsUserLocation = YES;
        _mapView.showMapScaleBar = YES;
        _mapView.mapScaleBarPosition = CGPointMake(kscaleDeviceWidth(50) , DeviceHeight-kscaleIphone6DeviceHeight(50)-64-kscaleIphone6DeviceHeight(50));
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    //以下_mapView为BMKMapView对象
    _mapView.showsUserLocation = YES;//显示定位图层
    
    //处理转场动画的代理
    _popoverAnimator = [[PopoverAnimator alloc] init];
    
    ButtonTitleLeftImageRight *btn = [[ButtonTitleLeftImageRight alloc] initWithFrame:CGRectMake(DeviceWidth-kscaleDeviceWidth(85), kscaleIphone6DeviceLength(50), kscaleDeviceWidth(75), kscaleIphone6DeviceLength(29)) title:@"附近：3公里" font:themeFont9 textColor:kc00_3385FF];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(kiloMeterTitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
[_mapView updateLocationData:userLocation];
}
#pragma mark --- 处理点击事件
-(void)kiloMeterTitleBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    _popoverAnimator.button = btn;
    
    //创建弹出的控制器
    PopoverViewController *popoverVC = [[PopoverViewController alloc] init];
    dpBlockSelf;
    popoverVC.blockClickIndexPath = ^(NSString * title){
        NSString *text =[NSString stringWithFormat:@"附近：%@公里",title];
        [btn setTitle:text forState:UIControlStateNormal];
        [_self calculateTitleWidthFotBtn:text btn:btn];
    };
    //设置转场代理
    popoverVC.transitioningDelegate = _popoverAnimator;
    
    //设置控制器的modal样式
    popoverVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popoverVC animated:YES completion:nil];
}

-(void)calculateTitleWidthFotBtn:(NSString *)title btn:(UIButton*)btn{
    CGFloat width = [NSString calculateTextWidth:kscaleIphone6DeviceHeight(29) Content:title font:themeFont9];
    CGFloat btnWidth = btn.imageView.frame.size.width+width;
    btn.frame = CGRectMake(DeviceWidth-kscaleDeviceWidth(10)-btnWidth-5, kscaleIphone6DeviceHeight(50), btnWidth+5, kscaleIphone6DeviceHeight(29));
    
}
#pragma mark ---定位用户的当前信息－－－－
-(void)setSubViewsForUserLocation{
    
    locationM = [[CLLocationManager alloc] init];
    locationM.delegate = self;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        //        [locationM requestAlwaysAuthorization];
        [locationM requestWhenInUseAuthorization];
        if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
            locationM.allowsBackgroundLocationUpdates = YES;
            
        }
    }
    
    locationM.distanceFilter = 100;
    locationM.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
//        [locationM requestLocation];
//    }else{
        [locationM startUpdatingLocation];
        [locationM startMonitoringSignificantLocationChanges];
//    }
}
#pragma cllocationManagerdelegate ---
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = [locations lastObject];
    self.locationUser = newLocation;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户没有决定");
            
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"受限制");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"前台授权");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"前后台授权");
            break;
        case kCLAuthorizationStatusDenied:
            if ([CLLocationManager locationServicesEnabled]) {
                [LSDialog showAlertWithTitle:@"提示" message:@"请打开在‘设置>隐私>检测管理的定位服务’" callBack:nil];
                
            }else{
                [LSDialog showAlertWithTitle:@"提示" message:@"请打开在‘设置>隐私>定位服务’" callBack:nil];
            }
            break;
            
        default:
            NSLog(@"none");
            break;
    }
}
@end
