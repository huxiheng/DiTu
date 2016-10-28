//
//  CommonAFNet.h
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNet.h"
#import "RegexKitLite.h"
#define AFNETMETHOD_BHGItemSource     @"AFNETMETHOD_BHGItemSource"
#define AFNETMETHOD_ItemKindSource    @"AFNETMETHOD_ItemKindSource"
#define AFNETMETHOD_ItemItemSource    @"AFNETMETHOD_ItemItemSource"

#define AFNETMETHOD_UQ_ReportList     @"AFNETMETHOD_UQ_ReportList"
#define AFNETMETHOD_UQ_ReportDetail   @"AFNETMETHOD_UQ_ReportDetail"
#define AFNETMETHOD_UQ_SampleList     @"AFNETMETHOD_UQ_SampleList"
#define AFNETMETHOD_UQ_SampleDetail   @"AFNETMETHOD_UQ_SampleDetail"
#define AFNETMETHOD_UQ_ProjectReportList     @"AFNETMETHOD_UQ_ProjectReportList"
#define AFNETMETHOD_UQ_SampleExec   @"AFNETMETHOD_UQ_SampleExec"
#define AFNETMETHOD_STAKE_List            @"AFNETMETHOD_STAKE_List"
#define AFNETMETHOD_STAKE_MemberList      @"AFNETMETHOD_STAKE_MemberList"


#define AFNETMETHOD_SM_ProjectList        @"AFNETMETHOD_SM_ProjectList"
#define AFNETMETHOD_SM_ConsignList        @"AFNETMETHOD_SM_ConsignList"
#define AFNETMETHOD_SM_SampleList         @"AFNETMETHOD_SM_SampleList"
#define AFNETMETHOD_SM_SampleDetail       @"AFNETMETHOD_SM_SampleDetail"
#define AFNETMETHOD_SM_SampleDetailQR   @"AFNETMETHOD_SM_SampleDetailQR"

#define AFNETMETHOD_STAKE_GetTaskList     @"AFNETMETHOD_STAKE_GetTaskList"
#define AFNETMETHOD_STAKE_UploadTaskImage     @"AFNETMETHOD_STAKE_UploadTaskImage"
#define AFNETMETHOD_STAKE_GetTaskImage     @"AFNETMETHOD_STAKE_GetTaskImage"
@interface CommonAFNet : AFNet
SHARED_INSTANCE_INTERFACE(CommonAFNet);

@end
