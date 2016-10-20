//
//  TodayViewController.h
//  XieshiPrivate
//
//  Created by 明溢 李 on 14-12-26.
//  Copyright (c) 2014年 Lessu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPagedTableViewController.h"
#import "LSRefreashableViewController.h"

@interface TodayViewController : LSPagedTableViewController
@property (weak, nonatomic) IBOutlet UIView *mapContainview;
@property (nonatomic, strong)NSDictionary  *dicDataForToday;
@property (weak, nonatomic) IBOutlet UIView *GLYTodayBottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnDiTu;
@property (weak, nonatomic) IBOutlet UIButton *btnList;
@end
