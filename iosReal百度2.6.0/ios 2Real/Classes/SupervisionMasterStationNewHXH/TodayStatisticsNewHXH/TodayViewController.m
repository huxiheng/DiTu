//
//  TodayViewController.m
//  XieshiPrivate
//
//  Created by 明溢 李 on 14-12-26.
//  Copyright (c) 2014年 Lessu. All rights reserved.
//

#import "TodayViewController.h"
#import "TodayTableViewCell.h"
#import "TodayAdminTableViewCell.h"
#import "TodaySearchViewController.h"
#import "AppDelegate.h"
#import "TodayAdminDetailViewController.h"
#import "TodaySearchDayView.h"
#import "TodayStatisticsNewXHHeaderview.h"
#import "TodayStatisticsNewXHCell.h"
#import "TodayStatisticsMapVC.h"

#define isManageUnit ([APP_DELEGATE.rootMainViewController.userPowerString characterAtIndex:0] == '1')
#define isAdmin isManageUnit
@interface TodayViewController ()<TodayAdminTableViewCellDelegate,TodayStatisticsStandardTimeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSArray *list;
@property(nonatomic,retain) NSString* projectName;
@property(nonatomic,retain) NSString* projectArea;
@property (nonatomic, copy)NSString *strTimeToServer;
@property (nonatomic, assign)BOOL   isNotFirstIntoStatistics;
@property (nonatomic, strong)TodayStatisticsMapVC *todayStatisticsVC;

@end

@implementation TodayViewController
- (void)setdataForNav {
    self.titleForNav = @"统计详情";
}

- (void)viewDidLayoutSubviews{
    if (!isAdmin) {
        self.tableView.frame = CGRectMake(0, kscaleDeviceHeight(40), DeviceWidth, DeviceHeight-kscaleDeviceHeight(40)-kscaleDeviceHeight(64));
        
    }else{
         self.tableView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight-kscaleDeviceHeight(64));
        self.tableView.tableHeaderView.frame = CGRectZero;
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_todayStatisticsVC.mapView viewWillAppear];
    _todayStatisticsVC.mapView.delegate = _todayStatisticsVC;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [_todayStatisticsVC.mapView viewWillDisappear];
    _todayStatisticsVC.mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadOnlyOnce = true;
    self.pageController.pageName = @"CurrentPageNo";
    self.pageController.stepName = @"PageSize";
    
    if (isAdmin) {
        self.tableView.allowsSelection = true;
    }

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navigation_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonDidPress:)];
    self.navigationItem.leftBarButtonItem = barButton;  
    
    if (isAdmin) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_navigation_search"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidPress:)];
        self.navigationItem.rightBarButtonItem = barButton;
        
         _todayStatisticsVC= [[TodayStatisticsMapVC alloc] init];
        _tableView.hidden = YES;
        [_mapContainview addSubview: _todayStatisticsVC.view];
        APP_DELEGATE.rootMainViewController.enableGesture = false;
        _GLYTodayBottomView.frame = CGRectMake(0, DeviceHeight-kscaleIphone6DeviceHeight(50)-64, DeviceWidth, kscaleIphone6DeviceHeight(50));
        _mapContainview.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight-kscaleIphone6DeviceHeight(50)-64);
    }
    
    if (!isAdmin) {
        TodaySearchDayView *todaySearchDayView = [[TodaySearchDayView alloc] initWithFrame:CGRectMake(0, -1, DeviceWidth, kscaleDeviceHeight(40))];
        [self.view addSubview:todaySearchDayView];
        todaySearchDayView.todaySearchDayDelegate = self;
        self.strTimeToServer = todaySearchDayView.strTimeToServer;
        
        [self.tableView registerClass:[TodayStatisticsNewXHHeaderview class] forHeaderFooterViewReuseIdentifier:[TodayStatisticsNewXHHeaderview viewIdentifier]];
        [self.tableView registerNib:[UINib nibWithNibName:@"TodayStatisticsNewXHHeaderview" bundle:nil] forHeaderFooterViewReuseIdentifier:[TodayStatisticsNewXHHeaderview viewIdentifier]];
        [self.tableView registerNib:[UINib nibWithNibName:@"TodayStatisticsNewXHCell" bundle:nil] forCellReuseIdentifier:[TodayStatisticsNewXHCell cellIdentifier]];
    }
}

