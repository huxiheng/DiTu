//
//  NetWorkTools.h
//  AFnetworking封装
//
//  Created by Tesiro on 16/10/20.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

//typedef void (^afnetFinishedCallBack) (NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) ;
@interface NetWorkTools : AFHTTPSessionManager
/**
 *  创建当前类的一个单例
 *  
 */
+ (instancetype)sharedInstance;

-(void)request:(NSString *)urlString parameters:(NSMutableDictionary*)parameters finished:(void(^)(id  responseObject , NSError* error))afnetFinishedCallBack ;
@end
