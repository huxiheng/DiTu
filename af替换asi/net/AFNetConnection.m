//
//  AFNetConnection.m
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNetConnection.h"
NSString* const DhServerOperationFailedDomain   = @"DhServerOperationFailedDomain";
NSString* const APINetwordFailedDomain          = @"APINetwordFailedDomain";

NSString* kAFNETConnectionStandartSuccessKey      = @"Success";
NSString* kAFNETConnectionStandartDataKey         = @"Data";
NSString* kAFNETConnectionStandartMessageKey      = @"Message";
NSString* kAFNETConnectionStandartErrorCodeKey      = @"Code";
@interface AFNetConnection ()


@property(nonatomic,retain) id<NSObject>  successTarget;
@property(nonatomic,assign) SEL successSelector;
@property(nonatomic,retain) id<NSObject>  failedTarget;
@property(nonatomic,assign) SEL failedSelector;
@property(nonatomic,retain) id<NSObject>  cacheSuccessTarget;
@property(nonatomic,assign) SEL cacheSuccessSelector;


@end
@implementation AFNetConnection

- (id)      initWithConnectionUrlString:(NSString *)requestUrl{
    
    self = [super initWithBaseURL:[NSURL URLWithString:requestUrl]]; //ASIFormDataRequest
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        _requestUrl = [requestUrl copy];
        _addCache = true;
    }
    return self;
}

//- (void)dealloc
//{
//    [self connectionReleaseBlocksOnMainThread];
//    [super dealloc];
//}
- (void)releaseBlocks{
    _onSuccess = nil;
    _onFailed = nil;
    _onFinal = nil;
    _onCacheSuccess = nil;
}

- (void)connectionReleaseBlocksOnMainThread{
    NSMutableArray *blocks = [NSMutableArray array];
    if (_onSuccess) {
        [blocks addObject:_onSuccess];
        _onSuccess = nil;
    }
    if (_onFailed) {
        [blocks addObject:_onFailed];
        _onFailed = nil;
    }
    if (_onFinal) {
        [blocks addObject:_onFinal];
        _onFinal = nil;
    }
    if (_onCacheSuccess) {
        [blocks addObject:_onCacheSuccess];
        _onCacheSuccess = nil;
    }
    [[self class] performSelectorOnMainThread:@selector(releaseBlocks) withObject:blocks waitUntilDone:[NSThread isMainThread]];
}
- (id) proccessResult:(NSString*)responseString{
    if (self.responseFormat) {
        NSString *resultString = nil;
        self.responseFormat(responseString,&resultString) ;
        responseString = resultString;
    }
    switch (_resultType) {
        case kAFNetConnectionTypeStandart:
        case kAFNetConnectionTypeJSON:{
            NSDictionary *json = apiFilterObject([responseString JSONValue]);
            
        }
            return apiFilterObject([responseString JSONValue]);
            break;
            
        case kAFNetConnectionTypePlain:
        default:
            return responseString;
            break;
    }
    return NULL;
}

-(void)prepareForRequest{
    __block typeof(self) bSelf = self;
    if (self.requestMethod == kAFNetConnectionRequestTypeGet) {
        [self GET:_requestUrl parameters:_params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *response=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            [bSelf onConnectionCompelte:response];
            if (!bSelf->_isCacheLoading) {
                [bSelf releaseBlocks];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            if (bSelf->_onFailed) {
                bSelf->_onFailed(error);
            }
            if(bSelf->_onFinal)  bSelf->_onFinal();
            [bSelf releaseBlocks];
        }];
    }else if(self.requestMethod == kAFNetConnectionRequestTypePost){
        [self POST:_requestUrl parameters:_params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *response=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            [bSelf onConnectionCompelte:response];
            if (!bSelf->_isCacheLoading) {
                [bSelf releaseBlocks];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (bSelf->_onFailed) {
                bSelf->_onFailed(error);
            }
            if(bSelf->_onFinal)  bSelf->_onFinal();
            [bSelf releaseBlocks];
        }];
    }
    
}

-(void)startAsynchronous{
    [self prepareForRequest];
    _isCacheLoading = false;
}
- (void)setSuccessTarget:(id)target selector:(SEL)selector{
    self.successTarget = target;
    _successSelector = selector;
}

- (void)setFailedTarget:(id)target selector:(SEL)selector{
    self.failedTarget = target;
    _failedSelector = selector;
}

-(void)setCacheSuccessTarget:(id)target selector:(SEL)selector{
    self.cacheSuccessTarget = target;
    _cacheSuccessSelector = selector;
}

