//
//  ScannerViewController.h
//  LSScanner
//
//  Created by Lessu on 13-7-15.
//  Copyright (c) 2013年 Lessu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface QRCodeViewController : XSViewController<ZBarReaderViewDelegate>
{
	
//	IBOutlet ZBarReaderView *_reader;
	void (^_onRecognized)(NSString *data);
}

@property (strong, nonatomic) IBOutlet ZBarReaderView *reader;

@property(nonatomic,copy) void (^onRecognized)(NSString *data);
@end
