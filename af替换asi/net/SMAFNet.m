//
//  SMAFNet.m
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "SMAFNet.h"
#import "RegexKitLite.h"
@implementation SMAFNet
SHARED_INSTANCE_IMPLEMENT(SMAFNet, _smAfnet, );
- (instancetype)init
{
    self = [super init];
    if (self) {
        _afnetConfig = @{
                       AFNETSiteUrlKey           : @"www.scetia.com/scetia.app.ws/ServiceSM.asmx",
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
                       AFNETMETHOD_SM_ConsignList                 : AFNET_DEF_GET(@"/ConsignList"),
                       AFNETMETHOD_SM_ProjectList                 : AFNET_DEF_GET(@"/ProjectList"),
                       AFNETMETHOD_SM_SampleDetail                : AFNET_DEF_GET(@"/SampleDetail"),
                       AFNETMETHOD_SM_SampleInfoByCode            : AFNET_DEF_GET(@"/SampleInfoByCode"),
                       AFNETMETHOD_SM_SampleList                  : AFNET_DEF_GET(@"/SampleList")
                       };
    }
    return self;
}
- (void)setServerUrl:(NSString *)serverUrl{
    _afnetConfig = [_afnetConfig mutableCopy];
    ((NSMutableDictionary *)_afnetConfig)[AFNETSiteUrlKey] = [NSString stringWithFormat:@"%@/scetia.app.ws/ServiceSM.asmx",serverUrl];
}
- (AFNetConnection *)connectionWithAFNETName:(NSString *) AFNETName params:(NSDictionary *)params{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"param":jsonString};
    return [super connectionWithApiName:AFNETName params:dic];
}
@end