- (void)leftBarButtonDidPress:(UIBarButtonItem *)sender{
    [APP_DELEGATE.rootMainViewController showLeft];
}

- (void)rightBarButtonDidPress:(UIBarButtonItem *)sender{
//    static TodaySearchViewController *controller;
//    if (controller == NULL) {
//        controller = [[TodaySearchViewController alloc]init];
//    }
    TodaySearchViewController *controller=[[TodaySearchViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller setOnComplete:^(NSString *name, NSString *area,NSString * BuildingReportNumber,NSString* BuildUnitName,NSString * ConstructUnitName,NSString* SuperviseUnitName,NSString * DetectionUnitName) {
        NSMutableDictionary *params = [self.pageController.apiParams mutableCopy];
        [params removeObjectsForKeys:@[@"ProjectName",@"ProjectArea",@"BuildingReportNumber",@"BuildUnitName",@"ConstructUnitName",@"SuperviseUnitName",@"DetectionUnitName"]];
        if (STRING_NOT_EMPTY(name)) {
            params[@"ProjectName"] = name;
        }
        if (STRING_NOT_EMPTY(area)) {
            params[@"ProjectArea"] = area;
        }
        if (STRING_NOT_EMPTY(BuildingReportNumber)) {
            params[@"BuildingReportNumber"] = BuildingReportNumber;
        }
        if (STRING_NOT_EMPTY(BuildUnitName)) {
            params[@"BuildUnitName"] = BuildUnitName;
        }
        if (STRING_NOT_EMPTY(ConstructUnitName)) {
            params[@"ConstructUnitName"] = ConstructUnitName;
        }
        if (STRING_NOT_EMPTY(SuperviseUnitName)) {
            params[@"SuperviseUnitName"] = SuperviseUnitName;
        }
        if (STRING_NOT_EMPTY(DetectionUnitName)) {
            params[@"DetectionUnitName"] = DetectionUnitName;
        }
        self.pageController.apiParams = params;
        [self.pageController refreshNoMerge];

        [self.navigationController popViewControllerAnimated:YES];
    }];
}
//to Implement
- (void)toInitPageControllerWith:(NSString **) apiName params:(NSDictionary **)params{
    if(isManageUnit){
        *apiName = APIMETHOD_TS_TODAY_MANAGE_UNIT;
        *params  =  @{                             
                      @"Token" : [LoginUtil token],
                      @"Type"  : @(1),
//                      
//                      @"ProjectName"	:@"",
//                      @"ProjectArea"	:@""
        };
    }else{
        *apiName = APIMETHOD_TS_TODAY;
        *params  =  @{                             
                      @"Token" : [LoginUtil token],
                      @"Type"  : @(0),
                      @"SummDate" : self.strTimeToServer != nil ?self.strTimeToServer:[self FirstIntTimeValueToServer]
                      };        
    }

}
- (void)afterInitPageController:(LSPageController *)pageController{
    pageController.apiClass = @"TSAPI";
    [pageController setPageinfoAdapter:^(NSDictionary *input, BOOL *success, NSArray *__autoreleasing * list, int *totalCount, NSString *__autoreleasing *errorMessage) {
        
        *success = [input[kAPIConnectionStandartSuccessKey] boolValue];
        if (success) {
            if (isAdmin) {
                *list = input[kAPIConnectionStandartDataKey][@"ListContent"];
                *totalCount = [input[kAPIConnectionStandartDataKey][@"PageCount"] integerValue];
            }else{
                *list = input[kAPIConnectionStandartDataKey][@"JsonContent"][@"ItemList"];
                self.dicDataForToday =input[kAPIConnectionStandartDataKey][@"JsonContent"];
//                *totalCount = [input[kAPIConnectionStandartDataKey][@"JsonContent"][@"ItemList"] integerValue];
            }
            
        }else{
            *errorMessage = input[kAPIConnectionStandartMessageKey];
        } 
    }];
}

- (void)        simpleTableView:(UITableView *)tableView fillCell:(TodayTableViewCell *)cell withData:(NSDictionary *)item andIndexPath:(NSIndexPath *)indexPath{
    cell.data = item;
    if (isAdmin) {
        ((TodayAdminTableViewCell*)cell).deleagte = self;
    }
}
- (NSString *)  simpleTableViewCellNibName:(UITableView *)tableView{
    if (isAdmin) {
        return @"TodayAdminTableViewCell";
    }else{
        return @"TodayStatisticsNewXHCell";
    }
}
- (CGFloat)     simpleTableView:(UITableView *)tableView cellHeightForData:(NSDictionary *)item andIndexPath:(NSIndexPath *)indexPath;{
    if (isAdmin) {
        NSString *stringProjectName =[NSString stringWithFormat:@"项目名称：%@", item[@"ProjectName"]] ;
        CGFloat heightProjectName = [NSString calculateTextHeight:kscaleIphone5DeviceLength(269) Content:stringProjectName    font:themeFont17];
        heightProjectName = heightProjectName+5>35? heightProjectName  :kscaleDeviceHeight(17);
        NSString *stringProjectAdd = [NSString stringWithFormat:@"项目地址：%@", item[@"ProjectAddress"]] ;
        CGFloat heightProjectadd = [NSString calculateTextHeight:kscaleIphone5DeviceLength(269) Content:stringProjectAdd    font:themeFont17];
        heightProjectadd = heightProjectadd+5>35? heightProjectadd  :kscaleDeviceHeight(17);
        
//        return heightProjectName+25+45+45+45+heightProjectadd+25+45;
        return heightProjectName+kscaleDeviceHeight(23) +kscaleDeviceHeight(40)+kscaleDeviceHeight(40) +kscaleDeviceHeight(40)+heightProjectadd+kscaleDeviceHeight(23)+kscaleDeviceHeight(40);
    }else{
        return kscaleDeviceHeight(27);
    }
}
- (void)        simpleTableView:(UITableView *)tableView didSelectedWithData:(NSDictionary *)item andIndexPath:(NSIndexPath *)indexPath{
    if (isAdmin) {
        TodayAdminDetailViewController *controller = [[TodayAdminDetailViewController alloc]init];
        controller.projectId = item[@"ProjectId"];
        [self.navigationController pushViewController:controller animated:YES];
    }

    
}

#pragma mark ------UITableViewDelegate------
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!isAdmin&&self.dicDataForToday !=nil) {
        TodayStatisticsNewXHHeaderview *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[TodayStatisticsNewXHHeaderview viewIdentifier]];
        [view reloadDataForView:self.dicDataForToday];
        return view;
    }else{
        UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
//        viewBG.backgroundColor = [UIColor redColor];
       return viewBG;
    }
    
    
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!isAdmin) {
        return kscaleDeviceHeight(120);
    }
    return 0.01;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark -----TodayStatisticsStandardTimeDelegate-----
