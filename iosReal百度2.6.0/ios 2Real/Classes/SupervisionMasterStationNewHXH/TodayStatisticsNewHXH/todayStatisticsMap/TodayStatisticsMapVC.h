//
//  TodayStatisticsMapVC.h
//  XieshiPrivate
//
//  Created by Tesiro on 16/10/10.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "PopoverViewController.h"
#import "PopoverAnimator.h"
#import "XSPresentationController.h"
#import "CllocationUserVC.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^blockUserLocation) (CLLocation *location);//处理定位
@interface TodayStatisticsMapVC : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate>{
    
    CLLocationManager *locationM;
}
@property (nonatomic, strong)BMKMapView     *mapView;
@property(nonatomic,retain)     BMKLocationService* locService;

@property(nonatomic, strong)PopoverAnimator *popoverAnimator;//处理转场动画的代理
@property (nonatomic, strong)CLLocation    *locationUser;//用户的位置信息

-(instancetype)initWithFrame:(CGRect)frame;

@end
