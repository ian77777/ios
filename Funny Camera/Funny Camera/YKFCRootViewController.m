//
//  YKFCRootViewController.m
//  Funny Camera
//
//  Created by yukai44444 on 14-7-1.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YKFCRootViewController.h"
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

#define kViewWidth (self.view.frame.size.width)
#define kViewHeight (self.view.window.frame.size.height)

@interface YKFCRootViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,UITextViewDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) UIImageView *changeCameraImageView;
@property (nonatomic, strong) UIImageView *pickImageView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) unsigned long imageWidth;
@end

@implementation YKFCRootViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blackColor];
    [self initCapture];
}

- (void)initCapture {
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                          deviceInputWithDevice:[AVCaptureDevice
                                                                 defaultDeviceWithMediaType:AVMediaTypeVideo]  error:nil];
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]
                                               init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
//    captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
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
    
    // 文字流区域
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 40.0, kViewWidth, kViewWidth * 4 / 3)];
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.editable = NO;//不可编辑
    self.textView.scrollEnabled = NO;//不可滚动
    [self.textView setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.textView];
    
    // 前置摄像头icon
    self.changeCameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kViewWidth - 38.0, 9.0, 28.0, 21.0)];
    self.changeCameraImageView.image = [UIImage imageNamed:@"changeCamera"];
    [self.view addSubview:self.changeCameraImageView];
    self.changeCameraImageView.userInteractionEnabled = YES;
    [self.changeCameraImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCameraImageViewTap)]];
    
    // 拍照icon
    self.pickImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kViewWidth - 68.0) / 2.0, 40.0 + self.textView.frame.size.height + 20.0, 68.0, 68.0)];
    self.pickImageView.image = [UIImage imageNamed:@"pick"];
    [self.view addSubview:self.pickImageView];
    self.pickImageView.userInteractionEnabled = YES;
    [self.pickImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickImageViewTap)]];
}

#pragma mark - TapEvent
- (void)changeCameraImageViewTap
{
    //Change camera source
    if(_captureSession)
    {
        //Indicate that some changes will be made to the session
        [_captureSession beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [_captureSession.inputs objectAtIndex:0];
        [_captureSession removeInput:currentCameraInput];
        
        //Get new input
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
        [_captureSession addInput:newVideoInput];
        
        //Commit all the configuration changes at once
        [_captureSession commitConfiguration];
    }
}

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

- (void)pickImageViewTap
{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewWidth * 4 / 3)];
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor whiteColor];
    textView.delegate = self;
    [textView setTextAlignment:NSTextAlignmentCenter];
    textView.text = self.textView.text;
    
    //创建一个layer用来承载UITextView
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = textView.bounds;
    [layer addSublayer:self.textView.layer];
    
    //用renderInContext方法，把这个layer转成图片
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image2, nil, nil, nil);
}

#pragma mark - AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    

    void *srcBuff = CVPixelBufferGetBaseAddress(imageBuffer);

    uint8_t rotationConstant = 3;
    
    unsigned char *outBuff = (unsigned char*)malloc(bytesPerRow * height * sizeof(unsigned char));
    
    vImage_Buffer ibuff = { srcBuff, height, width, bytesPerRow};
    vImage_Buffer ubuff = { outBuff, width, height, 4 * height * sizeof(unsigned char)};
    Pixel_8888 backColour = { (uint8_t)255,(uint8_t)255, (uint8_t)255,(uint8_t)255 };
    vImage_Error err= vImageRotate90_ARGB8888 (&ibuff, &ubuff, rotationConstant, backColour, 0);
    if (err != kvImageNoError) NSLog(@"%ld", err);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(ubuff.data,
                                             ubuff.width,
                                             ubuff.height,
                                             8,
                                             ubuff.rowBytes,
                                             colorSpace,
                                             kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    NSString *result = [self transformImage:newImage];
    [self.textView performSelectorOnMainThread:@selector(setFont:) withObject:[UIFont fontWithName:@"menlo" size:9.6 * self.view.frame.size.width / self.imageWidth] waitUntilDone:YES];
    [self.textView performSelectorOnMainThread:@selector(setText:) withObject:result waitUntilDone:YES];
    
    free(outBuff);
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
    self.imageWidth = imgWidth;
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
