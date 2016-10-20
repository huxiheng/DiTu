//
//  XSShareObject.h
//  XieshiPrivate
//
//  Created by Tesiro on 16/7/18.
//  Copyright © 2016年 Lessu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSShareObject : NSObject
/**
 *  创建当前类的一个单例
 *  @return
 */
+ (instancetype)sharedInstance;

///判断手机号码是否合法
+(BOOL) isValidateMobile:(NSString *)mobile;

///去除手机号+86
+(NSString *)formatPhoneNum:(NSString *)phone;


@end
