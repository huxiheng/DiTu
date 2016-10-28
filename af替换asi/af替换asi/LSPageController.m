//
//  LSPageController.m
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "LSPageController.h"

NSString *kLSPageControllerPageName           = @"page";
NSString *kLSPageControllerStepName           = @"step";
int       kLSPageControllerStep               = 10;
NSString *kLSPageControllerListKey            = @"list";
NSString *kLSPageControllerPageInfoKey        = @"pageinfo";
NSString *kLSPageControllerPageInfoTotalKey   = @"total_page";

NSString *PageControllerErrorDomain = @"PageControllerErrorDomain";
@interface LSPageController ()
@property(nonatomic, assign)BOOL shouldMerge;

@end

@implementation LSPageController

-(id)init{
    self = [super init];
    if (self) {
        _apiClass = @"AFNet";
        _pageName = [kLSPageControllerPageName copy];
        _stepName = [kLSPageControllerStepName copy];
        _step = kLSPageControllerStep;
        _currentPage = 1;
        _keyName = @"id";
    }
    return self;
}
- (id)initWithApiName:(NSString *)apiName andParams:(NSDictionary *)apiParams{
    self = [self init];
    if (self) {
        _apiName = [apiName copy];
        _apiParams = [apiParams copy];
        if (_list == NULL) {
            _list = [[NSMutableArray alloc] init];
        }
    }
    return self;
}
-(void)releaseBlocks{
    _onNextFailedBlock = nil;
    _onNextSuccessBlock = nil;
    _onRefreashFailedBlock = nil;
    _onRefreashSuccessBlock = nil;
    _onCacheNextBlock = nil;
    _onCacheRefreashBlock = nil;
}
-(void)UpPage{
    _currentPage--;
    if (_currentPage<1) {
        _currentPage = 1;
        return;
    }
    
    NSMutableDictionary *params = (NSMutableDictionary*)[_apiParams mutableCopy];
    params[_stepName] = STRING_FROM_INT(_step);
    params[_pageName] = STRING_FROM_INT(_currentPage);
    _nextPageConnection =[[NSClassFromString(_apiClass) sharedInstance] connectionWithApiName:_apiName params:params];
    [_nextPageConnection setSuccessTarget:self selector:@selector(nextRequestDidSuccess:)];
    [_nextPageConnection setCacheSuccessTarget:self selector:@selector(nextRequestDidSuccess:)];
    [_nextPageConnection setOnFailed:_onNextFailedBlock];
    [_nextPageConnection setOnFinal:^{
        _isLoading = false;
    }];
    
    BOOL validatePass = true;
    if (validatePass) {
        _isLoading = true;
        [_nextPageConnection startAsynchronous];
    }
}
#pragma mark method 
-(void)nextPage{
    if (!self.hasMore) {
        if (_onNextFailedBlock) {
            NSError *error = [[NSError alloc] initWithDomain:PageControllerErrorDomain code:002 userInfo:@{NSLocalizedDescriptionKey:@"没有更多了"}];
            _onNextFailedBlock(error);
        }
        return;
    }
    _currentPage++;
    NSMutableDictionary *params = [_apiParams mutableCopy];
    params[_stepName] = STRING_FROM_INT(_step);
    params[_pageName] = STRING_FROM_INT(_currentPage);
    _nextPageConnection = [[NSClassFromString(_apiClass) sharedInstance]connectionWithApiName:_apiName params:params];
    [_nextPageConnection setSuccessTarget:self selector:@selector(nextRequestDidSuccess:)];
    [_nextPageConnection setCacheSuccessTarget:self selector:@selector(nextRequestDidSuccess:)];
    [_nextPageConnection setOnFailed:_onNextFailedBlock];
    [_nextPageConnection setOnFinal:^{
        _isLoading = false;
    }];
    BOOL validatePass = true;
    if (validatePass) {
        _isLoading = true;
        [_nextPageConnection startAsynchronous];
    }
}
- (void)nextPage:(UIScrollView *)dataScroll{
    if (!self.hasMore) {
        if (_onNextFailedBlock) {
            NSError *error = [[NSError alloc]initWithDomain:PageControllerErrorDomain code:002 userInfo:@{
                                                                                                          NSLocalizedDescriptionKey : @"没有更多啦"
                                                                                                          }];
//            [dataScroll.footer endRefreshing];
            
            _onNextFailedBlock(error);
            
            
        }
        return ;
    }
    _currentPage ++;
    
    NSMutableDictionary *params = [_apiParams mutableCopy];
    params[_stepName] = STRING_FROM_INT(_step);
    params[_pageName] = STRING_FROM_INT(_currentPage);
    _nextPageConnection = [[NSClassFromString(_apiClass) sharedInstance]connectionWithApiName:_apiName params:params];
    
    [_nextPageConnection setSuccessTarget:self selector:@selector(nextRequestDidSuccess:)];
    [_nextPageConnection setCacheSuccessTarget:self selector:@selector(nextRequestDidSuccess:)];
    
    [_nextPageConnection setOnFailed:_onNextFailedBlock];
    [_nextPageConnection setOnFinal:^{
        _isLoading = false;
    }];
    
    BOOL validatePass = true;
    if(_beforeNextPageRequestBlock){
        validatePass = _beforeNextPageRequestBlock(_nextPageConnection);
    }
    if (validatePass) {
        _isLoading = true;
        [_nextPageConnection startAsynchronous];
    }
    
}
- (void)refresh{
    [self refresh:NO];
}
- (void)refreshNoMerge{
    [self refresh:NO];
}
- (void)refresh:(BOOL)shoudMerge{
    [self cancelRefreashing];
    NSMutableDictionary *params = [_apiParams mutableCopy];
    params[_stepName] = STRING_FROM_INT(_step);
    params[_pageName] = STRING_FROM_INT(1);
    if (shoudMerge == false) {
        _currentPage = 1;
        [SVProgressHUD show];
    }
    _refreashConnection = [[NSClassFromString(_apiClass) sharedInstance] connectionWithApiName:_apiName params:params];
    _refreashConnection.addCache = false;
    _shouldMerge = shoudMerge;
    [_refreashConnection setSuccessTarget:self selector:@selector(refreashRequestDidSuccess:)];
    [_refreashConnection setCacheSuccessTarget:self selector:@selector(refreashRequestDidSuccess:)];
    [_refreashConnection setOnFailed:_onRefreashFailedBlock];
    [_refreashConnection setOnFinal:^{
        if (shoudMerge == false) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (_list.count==0) {
                        
                        [SVProgressHUD showImage:nil status:@"服务器没有返回数据呦！" maskType:SVProgressHUDMaskTypeNone];
                    }else{
                        [SVProgressHUD dismiss];
                    }
                });
            });
            
        }
        _isRefreashing = false;
    }];
    [_refreashConnection loadFromCache];
    BOOL validatePass = true;
    if (validatePass) {
        _isRefreashing = true;
        [_refreashConnection startAsynchronous];
    }
}
-(void)clearList{
    [_list removeAllObjects];
}
-(void)cancelLoading{
    if (_isLoading) {
        _isLoading = false;
    }
}
- (void)cancelRefreashing{
    if (_isRefreashing) {
        _isRefreashing = false;
    }
}
#pragma mark response handler
-(void) refreashRequestDidSuccess:(NSDictionary *)result{
    NSArray *listData = NULL;
    BOOL isSuccess = false;
    NSString *errorMessage;
    if (_pageinfoAdapter) {
        _pageinfoAdapter(result,&isSuccess,&listData,&_totalPage,&errorMessage);
    }else if (IS_CLASS_OF(result[kLSPageControllerPageInfoKey], NSDictionary)&&IS_CLASS_OF(result[kLSPageControllerListKey], NSArray)) {
        NSDictionary *pageInfo = result[kLSPageControllerPageInfoKey];
        _totalPage  = [pageInfo[kLSPageControllerPageInfoTotalKey] intValue];
        listData    = result[kLSPageControllerListKey];
        isSuccess = true;
    }else{
        isSuccess = false;
        errorMessage = @"网络访问类型不为DH标准的分页格式";
    }
    if (isSuccess) {
        NSMutableArray *newlistElement = [listData mutableCopy];
        if (_shouldMerge) {
           [self _mergeArray:_list with:newlistElement withKeyName:_keyName at:DHPageControllerMergeDirectionFront];
        }else{
            self.list = newlistElement;
        }
        if (_refreashConnection.isCacheLoading) {
            if (_onCacheRefreashBlock) {
                _onCacheRefreashBlock(_list,result);
            }
        }else{
            if (_onRefreashSuccessBlock) {
                _onRefreashSuccessBlock(_list,result);
            }
            _refreashConnection.addCache = true;
        }
    }else{
        NSError *error = [[NSError alloc]initWithDomain:PageControllerErrorDomain
                                                   code:001
                                               userInfo:@{ NSLocalizedDescriptionKey : STRING_EMPTY_IF_NULL(errorMessage) }];
        _onRefreashFailedBlock(error);
    }
}
-(void)nextRequestDidSuccess:(NSDictionary *)result{
    NSArray *listData = NULL;
    BOOL isSuccess = false;
    NSString *errorMessage;
    if (_pageinfoAdapter) {
        _pageinfoAdapter(result,&isSuccess,&listData,&_totalPage,&errorMessage);
    }else if (IS_CLASS_OF(result[kLSPageControllerPageInfoKey], NSDictionary)&&IS_CLASS_OF(result[kLSPageControllerListKey], NSArray)) {
        isSuccess   = true;
        NSDictionary *pageInfo = result[kLSPageControllerPageInfoKey];
        _totalPage  = [pageInfo[kLSPageControllerPageInfoTotalKey] intValue];
        listData    = result[kLSPageControllerListKey];
    }else{
        isSuccess   = false;
        errorMessage= @"网络访问类型不为DH标准的分页格式";
        
    }
    if (isSuccess) {
        NSMutableArray *newlistElement = [listData mutableCopy];
        if (_isOnlyTenDataShow) {
            [_list removeAllObjects];
            [_list addObjectsFromArray:newlistElement];
        }else{
            [self _mergeArray:_list with:newlistElement withKeyName:_keyName at:DHPageControllerMergeDirectionTail];
        }
        if (_nextPageConnection.isCacheLoading) {
            if (_onCacheNextBlock) {
                _onCacheNextBlock(_list,result);
            }
        }else{
            if (_onNextSuccessBlock) {
                _onNextSuccessBlock(_list,result);
            }
        }
    }else{
        NSError *error = [[NSError alloc]initWithDomain:PageControllerErrorDomain code:001 userInfo:@{
                                                                                                      NSLocalizedDescriptionKey : STRING_EMPTY_IF_NULL(errorMessage)
                                                                                                      }];
        _onNextFailedBlock(error);
    }
}
#pragma mark private method
- (void)_mergeArray:(NSMutableArray *)destination with:(NSMutableArray *)src withKeyName:(NSString *)keyname at:(DHPageControllerMergeDirection)direction{
    if (!(IS_CLASS_OF(destination, NSMutableArray))&&IS_CLASS_OF(src, NSMutableArray)) {
        return;
    }
    switch (direction) {
        case DHPageControllerMergeDirectionFront:{
            NSMutableArray *source = [src mutableCopy];
            int *shouldRemoveIndexs = (int *)malloc(sizeof(int)*source.count);
            int shouldRemoveIndexsCount = 0;
            for(int i = 0 ; i < source.count ;i ++){
                NSDictionary *data = source[i];
                NSString *key = data[keyname];
                if (IS_CLASS_OF(key, NSString)) {
                    int index = [self _indexOfObject:data ByKey:keyname inArray:destination];
                    if (index >= 0) {
                        destination[index] = data;
                        shouldRemoveIndexs[shouldRemoveIndexsCount] = i;
                        shouldRemoveIndexsCount++;
                    }
                }
            }
            for (int i = shouldRemoveIndexsCount -1 ; i >=0; i--) {
                [source removeObjectAtIndex:shouldRemoveIndexs[i]];
            }
            free(shouldRemoveIndexs);
            
            
            [source addObjectsFromArray:destination];
            [destination setArray:source];
            break;
        }
            
            
        case DHPageControllerMergeDirectionTail:{
            NSMutableArray *source = [src mutableCopy];
            int *shouldRemoveIndexs = (int *)malloc(sizeof(int)*source.count);
            int shouldRemoveIndexsCount = 0;
            for(int i = 0 ; i < source.count ;i ++){
                NSDictionary *data = source[i];
                NSString *key = data[keyname];
                if (IS_CLASS_OF(key, NSString)) {
                    int index = [self _indexOfObject:data ByKey:keyname inArray:destination];
                    if (index >= 0) {
                        destination[index] = data;
                        shouldRemoveIndexs[shouldRemoveIndexsCount] = i;
                        shouldRemoveIndexsCount++;
                    }
                }
            }
            for (int i = shouldRemoveIndexsCount -1 ; i >=0; i--) {
                [source removeObjectAtIndex:shouldRemoveIndexs[i]];
            }
            free(shouldRemoveIndexs);
            
            [destination addObjectsFromArray:source];
            break;
        }
        default:
            break;
    }
}
- (int)_indexOfObject:(NSDictionary *)object ByKey:(NSString *)key inArray:(NSArray *)src{
    if (!(IS_CLASS_OF(object, NSDictionary)&&IS_CLASS_OF(key,NSString)&&IS_CLASS_OF(src, NSArray))) {
        return  -1;
    }
    
    for (int i =  0; i<src.count; i ++ ) {
        if([src[i][key] isEqual:object[key]]) return i;
    }
    return  -1;
}

#pragma mark Setter and Getter
- (BOOL)isBusy{
    return _isLoading||_isRefreashing;
}
-(BOOL)hasMore{
    return _currentPage<_totalPage;
}
@end

@implementation LSPageController (DefaultSetting)
+ (void)setDefaultStepName:(NSString *)stepName{
    kLSPageControllerStepName = stepName;
}
+ (void)setDefaultPageName:(NSString *)pageName{
    kLSPageControllerStepName = pageName;
}
+ (void)setDefaultStep:(int)step{
    kLSPageControllerStep    = step;
}

+ (void)setDefaultListKey:(NSString *)listKey{
    kLSPageControllerListKey = listKey;
}
+ (void)setDefaultPageInfoKey:(NSString *)pageinfokey{
    kLSPageControllerPageInfoKey = pageinfokey;
}
+ (void)setDefaultPageInfoTotalKey:(NSString *)totalkey{
    kLSPageControllerPageInfoTotalKey = totalkey;
}
@end
