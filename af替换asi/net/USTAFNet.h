//
//  USTAFNet.h
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFNet.h"
#import "NSObject+SBJSON.h"
#define AFNETMETHOD_UST_AuditedList       @"AFNETMETHOD_UST_AuditedList"
#define AFNETMETHOD_UST_ExamedList        @"AFNETMETHOD_UST_ExamedList"
#define AFNETMETHOD_UST_ExamList          @"AFNETMETHOD_UST_ExamList"
#define AFNETMETHOD_UST_AuditList         @"AFNETMETHOD_UST_AuditList"
#define AFNETMETHOD_UST_ExamList          @"AFNETMETHOD_UST_ExamList"
#define AFNETMETHOD_UST_AuditedExamedItem   @"AFNETMETHOD_UST_AuditedExamedItem"
#define AFNETMETHOD_UST_AuditedExamedKind     @"AFNETMETHOD_UST_AuditedExamedKind"
#define AFNETMETHOD_UST_Exam              @"AFNETMETHOD_UST_Exam"
#define AFNETMETHOD_UST_Audit             @"AFNETMETHOD_UST_Audit"
#define AFNETMETHOD_UST_UserLogin         @"AFNETMETHOD_UST_UserLogin"
#define AFNETMETHOD_UST_BindStart         @"AFNETMETHOD_UST_BindStart"
#define AFNETMETHOD_UST_BindEnd           @"AFNETMETHOD_UST_BindEnd"
#define AFNETMETHOD_UST_UnBind            @"AFNETMETHOD_UST_UnBind"
#define AFNETMETHOD_UST_SearchYanZhengMa  @"AFNETMETHOD_UST_SearchYanZhengMa"
#define AFNETMETHOD_UST_ChangePassWord    @"AFNETMETHOD_UST_ChangePassWord"
#define AFNETMETHOD_UST_AppAuditedList    @"AFNETMETHOD_UST_AppAuditedList"
#define  AFNETMETHOD_UST_GetUpdateVersion @"AFNETMETHOD_UST_GetUpdateVersion"
@interface USTAFNet : AFNet
SHARED_INSTANCE_INTERFACE(USTAFNet);
@end
