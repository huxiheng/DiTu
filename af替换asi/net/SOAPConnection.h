//
//  SOAPConnection.h
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "AFNetConnection.h"

@interface SOAPConnection : AFNetConnection
@property(nonatomic,retain) NSString *soapActionUrl;
@property(nonatomic,retain) NSString *soapAction;

@end
