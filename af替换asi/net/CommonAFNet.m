//
//  CommonAFNet.m
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "CommonAFNet.h"


@implementation CommonAFNet
SHARED_INSTANCE_IMPLEMENT(CommonAFNet, _commonAFNet, );

- (instancetype)init
{
    self = [super init];
    if (self) {
        _afnetConfig = @{
                       AFNETSiteUrlKey           : @"www.scetia.com/scetia.app.ws",
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
                       
                       AFNETMETHOD_ItemItemSource       :AFNET_DEF_GET(@"/ServiceSource.asmx/ItemItemSource"),
                       AFNETMETHOD_ItemKindSource   :AFNET_DEF_GET(@"/ServiceSource.asmx/ItemKindSource"),
                       AFNETMETHOD_BHGItemSource    : AFNET_DEF_GET(@"/ServiceSource.asmx/BHGItemSource"),
                       AFNETMETHOD_UQ_ReportList    : AFNET_DEF_GET(@"/ServiceUQ.asmx/ReportList"),
                       AFNETMETHOD_UQ_ReportDetail  : AFNET_DEF_GET(@"/ServiceUQ.asmx/ProjectConsign"),
                       AFNETMETHOD_UQ_SampleList    : AFNET_DEF_GET(@"/ServiceUQ.asmx/SampleList"),
                       AFNETMETHOD_UQ_SampleDetail  : AFNET_DEF_GET(@"/ServiceUQ.asmx/SampleDetail"),
                       AFNETMETHOD_UQ_SampleExec    : AFNET_DEF_GET(@"/ServiceUQ.asmx/ExecUqSamle"),
                       AFNETMETHOD_SM_ProjectList   : AFNET_DEF_GET(@"/ServiceSM.asmx/ProjectList"),
                       AFNETMETHOD_SM_ConsignList   : AFNET_DEF_GET(@"/ServiceSM.asmx/ConsignList"),
                       AFNETMETHOD_SM_SampleList    : AFNET_DEF_GET(@"/ServiceSM.asmx/SampleList"),
                       AFNETMETHOD_SM_SampleDetail  : AFNET_DEF_GET(@"/ServiceSM.asmx/SampleDetail"),
                       AFNETMETHOD_SM_SampleDetailQR: AFNET_DEF_GET(@"/ServiceSM.asmx//SampleInfoByCode"),
                       
                       AFNETMETHOD_STAKE_List       : AFNET_DEF_GET(@"/ServiceStake.asmx/GetMapList"),
                       AFNETMETHOD_STAKE_MemberList : AFNET_DEF_GET(@"/ServiceStake.asmx/GetMemberList"),
                       
                       
                       AFNETMETHOD_STAKE_GetTaskList     : AFNET_DEF_GET(@"/ServiceStake.asmx/GetTaskList"),
                       AFNETMETHOD_STAKE_UploadTaskImage : AFNET_DEF_POST(@"/ServiceStake.asmx/UploadTaskImage"),
                       AFNETMETHOD_STAKE_GetTaskImage    : AFNET_DEF_GET(@"/ServiceStake.asmx/GetTaskImage")
                       };
    }
    return self;
}
- (void)setServerUrl:(NSString *)serverUrl{
    _afnetConfig = [_afnetConfig mutableCopy];
    ((NSMutableDictionary *)_afnetConfig)[AFNETSiteUrlKey] = [NSString stringWithFormat:@"%@/scetia.app.ws",serverUrl];
}
- (AFNetConnection *)connectionWithApiName:(NSString *) apiName params:(NSDictionary *)params{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"param":jsonString};
    return [super connectionWithApiName:apiName params:dic];
}
@end
