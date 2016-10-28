//
//  AFNetConnection+synthesisGetUrl.h
//  af替换asi
//
//  Created by Tesiro on 16/10/23.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNetConnection.h"

@interface AFNetConnection (synthesisGetUrl)
+ (NSString *)urlString:(NSString *)urlString withParams:(NSDictionary *)params;
@end
