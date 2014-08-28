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

@interface YKFCRootViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) UIButton *changeCameraImageBtn;
@property (nonatomic, strong) UIButton *pickImageBtn;
@property (nonatomic, strong) UIButton *photoImageBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *prevTextView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, assign) unsigned long imageWidth;
@end

@implementation YKFCRootViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blackColor];
    [self initCapture];
}
//初始化AVCaptureSession，添加输入，输出源
- (void)initCapture {
    //找到一个合适的AVCaptureDevice，这里默认使用后置摄像头，用device对象创建一个设备对象input，并将其添加到session
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                          deviceInputWithDevice:[AVCaptureDevice
                                                                 defaultDeviceWithMediaType:AVMediaTypeVideo]  error:nil];
    // 创建一个VideoDataOutput对象，将其添加到session
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc]
                                               init];
    // 配置output对象
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    //设置抽样缓存委托和将应用回调的队列
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    // 指定像素格式.videoSettings，这里可以配置输出数据的一些配置，比如宽高和视频的格式
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber
                       numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary
                                   dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    // 启动session以启动数据流
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
    [self.textView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeMode)]];
    
    // 前置摄像头icon
    self.changeCameraImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(kViewWidth - 40.0, 2.0, 35.0, 35.0)];
    [self.changeCameraImageBtn setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
    [self.changeCameraImageBtn setImage:[UIImage imageNamed:@"changeCamera-clicked"] forState:UIControlStateHighlighted];
    self.changeCameraImageBtn.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.changeCameraImageBtn];
    [self.changeCameraImageBtn addTarget:self action:@selector(changeCameraImageViewTap) forControlEvents:UIControlEventTouchUpInside];
    
    // 拍照icon
    self.pickImageBtn = [[UIButton alloc] initWithFrame:CGRectMake((kViewWidth - 66.0) / 2.0, 40.0 + self.textView.frame.size.height + 24.0, 66.0, 57.0)];
    [self.pickImageBtn setBackgroundImage:[UIImage imageNamed:@"pick"] forState:UIControlStateNormal];
    [self.pickImageBtn setBackgroundImage:[UIImage imageNamed:@"pick-clicked"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.pickImageBtn];
    [self.pickImageBtn addTarget:self action:@selector(pickImageViewTap) forControlEvents:UIControlEventTouchUpInside];
    
    // 从相册中选取icon
    self.photoImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 40.0 + self.textView.frame.size.height + 39.0, 46.0, 35.0)];
    [self.photoImageBtn setBackgroundImage:[UIImage imageNamed:@"pickFromAlbum"] forState:UIControlStateNormal];
    [self.photoImageBtn setBackgroundImage:[UIImage imageNamed:@"pickFromAlbum-clicked"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.photoImageBtn];
    [self.photoImageBtn addTarget:self action:@selector(photoImageViewTap) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *result;
    unsigned long imgWidth;
    if (CGImageGetWidth(image.CGImage) > CGImageGetHeight(image.CGImage)) {
        UIImage *image2 = [self rotateImage:image];
        result = [self transformImage:image2.CGImage];
        imgWidth = CGImageGetWidth(image2.CGImage);
    } else {
        result = [self transformImage:image.CGImage];
        imgWidth = CGImageGetWidth(image.CGImage);
    }
    
    if (self.maskView) {
        self.maskView.center = self.view.center;
        self.maskView.hidden = NO;
        self.prevTextView.text = result;
        self.prevTextView.font = [UIFont fontWithName:@"menlo" size:9.6 * kViewWidth / imgWidth];
        [self.maskView addSubview:self.prevTextView];
    } else {
        self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
        self.maskView.backgroundColor = [UIColor blackColor];
        
        self.prevTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 40.0, kViewWidth, kViewWidth * 4 / 3)];
        self.prevTextView.textColor = self.textView.textColor;
        self.prevTextView.backgroundColor = self.textView.backgroundColor;
        self.prevTextView.delegate = self;
        self.prevTextView.editable = NO;//不可编辑
        self.prevTextView.scrollEnabled = NO;//不可滚动
        [self.prevTextView setTextAlignment:NSTextAlignmentCenter];
        self.prevTextView.text = result;
        self.prevTextView.font = [UIFont fontWithName:@"menlo" size:9.6 * kViewWidth / imgWidth];
        [self.maskView addSubview:self.prevTextView];
        
        UIButton *yesBtn = [[UIButton alloc] initWithFrame:CGRectMake(189.0, 40.0 + self.textView.frame.size.height + 27.0, 48.0, 49.0)];
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes"] forState:UIControlStateNormal];
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes-clicked"] forState:UIControlStateHighlighted];
        [self.maskView addSubview:yesBtn];
        [yesBtn addTarget:self action:@selector(yesTap) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *noBtn = [[UIButton alloc] initWithFrame:CGRectMake(82.0, 40.0 + self.textView.frame.size.height + 27.0, 48.0, 49.0)];
        [noBtn setBackgroundImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
        [noBtn setBackgroundImage:[UIImage imageNamed:@"no-clicked"] forState:UIControlStateHighlighted];
        [self.maskView addSubview:noBtn];
        [noBtn addTarget:self action:@selector(noTap) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.maskView];
    }
    
}

#pragma mark - TapEvent
- (void)changeMode
{
    if ([self.textView.backgroundColor isEqual:[UIColor whiteColor]]) {
        self.textView.backgroundColor = [UIColor blackColor];
        self.textView.textColor = [UIColor greenColor];
    } else {
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.textColor = [UIColor blackColor];
    }
}

- (void)noTap
{
    [UIView animateWithDuration: 0.3
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.maskView.center = CGPointMake(self.maskView.center.x, self.maskView.center.y + self.maskView.frame.size.height);
                     } completion:^(BOOL finished) {
                         self.maskView.hidden = YES;
                     }];
    
}

