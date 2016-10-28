//
//  ViewController.m
//  simplecompare
//
//  Created by Tesiro on 16/10/24.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *params = [_apiParams mutableCopy];
    params[_stepName] = STRING_FROM_INT(_step);
    params[_pageName] = STRING_FROM_INT(_currentPage);
    _nextPageConnection = [[NSClassFromString(_apiClass) sharedInstance]connectionWithApiName:_apiName params:params];
    
    [_nextPageConnection setSuccessTarget:self selector:@selector(nextRequestDidSuccess:)];
    [_nextPageConnection setCacheSuccessTarget:self selector:@selector(nextRequestDidSuccess:)];
    
    [_nextPageConnection setOnFailed:_onNextFailedBlock];
    [_nextPageConnection setOnFinal:^{
        _isLoading = false;
    }];
    
    BOOL validatePass = true;
    if(_beforeNextPageRequestBlock){
        validatePass = _beforeNextPageRequestBlock(_nextPageConnection);
    }
    if (validatePass) {
        _isLoading = true;
        [_nextPageConnection startAsynchronous];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
