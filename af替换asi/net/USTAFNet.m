//
//  USTAFNet.m
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "USTAFNet.h"
#import "RegexKitLite.h"

@implementation USTAFNet
SHARED_INSTANCE_IMPLEMENT(USTAFNet, _ustAfnet, );
- (instancetype)init
{
    self = [super init];
    if (self) {
        _afnetConfig = @{
                       AFNETSiteUrlKey           : @"www.scetia.com/scetia.app.ws/ServiceUST.asmx",
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
                       AFNETMETHOD_UST_AuditedExamedItem    : AFNET_DEF_GET(@"/Get_ItemItem"),
                       AFNETMETHOD_UST_AuditedExamedKind      : AFNET_DEF_GET(@"/Get_ItemKind"),
                       
                       AFNETMETHOD_UST_AuditedList            : AFNET_DEF_GET(@"/Get_AppAuditedList"),
                       AFNETMETHOD_UST_AuditList               : AFNET_DEF_GET(@"/Get_AuditList"),
                       AFNETMETHOD_UST_Audit                  : AFNET_DEF_GET(@"/Set_AuditList"),
                       
                       AFNETMETHOD_UST_ExamedList             : AFNET_DEF_GET(@"/Get_AppExamedList"),
                       AFNETMETHOD_UST_ExamList               : AFNET_DEF_GET(@"/Get_ExamRecordList"),
                       AFNETMETHOD_UST_Exam                   : AFNET_DEF_GET(@"/Set_ExamList"),
                       
                       AFNETMETHOD_UST_UserLogin              : AFNET_DEF_GET(@"/UserLogin"),
                       AFNETMETHOD_UST_BindStart              : AFNET_DEF_GET(@"/User_BindStart"),
                       AFNETMETHOD_UST_UnBind                :AFNET_DEF_GET(@"/User_UnBind"),
                       AFNETMETHOD_UST_SearchYanZhengMa                :AFNET_DEF_GET(@"/SearchYanZhengMa"),
                       AFNETMETHOD_UST_BindEnd                : AFNET_DEF_GET(@"/User_BindEnd"),
                       AFNETMETHOD_UST_ChangePassWord         : AFNET_DEF_GET(@"/User_ChangePassWord"),
                       AFNETMETHOD_UST_GetUpdateVersion      : AFNET_DEF_GET(@"/GetAppVersion")
                       };
    }
    return self;
}
- (void)setServerUrl:(NSString *)serverUrl{
    _afnetConfig = [_afnetConfig mutableCopy];
    ((NSMutableDictionary *)_afnetConfig)[AFNETSiteUrlKey] = [NSString stringWithFormat:@"%@/scetia.app.ws/ServiceUST.asmx",serverUrl];
}
- (AFNetConnection *)connectionWithAFNETName:(NSString *) AFNETName params:(NSDictionary *)params{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"param":jsonString};
    return [super connectionWithApiName:AFNETName params:dic];
}
@end
