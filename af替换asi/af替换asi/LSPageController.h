//
//  LSPageController.h
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetConnection.h"


extern NSString *kLSPageControllerPageName;
extern NSString *kLSPageControllerStepName;
extern int       kLSPageControllerStep;
//extern NSString *kLSPageControllerListKey;
//extern NSString *kLSPageControllerPageInfoKey;
//extern NSString *kLSPageControllerPageInfoTotalKey;
typedef enum  {
    DHPageControllerMergeDirectionFront,
    DHPageControllerMergeDirectionTail
} DHPageControllerMergeDirection;
@interface LSPageController : NSObject{
@protected
    NSString            * _stepName;
    NSString            * _pageName;
    NSMutableArray      *_list;
    BOOL                _hasMore;
    int                 _count;
    int                 _totalPage;
    int                 _totalCount;
    int                 _currentPage;
    AFNetConnection       *_nextPageConnection;
    AFNetConnection       *_refreashConnection;
}
@property(nonatomic,retain) NSString *apiClass;

@property(copy,nonatomic) NSString * stepName;
@property(copy,nonatomic) NSString * pageName;
//数据主键名
@property(copy,nonatomic) NSString * keyName;
@property(nonatomic,readwrite,retain) NSMutableArray *list;
@property(nonatomic,readonly)   BOOL   hasMore;
@property(nonatomic,readonly)   int count;
@property(nonatomic,readonly)   int totalPage;
@property(nonatomic,readonly)   int totalCount;

@property(nonatomic,readonly)   int currentPage;
@property(nonatomic,assign)     int step;
//@property(nonatomic,readonly)   APIConnection *nextPageConnection;
//@property(nonatomic,readonly)   APIConnection *refreashConnection;

@property(nonatomic,copy)       void(^onNextSuccessBlock)(NSArray *mergedList,NSDictionary *result);
@property(nonatomic,copy)       void(^onNextFailedBlock)(NSError *error);
@property(nonatomic,copy)       void(^onRefreashSuccessBlock)(NSArray *mergedList,NSDictionary *result);
@property(nonatomic,copy)       void(^onRefreashFailedBlock)(NSError *error);
@property(nonatomic,copy)       BOOL(^beforeNextPageRequestBlock)(AFNetConnection *nextConnection);
@property(nonatomic,copy)       BOOL(^beforeRefreashRequestBlock)(AFNetConnection *refreashConnection);

@property(nonatomic,copy)       void(^onCacheRefreashBlock)(NSArray *mergedList,NSDictionary *result);
@property(nonatomic,copy)       void(^onCacheNextBlock)(NSArray *mergedList,NSDictionary *result);

@property(nonatomic,copy)       void(^pageinfoAdapter)(NSDictionary *inputdata,BOOL *success,NSArray **outputList,int *totalCount,NSString **errorMessage);

@property(nonatomic,readonly)   BOOL isLoading;
@property(nonatomic,readonly)   BOOL isRefreashing;
@property(nonatomic,readonly)   BOOL isBusy;

@property(nonatomic,copy)       NSString *apiName;
@property(nonatomic,copy)       NSDictionary *apiParams;
@property(nonatomic,assign)     BOOL isOnlyTenDataShow;
- (id)initWithApiName:(NSString *)apiName;
- (id)initWithApiName:(NSString *)apiName andParams:(NSDictionary *)apiParams;

//load and refresh
- (void)nextPage:(UIScrollView *)dataScroll;
- (void)nextPage;
- (void)refresh:(BOOL)shoudMerge;
- (void)refresh;
- (void)refreshNoMerge;

- (void)clearList;
- (void)releaseBlocks;
- (void)cancelLoading;
- (void)cancelRefreashing;

//#ifdef TESTS
//极限测试，边界测试
//- (void)_mergeArray:(NSMutableArray *)destination with:(NSMutableArray *)src at:(DHPageControllerMergeDirection)direction;
- (void)_mergeArray:(NSMutableArray *)destination with:(NSMutableArray *)src withKeyName:(NSString *)keyname at:(DHPageControllerMergeDirection)direction;
//极限测试，边界测试
- (int)_indexOfObject:(NSDictionary *)object ByKey:(NSString *)key inArray:(NSArray *)src;
//#endif
-(void)UpPage;
-(void)getData;
@end
@interface LSPageController (DefaultSetting)
+ (void)setDefaultStepName:(NSString *)stepName;
+ (void)setDefaultPageName:(NSString *)pageName;

+ (void)setDefaultListKey:(NSString *)listKey;
+ (void)setDefaultPageInfoKey:(NSString *)pageinfokey;
+ (void)setDefaultPageInfoTotalKey:(NSString *)totalkey;
@end

