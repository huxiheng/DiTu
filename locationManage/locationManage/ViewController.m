//
//  ViewController.m
//  locationManage
//
//  Created by Tesiro on 16/10/13.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}

-(void)setSubViews{
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
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
        [locationM requestLocation];
    }else{
        [locationM startUpdatingLocation];
        [locationM startMonitoringSignificantLocationChanges];
    }
}
#pragma cllocationManagerdelegate ---
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = [locations lastObject];
    self.blockUserLocation(newLocation);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
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

@end
