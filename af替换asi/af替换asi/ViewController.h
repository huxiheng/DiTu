//
//  ViewController.h
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPageController.h"


@interface ViewController : UIViewController
@property(nonatomic,copy) void (^responseFormat)  (NSString *input,NSString **output);
@property(nonatomic,copy) void (^preproccess)     (NSDictionary *input,BOOL *success,id* data,NSString **message);
- (void)toInitPageControllerWith:(NSString **) apiName params:(NSDictionary **)params;
- (void)afterInitPageController:(LSPageController *)pageController;

@end

