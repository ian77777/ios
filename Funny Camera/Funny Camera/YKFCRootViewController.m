//
//  YKFCRootViewController.m
//  Funny Camera
//
//  Created by yukai44444 on 14-7-1.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YKFCRootViewController.h"

@interface YKFCRootViewController ()

@end

@implementation YKFCRootViewController

- (void)viewDidLoad {
    [self initCapture];
}

- (void)initCapture {
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                          deviceInputWithDevice:[AVCaptureDevice
                                                                 defaultDeviceWithMediaType:AVMediaTypeVideo]  error:nil];
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]
                                               init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    //captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber
                       numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary
                                   dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    [self.captureSession startRunning];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0, 10.0, self.view.frame.size.width - 10.0, (self.view.frame.size.width - 10.0) * 853.0 / 640)];
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.font = [UIFont fontWithName:@"menlo" size:9.0];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview:self.textView];
    
    self.prevLayer = [AVCaptureVideoPreviewLayer
                      layerWithSession: self.captureSession];
    self.prevLayer.frame = CGRectMake(100, 0, 100, 100);
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer: self.prevLayer];

}

#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress,
                                                    width, height, 8, bytesPerRow, colorSpace,
                                                    kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    

    
    
    NSString *result = [self transformImage:newImage];
    
    [self.textView performSelectorOnMainThread:@selector(setText:) withObject:result waitUntilDone:YES];
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(newImage);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0); 
    
}

- (NSString *)transformImage:(CGImageRef)img
{
    //创建数据源提供者
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    //取出图片像素数据
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    unsigned long imgWidth = CGImageGetWidth(img);
    unsigned long imgHeight = CGImageGetHeight(img);
    
    //取一个指向UInt8格式数据的指针
    const UInt8* data = CFDataGetBytePtr(inBitmapData);
    NSMutableString *result = [[NSMutableString alloc] init];
    //垂直方向每隔12像素取一个像素，可以不是12
    for (int h = 0; h < imgHeight; h+= 12) {
        NSMutableString *chardata = [[NSMutableString alloc] init];
        //水平方向每隔6像素取一个像素，因为字符的宽是高的一半，当然也可以不是6
        for (int w = 0; w < imgWidth; w+= 6) {
            //取出了一个像素里的RGBA值
            int index = (int)(w + imgWidth * h) * 4;
            UInt8 r = data[index + 0];
            UInt8 g = data[index + 1];
            UInt8 b = data[index + 2];
            //按照灰度值计算公式得到这个像素点的灰度，并转成一个字符
            double gray = [self getGray:r g:g b:b];
            NSString *text = [self toText:gray];
            [chardata appendString:text];
        }
        [chardata appendString:@"\n"];
        [result appendString:chardata];
    }
    
    CFRelease(inBitmapData);
    return result;
}

- (NSString *)toText:(double)g
{
    if (g <= 30) {
        return @"#";
    } else if (g > 30 && g <= 60) {
        return @"&";
    } else if (g > 60 && g <= 120) {
        return @"$";
    } else if (g > 120 && g <= 150) {
        return @"*";
    } else if (g > 150 && g <= 180) {
        return @"o";
    } else if (g > 180 && g <= 210) {
        return @"!";
    } else if (g > 210 && g <= 240) {
        return @";";
    } else {
        return @" ";
    }
}

- (double)getGray:(UInt8)r g:(UInt8)g b:(UInt8)b
{
    return 0.299 * r + 0.578 * g + 0.114 * b;
}

- (void)dealloc {
    self.textView.delegate = nil;
}

@end
