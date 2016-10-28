//
//  TSAFNet.h
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNet.h"
#import "NSObject+SBJSON.h"
#define AFNETMETHOD_TS_TODAY @"AFNETMETHOD_TS_TODAY"
#define AFNETMETHOD_TS_TODAY_MANAGE_UNIT @"AFNETMETHOD_TS_TODAY_MANAGE_UNIT"
#define AFNETMETHOD_TS_TODAY_MANAGE_UNIT_DETAIL @"AFNETMETHOD_TS_TODAY_MANAGE_UNIT_DETAIL"
@interface TSAFNet : AFNet
SHARED_INSTANCE_INTERFACE(TSAFNet);

@end
