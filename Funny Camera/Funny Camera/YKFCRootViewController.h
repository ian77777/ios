//
//  YKFCRootViewController.h
//  Funny Camera
//
//  Created by yukai44444 on 14-7-1.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface YKFCRootViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,UITextViewDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) unsigned long imageWidth;
@end
