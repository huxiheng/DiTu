//
//  SMAFNet.h
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNet.h"
#define AFNETMETHOD_SM_ConsignList        @"AFNETMETHOD_SM_ConsignList"
#define AFNETMETHOD_SM_ProjectList        @"AFNETMETHOD_SM_ProjectList"
#define AFNETMETHOD_SM_SampleDetail       @"AFNETMETHOD_SM_SampleDetail"
#define AFNETMETHOD_SM_SampleInfoByCode   @"AFNETMETHOD_SM_SampleInfoByCode"
#define AFNETMETHOD_SM_SampleList         @"AFNETMETHOD_SM_SampleList"
@interface SMAFNet : AFNet
SHARED_INSTANCE_INTERFACE(SMAFNet);
@end
