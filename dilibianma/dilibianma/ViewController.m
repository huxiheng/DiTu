//
//  ViewController.m
//  dilibianma
//
//  Created by Tesiro on 16/10/12.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CLLocationManagerDelegate>{
    CLGeocoder *geoCoder;
    CLLocationManager *locationM;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    geoCoder = [[CLGeocoder alloc] init];
    
    
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
    
    [locationM startUpdatingLocation];
    [locationM startMonitoringSignificantLocationChanges];
}

#pragma cllocationManagerdelegate ---
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = [locations lastObject];
    
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
                if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
                     NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
                        
                    }
                }
               
            }else{
                
            }
            break;
            
        default:
            NSLog(@"none");
            break;
    }
}

-(void)diliBianMa{
    [geoCoder geocodeAddressString:@"广州" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"地理编码成功");
           CLPlacemark *firstPl= [placemarks firstObject];
            NSLog(@"%@,%F,%f",firstPl.name,firstPl.location.coordinate.latitude,firstPl.location.coordinate.longitude) ;
        }
    }];
    
}

-(void)fandilibianma{
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:21.123 longitude:116.345];
    [geoCoder reverseGeocodeLocation:loc1 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"fan地理编码成功");
            CLPlacemark *firstPl= [placemarks firstObject];
            NSLog(@"%@,%F,%f",firstPl.name,firstPl.location.coordinate.latitude,firstPl.location.coordinate.longitude) ;
        }
    }];
}

@end
