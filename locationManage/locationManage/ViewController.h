//
//  ViewController.h
//  locationManage
//
//  Created by Tesiro on 16/10/13.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^blockUserLocation) (CLLocation *location);
@interface ViewController : UIViewController<CLLocationManagerDelegate>{
    
    CLLocationManager *locationM;
}

@property (nonatomic,strong)blockUserLocation blockUserLocation;



@end

