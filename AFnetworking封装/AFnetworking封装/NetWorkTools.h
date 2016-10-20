//
//  NetWorkTools.h
//  AFnetworking封装
//
//  Created by Tesiro on 16/10/20.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger,RequestType) {
    RequestTypeGet,
    RequestTypePost
};
@interface NetWorkTools : AFHTTPSessionManager

/**
 *  创建当前类的一个单例
 *  
 */
+ (instancetype)sharedInstance;

-(void)requestMethodType:(RequestType)RequestType urlString:(NSString *)urlString parameters:(NSMutableDictionary*)parameters finished:(void(^)(id  responseObject , NSError* error))afnetFinishedCallBack ;
//func loadAccessToken(code : String, finished : (result : [String : AnyObject]?, error : NSError?) -> ())
-(void)loadAccessToken:(NSString *)code finish:(void(^)(NSDictionary *result,NSError *error ))finished;
@end