-(void)onConnectionCompelte:(NSString *)responseString{
    id result = [self proccessResult:responseString];
    if (!result) {
        if (STRING_NOT_EMPTY(responseString)) {
            NSError *anError = [[NSError alloc]initWithDomain:DhServerOperationFailedDomain code:2 userInfo:@{
                                                                                                              NSLocalizedDescriptionKey : responseString
                                                                                                              //NSLocalizedString(@"服务器发生错误，请稍后再试", @"The server encountered an exception. Please try again later.")
                                                                                                              }];
            if(self->_onFailed) self->_onFailed(anError);
            if(self->_onFinal) self->_onFinal();
            if ([_failedTarget respondsToSelector:_failedSelector]) {
                [_failedTarget performSelector:_failedSelector withObject:anError];
            }
        }else{
            NSError *nullError = [[NSError alloc]initWithDomain:APINetwordFailedDomain code:1 userInfo:@{
                                                                                                         NSLocalizedDescriptionKey : responseString
                                                                                                         //NSLocalizedString(@"服务器发生错误，请稍后再试", @"The server encountered an exception. Please try again later.")
                                                                                                         }];
            if (self->_onFailed) self->_onFailed(nullError);
            if(self->_onFinal) self->_onFinal();
            if ([_failedTarget respondsToSelector:_failedSelector]) {
                [_failedTarget performSelector:_failedSelector withObject:nullError];
            }
        }
    }else{
        [self _connectionCompleteWithResponse:responseString andProccessedResult:result];
    }
}
- (void)_connectionCompleteWithResponse:(NSString *)responseString andProccessedResult:(id)result{
    if (self->_resultType == kAFNetConnectionTypeStandart || self.preproccess) {
        result = LS_CAST(NSDictionary *, result);
        if ([result[kAFNETConnectionStandartSuccessKey] boolValue]) {
            if (_isCacheLoading) {
                if (self.onCacheSuccess) {
                    self.onCacheSuccess(result);
                }else if(self->_onSuccess) {
                    self->_onSuccess(result);
                }
                if ([_cacheSuccessTarget respondsToSelector:_cacheSuccessSelector]) {
                    [_cacheSuccessTarget performSelector:_cacheSuccessSelector withObject:result];
                }else if ([_successTarget respondsToSelector:_successSelector]) {
                    [_successTarget performSelector:_successSelector withObject:result];
                }
            }else{
                if(self->_onSuccess) {
                    self->_onSuccess(result);
                }
                
                if ([_successTarget respondsToSelector:_successSelector]) {
                    [_successTarget performSelector:_successSelector withObject:result];
                }
                
                if (_addCache) {
                    if (self.requestMethod ==kAFNetConnectionRequestTypePost) {
                        [AFNetConnection addCache:responseString forPostWithUrl:_requestUrl andParams:self.params];
                    }else{
                        [AFNetConnection addCache:responseString forGetWithUrl:_requestUrl  andParams:self.params];
                    }
                }
                if(self->_onFinal) self->_onFinal();
            }
        }else{
            int code = 0;
            if (result[kAFNETConnectionStandartErrorCodeKey]) {
                code= [result[kAFNETConnectionStandartErrorCodeKey] intValue];
            }
            NSError *anError = [[NSError alloc]initWithDomain:DhServerOperationFailedDomain
                                                         code:code
                                                     userInfo:@{NSLocalizedDescriptionKey : result[kAFNETConnectionStandartMessageKey]}
                                ];
            
            if ([_failedTarget respondsToSelector:_failedSelector]) {
                [_failedTarget performSelector:_failedSelector withObject:anError];
            }
            if(self->_onFailed) self->_onFailed(anError);
            if(self->_onFinal) self->_onFinal();
        }
    }else{
        if (_isCacheLoading) {
            if (self.onCacheSuccess) {
                self.onCacheSuccess(result);
            }
        }else{
            if(self->_onSuccess) self->_onSuccess(result);
            if ([_successTarget respondsToSelector:_successSelector]) {
                [_successTarget performSelector:_successSelector withObject:result];
            }
            if (_addCache) {
                if (self.requestMethod ==kAFNetConnectionRequestTypePost) {
                    [AFNetConnection addCache:responseString forPostWithUrl:_requestUrl andParams:self.params];
                }else{
                    [AFNetConnection addCache:responseString forGetWithUrl:_requestUrl  andParams:self.params];
                }
            }
            
            if(self->_onFinal) self->_onFinal();
        }
    }
}

-(void)cancal{
    [self releaseBlocks];
}
- (void)    loadFromCache{
    _isCacheLoading = true;
    id result;
    if (self.requestMethod ==kAFNetConnectionRequestTypePost) {
        result = [AFNetConnection cacheForPostWithUrl:_requestUrl andParams:self.params];
    }else{
        result = [AFNetConnection cacheForGetWithUrl:_requestUrl  andParams:self.params];
    }
    if (result){
        @try {
            [self onConnectionCompelte:result];
        }
        @catch (NSException *exception) {
            
        }
    }
    _isCacheLoading = false;
}
-(void)enableCache{
    
}
-(void)disableCache{
    
}
    
@end
id           apiFilterObject(id object){
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = object;
        NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            resultDictionary[key] = apiFilterObject(obj);
        }];
        return resultDictionary;
    }else if([object isKindOfClass:[NSArray class]]){
        NSArray *array = object;
        NSMutableArray *resultArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [resultArray addObject:apiFilterObject(obj)];
        }];
        return resultArray;
    }else if([object isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@",object];
    }else if(object == [NSNull null]){
        return @"";
    }else{
        return object;
    }
}

