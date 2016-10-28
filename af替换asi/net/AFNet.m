//
//  AFNet.m
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNet.h"



static NSString * serverUrl = @"www.scetia.com/";
@implementation AFNet
static AFNet *shareObject;
+ (AFNet *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[AFNet alloc] init];
    });
    return shareObject;
}
- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setServerUrl:(NSString *)serverUrl{
    _afnetConfig = [_afnetConfig mutableCopy];
    ((NSMutableDictionary *)_afnetConfig)[AFNETSiteUrlKey] = [NSString stringWithFormat:@"%@/scetia.app.ws/ServiceUST.asmx",serverUrl];
}

- (AFNetConnection *)connectionWithApiName:(NSString *) apiName params:(NSDictionary *)params{
    NSDictionary *apiOptions = _afnetMethod[apiName];//获取方法名的字典
    NSAssert(DICTIONARY_NOT_EMPTY(apiOptions), @"can't find method");
    AFNetConnection *connection;
    if ([apiOptions[AFNET_CONNECT_METHOD] isEqualToString:AFNET_CONNECT_METHOD_SOAP]) {
        
    }else{
        NSString *requestUrl = [self getUrlStringByApiName:apiName];
        connection = [[AFNetConnection alloc] initWithConnectionUrlString:requestUrl ];
    }
    [connection setResultType:kAFNetConnectionTypeJSON];
    if (_afnetConfig[AFNETResultFormatKey]) {
        [connection setResponseFormat:_afnetConfig[AFNETResultFormatKey]];
    }
    if (STRING_NOT_EMPTY(apiOptions[AFNET_CONNECT_METHOD])) {
        connection.requestMethod = kAFNetConnectionRequestTypePost;
    }else{
        connection.requestMethod = kAFNetConnectionRequestTypeGet;
    }
    if (apiOptions[AFNET_RESULT_TYPE]) {
        [connection setResultType:[apiOptions[AFNET_RESULT_TYPE] intValue]];
    }else{
       [connection setResultType:kAFNetConnectionTypeStandart];
    }
    connection.params = params;
    
    return connection;
}

///根据方法名获取请求网络的url
-(NSString*)getUrlStringByApiName:(NSString *)apiname{
    NSDictionary *apiOptions = _afnetMethod[apiname];
    NSString *requestUrl = apiOptions[AFNET_URL];
    return [NSString stringWithFormat:@"%@://%@%@",_afnetConfig[AFNETHTTPMethodKey],_afnetConfig[AFNETSiteUrlKey],requestUrl];
}
@end
