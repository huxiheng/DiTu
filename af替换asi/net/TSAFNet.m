//
//  TSAFNet.m
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "TSAFNet.h"
#import "RegexKitLite.h"

@implementation TSAFNet
SHARED_INSTANCE_IMPLEMENT(TSAFNet, _tsAFNet, );
- (instancetype)init
{
    self = [super init];
    if (self) {
        _afnetConfig = @{
                       AFNETSiteUrlKey           : @"www.scetia.com/scetia.app.ws/ServiceTS.asmx",
                       AFNETHTTPMethodKey        : @"http",
                       AFNETResultFormatKey      : ^(NSString *input,NSString **output){
                           NSString *responseString = input;
                           responseString = [responseString stringByMatching:@">\\{.+\\}</"];
                           responseString = [responseString stringByReplacingOccurrencesOfString:@">{" withString:@"{" ];
                           responseString = [responseString stringByReplacingOccurrencesOfString:@"}</" withString:@"}" ];
                           *output = responseString;
                       }
                       };
        
        _afnetMethod = @{
                       AFNETMETHOD_TS_TODAY_MANAGE_UNIT       : AFNET_DEF_GET(@"/ManageUnitTodayStatisProjectList"),
                       AFNETMETHOD_TS_TODAY                   : AFNET_DEF_GET(@"/DetectionTodayStatis"),
                       AFNETMETHOD_TS_TODAY_MANAGE_UNIT_DETAIL:AFNET_DEF_GET(@"/ManageUnitTodayStatisInfoList")
                       
                       };
    }
    return self;
}
- (void)setServerUrl:(NSString *)serverUrl{
    _afnetConfig= [_afnetConfig mutableCopy];
    ((NSMutableDictionary *)_afnetConfig)[AFNETSiteUrlKey] = [NSString stringWithFormat:@"%@/scetia.app.ws/ServiceTS.asmx",serverUrl];
}
- (AFNetConnection *)connectionWithAFNETName:(NSString *) AFNETName params:(NSDictionary *)params{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"param":jsonString};
    return [super connectionWithApiName:AFNETName params:dic];
}
@end
