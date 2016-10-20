//
//  NetWorkTools.m
//  AFnetworking封装
//
//  Created by Tesiro on 16/10/20.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "NetWorkTools.h"

static NetWorkTools *shareObject;
@implementation NetWorkTools
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[NetWorkTools alloc]init];
        
    });
    return shareObject;
}

-(void)request:(NSString *)urlString parameters:(NSMutableDictionary*)parameters finished:(void(^)(id  responseObject , NSError* error))afnetFinishedCallBack    {
    [self GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        afnetFinishedCallBack(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        afnetFinishedCallBack(nil , error);
    }];
    
}
@end
