//
//  ScannerViewController.m
//  LSScanner
//
//  Created by Lessu on 13-7-15.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ScanningView.h"
#import <AVFoundation/AVFoundation.h>
SystemSoundID soundID;
@interface QRCodeViewController ()

@property (nonatomic, strong)ScanningView *scanningView;
@property (nonatomic, strong)NSTimer      *timer;
@property    int num;
@property    BOOL upOrdown;

@end

@implementation QRCodeViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setData {
    self.titleForNav = @"二维码扫描";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	_reader.readerDelegate = self;
	_reader.torchMode = 0;
	
//	NSURL *filePath   = [[NSBundle mainBundle] URLForResource:@"tone_start" withExtension: @"wav"];
//	AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);

    self.scanningView = [[ScanningView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.view addSubview:self.scanningView];
    [self.view bringSubviewToFront:self.scanningView];
    [self.scanningView hiddenSubviews:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isCameraReady:) name:AVCaptureSessionDidStartRunningNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[self.view viewWithTag:1001] removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self.view viewWithTag:1001] removeFromSuperview];
}

- (void) viewDidAppear: (BOOL) animated
{
    // run the reader when the view is visible
    [_reader start];
    
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [super viewWillDisappear:animated];
    [_reader stop];
    [self.timer invalidate];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, DeviceWidth, DeviceHeight)];
    imageView.image = [UIImage imageWithScreenContents:self.navigationController.view];
    imageView.tag = 1001;
    imageView.userInteractionEnabled =YES;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	_reader.readerDelegate = nil;
    
	
	self.onRecognized = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void) readerView: (ZBarReaderView*) view didReadSymbols: (ZBarSymbolSet*) syms fromImage: (UIImage*) img{
//	AudioServicesPlaySystemSound(soundID);
	
    for(ZBarSymbol *sym in syms) {
		if(_onRecognized) _onRecognized(sym.data);
        [self.timer invalidate];
		break;
    }
}

- (void)isCameraReady:(NSNotification *)noti {
    [self.scanningView hiddenSubviews:NO];
}

//绿线上下移动
-(void)animation1
{
    if (self.upOrdown == NO) {
        self.num ++;
        self.scanningView.lineImage.frame = CGRectMake(kscaleIphone5DeviceLength(50), kscaleIphone5DeviceLength(90) +2*self.num, DeviceWidth- kscaleIphone5DeviceLength(100), 2);
        if (DeviceHeight<500) {
            if (2*self.num >=198 ) {
                self.upOrdown = YES;
            }
        }else{
            if (2*self.num >=(DeviceWidth- kscaleIphone5DeviceLength(100)) ) {
                self.upOrdown = YES;
            }
        }
    }
    else {
        self.num --;
        self.scanningView.lineImage.frame = CGRectMake(kscaleIphone5DeviceLength(50), kscaleIphone5DeviceLength(90) +2*self.num, DeviceWidth- kscaleIphone5DeviceLength(100), 2);
        if (self.num <= 0) {
            self.upOrdown = NO;
        }
    }
}
@end
