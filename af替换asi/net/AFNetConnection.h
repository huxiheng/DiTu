//
//  AFNetConnection.h
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "NSString+SBJSON.h"
#import "constance.h"

extern NSString* kAFNETConnectionStandartSuccessKey;
extern NSString* kAFNETConnectionStandartDataKey;
extern NSString* kAFNETConnectionStandartMessageKey;

typedef enum{
    kAFNetConnectionTypePlain = 0,
    kAFNetConnectionTypeJSON,
    kAFNetConnectionTypeStandart
    
} AFNetConnectionResultType;
typedef enum {
    kAFNetConnectionRequestTypeGet = 0,
    kAFNetConnectionRequestTypePost
} AFNetConnectionRequestType;

@interface AFNetConnection : AFHTTPSessionManager
{
    AFNetConnectionResultType         _resultType;
    BOOL                            _usingCache;
    NSDictionary                    *_params;
}
//@property(nonatomic,readonly) ASIHTTPRequest            *request;
@property(nonatomic,copy) void (^onSuccess)(id result);
@property(nonatomic,copy) void (^onFailed)(NSError* error);
@property(nonatomic,copy) void (^onFinal)();
@property(nonatomic,copy) void (^onCacheSuccess)(id result);
@property(nonatomic,assign)AFNetConnectionResultType      resultType;
@property (nonatomic,assign)AFNetConnectionRequestType requestMethod;

@property(nonatomic,copy)   NSDictionary*               params;
@property(nonatomic,copy) void (^preproccess)     (NSDictionary *input,BOOL *success,id* data,NSString **message);
@property(nonatomic,copy) void (^responseFormat)  (NSString *input,NSString **output);

@property(nonatomic,copy) NSString* requestUrl;

///获取数据的请求
- (void)    startAsynchronous;
- (void)    startSynchronous;

- (id)      initWithConnectionUrlString:(NSString *)requestUrl;

@property(nonatomic,assign) BOOL                        addCache;
@property(nonatomic,assign) BOOL                        isCacheLoading;

- (void)    loadFromCache;
- (void)prepareForRequest;
- (void)    onConnectionCompelte:(NSString *)responseString;
- (void)    enableCache;
- (void)    disableCache;

- (void)    setURLString:(NSString *)urlString;

- (void)    setSuccessTarget:(id)target selector:(SEL)selector;
- (void)    setFailedTarget:(id)target selector:(SEL)selector;
- (void)    setCacheSuccessTarget:(id)target selector:(SEL)selector;

@end
id           apiFilterObject(id object);
