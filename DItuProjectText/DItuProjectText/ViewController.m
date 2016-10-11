//
//  ViewController.m
//  DItuProjectText
//
//  Created by Tesiro on 16/10/11.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

#import "ViewController.h"
#import "TitleButton.h"
#import "PopoverViewController.h"
#import "PopoverAnimator.h"

@interface ViewController ()
@property (nonatomic, strong)TitleButton    *titleBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleBtn = [TitleButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.frame = CGRectMake(0, 0, 200, 100);
    [_titleBtn setTitle:@"coderWhy" forState:UIControlStateNormal];
//    [_titleBtn setBackgroundColor:[UIColor redColor]];
    [_titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_titleBtn];
    popoverAnimator = [[PopoverAnimator alloc] init];
}

-(void)titleBtnClick:(TitleButton*)btn{
    btn.selected = !btn.selected;
    //创建弹出的控制器
    PopoverViewController *popoverVC = [[PopoverViewController alloc] init];
    
    //设置转场代理
    popoverVC.transitioningDelegate = popoverAnimator;
    //设置控制器的modal样式
    popoverVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popoverVC animated:YES completion:nil];
}


@end