- (void)todaySearchDayView:(TodaySearchDayView *)todaySearchDayView standardTimeValue:(NSString *)standardTime{
    self.dicDataForToday  = nil;
    self.strTimeToServer = standardTime;
    [self setUpPageController];
    [self refreshNoMerge];
}

- (NSString *)FirstIntTimeValueToServer{
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *returnStr =[dateFormatter stringFromDate:[NSDate date]];
    return returnStr;
}

- (void)todayAdminTableViewCellTitleDidPress:(TodayAdminTableViewCell *) cell{
    if (isAdmin) {
        [LSDialog showDialogWithTitle:cell.data[@"ProjectName"] message:nil confirmText:@"查看" confirmCallback:^{
            TodayAdminDetailViewController *controller = [[TodayAdminDetailViewController alloc]init];
            controller.projectId = cell.data[@"ProjectId"];
            [self.navigationController pushViewController:controller animated:YES];
        } cancelText:@"关闭" cancelCallback:^{
        }];
    }
}

#pragma mark----事件点击－－－－
- (IBAction)btnClickDiTu:(UIButton *)sender {
    APP_DELEGATE.rootMainViewController.enableGesture = false;
    _btnDiTu.selected = YES;
    _btnList.selected = NO;
    _mapContainview.hidden =NO;
    _tableView.hidden =YES;
}
- (IBAction)btnClickList:(UIButton *)sender {
    APP_DELEGATE.rootMainViewController.enableGesture = true;
    _btnList.selected = YES;
    _btnDiTu.selected = NO;
    _tableView.hidden =NO;
    _mapContainview.hidden = YES;
}


@end
