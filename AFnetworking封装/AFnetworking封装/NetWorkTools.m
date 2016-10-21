//
//  NetWorkTools.m
//  AFnetworking封装
//
//  Created by Tesiro on 16/10/20.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "NetWorkTools.h"

static NetWorkTools *shareObject;
typedef void (^successCallBack)(NSURLSessionDataTask * _Nonnull, id _Nullable) ;
@implementation NetWorkTools
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[NetWorkTools alloc]init];
        shareObject.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
    });
    return shareObject;
}

-(void)requestMethodType:(RequestType)RequestType urlString:(NSString *)urlString parameters:(NSMutableDictionary*)parameters finished:(void(^)(id  responseObject , NSError* error))afnetFinishedCallBack    {
    
    if (RequestType == RequestTypeGet) {
        [self GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            afnetFinishedCallBack(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            afnetFinishedCallBack(nil , error);
        }];
    }else{
        [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            afnetFinishedCallBack(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             afnetFinishedCallBack(nil , error);
        }];
    }
    
    
}


@end