- (void)yesTap
{
    //创建一个layer用来承载UITextView
    if (!self.imageLayer) {
        self.imageLayer = [[CALayer alloc] init];
        self.imageLayer.frame = self.prevTextView.bounds;
    }
    self.imageLayer = self.prevTextView.layer;
    

    //用renderInContext方法，把这个layer转成图片
    UIGraphicsBeginImageContext(self.imageLayer.bounds.size);
    [self.imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image2, nil, nil, nil);
    
    [UIView animateWithDuration: 0.3
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.maskView.center = CGPointMake(self.maskView.center.x, self.maskView.center.y + self.maskView.frame.size.height);
                     } completion:^(BOOL finished) {
                         self.maskView.hidden = YES;
                     }];
}

- (void)photoImageViewTap
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

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

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
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
    UIView *flashView = [[UIView alloc] initWithFrame:self.textView.frame];
    
    [flashView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:flashView];
    
    [UIView animateWithDuration:0.4f
                     animations:^{
                         [flashView setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                     }
     ];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewWidth * 4 / 3)];
    textView.textColor = self.textView.textColor;
    textView.backgroundColor = self.textView.backgroundColor;
    textView.delegate = self;
    [textView setTextAlignment:NSTextAlignmentCenter];
    textView.text = self.textView.text;
    textView.font = [UIFont fontWithName:@"menlo" size:9.6 * kViewWidth / self.imageWidth];

    //创建一个layer用来承载UITextView
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = textView.bounds;
    [layer addSublayer:textView.layer];
    
    //用renderInContext方法，把这个layer转成图片
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(image2, nil, nil, nil);
    });
}

#pragma mark - AVCaptureSession delegate
// 采集帧
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // 用Core Video图像缓存对象来得到其中的图片采集部分，CVImageBufferRef是专门用于保存视频的图片帧缓存的数据结构
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定imageBuffer的基地址，使imageBuffer的内存空间不再变动。对CVImageBufferRef的操作都需要先lock
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    // 得到imageBuffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到imageBuffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 得到imageBuffer的基地址
    void *srcBuff = CVPixelBufferGetBaseAddress(imageBuffer);

    // 由于ios默认保存的数据是横屏的，所以需要转下角度。rotationConstant=3表示转270度。
    uint8_t rotationConstant = 3;
    
    unsigned char *outBuff = (unsigned char*)malloc(bytesPerRow * height * sizeof(unsigned char));
    
    vImage_Buffer ibuff = { srcBuff, height, width, bytesPerRow};
    vImage_Buffer ubuff = { outBuff, width, height, 4 * height * sizeof(unsigned char)};
    Pixel_8888 bgColor = { (uint8_t)255,(uint8_t)255, (uint8_t)255,(uint8_t)255 };
    vImage_Error err= vImageRotate90_ARGB8888 (&ibuff, &ubuff, rotationConstant, bgColor, 0);
    if (err != kvImageNoError) NSLog(@"%ld", err);
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef newContext = CGBitmapContextCreate(ubuff.data,
                                             ubuff.width,
                                             ubuff.height,
                                             8,
                                             ubuff.rowBytes,
                                             colorSpace,
                                             kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    NSString *result = [self transformImage:newImage];
    [self.textView performSelectorOnMainThread:@selector(setFont:) withObject:[UIFont fontWithName:@"menlo" size:9.6 * kViewWidth / self.imageWidth] waitUntilDone:YES];
    [self.textView performSelectorOnMainThread:@selector(setText:) withObject:result waitUntilDone:YES];
    
    free(outBuff);
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(newImage);
    // 解锁imageBuffer
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

- (UIImage *)rotateImage:(UIImage *)aImage

{
    
    CGImageRef imgRef = aImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    
    
    CGFloat scaleRatio = 1;
    
    
    
    CGFloat boundHeight;
    
    UIImageOrientation orient = aImage.imageOrientation;
    
    switch(orient)
    
    {
            
        case UIImageOrientationUp: //EXIF = 1
            
            transform = CGAffineTransformIdentity;
            
            break;
            
            
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
            break;
            
            
            
        case UIImageOrientationDown: //EXIF = 3
            
            transform = CGAffineTransformMakeTranslation(width, height);
            
            transform = CGAffineTransformRotate(transform, M_PI);
            
            break;
            
            
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            
            transform = CGAffineTransformMakeTranslation(0.0, height);
            
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            
            break;
            
            
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(height, width);
            
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationLeft: //EXIF = 6
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(0.0, width);
            
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
            
            
        case UIImageOrientationRight: //EXIF = 8
            
            boundHeight = bounds.size.height;
            
            bounds.size.height = bounds.size.width;
            
            bounds.size.width = boundHeight;
            
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
            
            
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    
    
    UIGraphicsBeginImageContext(bounds.size);
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        
        CGContextTranslateCTM(context, -height, 0);
        
    }
    
    else {
        
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        
        CGContextTranslateCTM(context, 0, -height);
        
    }
    
    
    
    CGContextConcatCTM(context, transform);
    
    
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return imageCopy;
    
}

// 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
    
}

// 隐藏statusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
