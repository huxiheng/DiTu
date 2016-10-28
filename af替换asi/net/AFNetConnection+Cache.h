//
//  AFNetConnection+Cache.h
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNetConnection.h"
typedef enum{
    AFNetConnectionCacheConnectionMethodAny = 0,
    AFNetConnectionCacheConnectionMethodGet,
    AFNetConnectionCacheConnectionMethodPost,
    
}AFNetConnectionCacheConnectionMethod;

@interface AFNetConnection (Cache)
+ (void)addCache:(id)cache forGetWithUrl:(NSString *)url andParams:(NSDictionary *)params;
+ (void)addCache:(id)cache forPostWithUrl:(NSString *)url andParams:(NSDictionary *)params;

+ (id)cacheForGetWithUrl:(NSString *)url andParams:(NSDictionary *)params;
+ (id)cacheForPostWithUrl:(NSString *)url andParams:(NSDictionary *)params;
@end
