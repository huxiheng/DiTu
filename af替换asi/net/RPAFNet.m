//
//  RPAFNet.m
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "RPAFNet.h"
#import "RegexKitLite.h"
@implementation RPAFNet
SHARED_INSTANCE_IMPLEMENT(RPAFNet  ,_rpAfNet,);
- (instancetype)init
{
    self = [super init];
    if (self) {
        _afnetConfig = @{
                       AFNETSiteUrlKey           : @"www.scetia.com/scetia.app.ws/ServiceRP.asmx",
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
                       AFNETMETHOD_RP_VERIFY_DETAIL_SAMPLE      : AFNET_DEF_GET(@"/RecordPreviewList"),
                       AFNETMETHOD_RP_APPLY_DETAIL_REPORT       : AFNET_DEF_GET(@"/ReportPreviewList"),
                       };
    }
    return self;
}
- (void)setServerUrl:(NSString *)serverUrl{
    _afnetConfig = [_afnetConfig mutableCopy];
    ((NSMutableDictionary *)_afnetConfig)[AFNETSiteUrlKey] = [NSString stringWithFormat:@"%@/scetia.app.ws/ServiceRP.asmx",serverUrl];
}
- (AFNetConnection *)connectionWithAFNETName:(NSString *) AFNETName params:(NSDictionary *)params{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"param":jsonString};
    return [super connectionWithApiName:AFNETName params:dic];
}
@end
