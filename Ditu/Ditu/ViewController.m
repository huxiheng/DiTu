//
//  ViewController.m
//  Ditu
//
//  Created by Tesiro on 16/10/10.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
}

-(void)userShouquanWEIZhi{
    //1.创建用户位置管理器
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //请求前台定位授权
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //         [locationManager requestWhenInUseAuthorization] ;
        
        //前后台定位授权
        [locationManager requestAlwaysAuthorization];
        
        //ios9.0之后的授权
        if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
            locationManager.allowsBackgroundLocationUpdates=YES;
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [locationManager startUpdatingLocation];
}

#pragma mark ---CLLocationManagerDelegate----
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%@",locations);
    /*
     完成定位的次数，每隔一段时间定为一次
     
     */
}

@end
