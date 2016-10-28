//
//  ViewController.m
//  af替换asi
//
//  Created by Tesiro on 16/10/21.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
@property (nonatomic, strong)LSPageController  *pageController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpPageController];
}

-(void)setUpPageController{
    NSDictionary *params = nil;
    NSString *apiname = nil;
    [self toInitPageControllerWith:&apiname params:&params];
    _pageController = [[LSPageController alloc] initWithApiName:apiname andParams:params];
    _pageController.pageName =@"CurrentPageNo";
    _pageController.stepName = @"PageSize";
    _pageController.apiClass = @"CommonAFNet";
    [_pageController UpPage];
    [self afterInitPageController:_pageController];
}

#pragma mark to Implement
- (void)toInitPageControllerWith:(NSString **) apiName params:(NSDictionary **)params{
    *apiName = AFNETMETHOD_SM_ProjectList;
    *params  = @{
                 @"Token"              : @"940972e4-93f0-4605-8128-30f9e8b301c7",
                 @"NotFinishedOnly"    : [NSNumber numberWithBool:true],
                 @"QueryStr"           : @""
                 };
//    NSAssert(false, @"please override it");
}
- (void)afterInitPageController:(LSPageController *)pageController{
    pageController.apiClass = @"CommonAFNet";
    [pageController setPageinfoAdapter:^(NSDictionary *input, BOOL *success, NSArray *__autoreleasing *list, int *totalCount, NSString *__autoreleasing *errorMessage) {
        *success = [input[kAFNETConnectionStandartSuccessKey] boolValue];
        if (success) {
            *list = input[kAFNETConnectionStandartDataKey] [@"ListContent"];
            *totalCount = [input[kAFNETConnectionStandartDataKey][@"PageCount"] intValue];
            
        }else{
            *errorMessage = input[kAFNETConnectionStandartMessageKey];
        }
    }];
}

///在viewcontroller中请求网络数据
-(void)request1{
//    [self setResponseFormat: ^(NSString *input,NSString **output){
//        NSString *responseString = input;
//        responseString = [responseString stringByMatching:@">\\{.+\\}</"];
//        responseString = [responseString stringByReplacingOccurrencesOfString:@">{" withString:@"{" ];
//        responseString = [responseString stringByReplacingOccurrencesOfString:@"}</" withString:@"}" ];
//        *output = responseString;
//    }];
    
    NSString *urlString = @"http://www.scetia.com/scetia.app.ws/ServiceSM.asmx/ProjectList";
    NSDictionary *dicParamas =@{@"NotFinishedOnly":@(1),@"PageSize":@(5),@"CurrentPageNo":@(1),@"Token":@"e9383cfe-091a-47cc-83da-e54fec9aed7f"}; ;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicParamas options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"param":jsonString};
    __block typeof(self) bSelf = self;
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
//        [bSelf setResponseData:string];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//-(void)setResponseData:(NSString *)responseString{
//    if (self.responseFormat) {
//        NSString *resultString = nil;
//        
//        self.responseFormat(responseString,&resultString) ;
//        responseString = resultString;
//    }
//    
//     NSDictionary *json = apiFilterObject([responseString JSONValue]);
//    
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//id           apiFilterObject(id object){
//    if ([object isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *dictionary = object;
//        NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
//        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            resultDictionary[key] = apiFilterObject(obj);
//        }];
//        return resultDictionary;
//    }else if([object isKindOfClass:[NSArray class]]){
//        NSArray *array = object;
//        NSMutableArray *resultArray = [NSMutableArray array];
//        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [resultArray addObject:apiFilterObject(obj)];
//        }];
//        return resultArray;
//    }else if([object isKindOfClass:[NSNumber class]]){
//        return [NSString stringWithFormat:@"%@",object];
//    }else if(object == [NSNull null]){
//        return @"";
//    }else{
//        return object;
//    }
//}
