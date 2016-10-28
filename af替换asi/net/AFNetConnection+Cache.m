//
//  AFNetConnection+Cache.m
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNetConnection+Cache.h"
#import "LSCacheManager.h"
#import "LSCommonCrypto.h"
#import "AFNetConnection+synthesisGetUrl.h"
@implementation AFNetConnection (Cache)
+ (void)addCache:(id)cache forGetWithUrl:(NSString *)url andParams:(NSDictionary *)params{
    NSString *urlString = STRING_FORMAT(@"GET:%@", [self urlString:url withParams:params]);
    NSString *md5 = [LSCommonCrypto md5:urlString];
    [[LSCacheManager sharedInstance] addCache:cache hashCode:md5 expire:15*60];
    
}
+ (void)addCache:(id)cache forPostWithUrl:(NSString *)url andParams:(NSDictionary *)params{
    NSString *urlString = STRING_FORMAT(@"POST:%@", [self urlString:url withParams:params]);
    NSString *md5 = [LSCommonCrypto md5:urlString];
    
    [[LSCacheManager sharedInstance] addCache:cache hashCode:md5 expire:15*60];
}
+ (id)cacheForGetWithUrl:(NSString *)url andParams:(NSDictionary *)params{
    NSString *urlString = STRING_FORMAT(@"GET:%@", [self urlString:url withParams:params]);
    NSString *md5 = [LSCommonCrypto md5:urlString];
    
    return [[LSCacheManager sharedInstance] cache:md5 ignoreExpire:YES];
}

+ (id)cacheForPostWithUrl:(NSString *)url andParams:(NSDictionary *)params{
    NSString *urlString = STRING_FORMAT(@"POST:%@", [self urlString:url withParams:params]);
    NSString *md5 = [LSCommonCrypto md5:urlString];
    
    return [[LSCacheManager sharedInstance] cache:md5 ignoreExpire:YES];
}
@end
