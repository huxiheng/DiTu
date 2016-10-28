//
//  AFNetConnection+synthesisGetUrl.m
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNetConnection+synthesisGetUrl.h"

@implementation AFNetConnection (synthesisGetUrl)
+ (NSString *)urlString:(NSString *)urlString withParams:(NSDictionary *)params{
    __block NSMutableString    *paramsString = [[[NSMutableString alloc]initWithCapacity:1024] autorelease];
    __block BOOL                isFirst = true;
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (![obj isKindOfClass:[NSArray class]]) {
                obj = @[obj];
            }
            if([obj isKindOfClass:[NSArray class]]){
                for (NSString* string in obj ) {
                    if ([string isKindOfClass:[NSNumber class]]) {
                        string = [LS_CAST(NSNumber *, string) stringValue];
                    }
                    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    if (string .length == 0) return ;
                    if (isFirst) {
                        isFirst = false;
                        [paramsString appendFormat:@"%@=%@" ,key ,string];
                    }  else [paramsString appendFormat:@"&%@=%@" ,key ,string ];
                    
                }
            }
        }];
    }
    //Added by lessu 2013 11 25
    if([urlString rangeOfString:@"?"].length == 0){
        return STRING_FORMAT(@"%@%@%@", urlString,paramsString.length>0?@"?":@"",paramsString);
    }else{
        return STRING_FORMAT(@"%@%@%@", urlString,paramsString.length>0?@"&":@"",paramsString);
    }
    
}
@end
