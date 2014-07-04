//
//  ViewController.m
//  creame - jpg
//
//  Created by houchanghong on 13-7-3.
//  Copyright (c) 2013年 houchanghong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSData *mData;
    UIImageView *imgView;
}

@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    //读取沙盒中的内容
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSData* data = [defaults objectForKey:@"aaaaaa"];
    
    //创建并初始化imgView
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    imgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imgView];
    
    //将沙盒中的内容显示到屏幕上
   // imgView.image = [UIImage imageWithData:data];
    
    //创建并初始化开始按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(200, 75, 70, 37);
    [button setTitle:@"start" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(setupCaptureSession) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

#pragma mark - target action
//初始化AVCaptureSession，添加输入，输出源
//创建并且配置获取Session并且开始它运行
-(void) setupCaptureSession
{
    NSError *error = nil;
    //创建session
    AVCaptureSession *session = [[[AVCaptureSession alloc]init]autorelease];
    
    //可以配置session以产生解析度较低的视频帧
    //选择的设备指定为中等质量
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    //找到一个合适的AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认使用后置摄像头，可改成前置摄像头
    
    //用device对象创建一个设备对象input，并将其添加到session
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (!input) {
        NSLog(@"%@",error);
    }
    [session addInput:input];
    
    // 创建一个VideoDataOutput对象，将其添加到session
    AVCaptureVideoDataOutput *outPut = [[[AVCaptureVideoDataOutput alloc]init]autorelease];
    [session addOutput:outPut];
    
    outPut.alwaysDiscardsLateVideoFrames = YES;
    // 配置output对象
    dispatch_queue_t queue = dispatch_queue_create("myQueue",NULL);
    //设置抽样缓存委托和将应用回调的队列
    [outPut setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);

    // 指定像素格式.  output.videoSettings，这里可以配置输出数据的一些配置，比如宽高和视频的格式
    outPut.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA],kCVPixelBufferPixelFormatTypeKey,[NSNumber numberWithInt:320],(id)kCVPixelBufferWidthKey,[NSNumber numberWithInt:240],(id)kCVPixelBufferHeightKey, nil];
    
    // 启动session以启动数据流
    [session startRunning];
    
        
    AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preLayer.frame = CGRectMake(0, 200, 320, 368);
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:preLayer];
    
}

#pragma mark - delegate
//使用这个委托方法获取帧
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
   UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
   mData = UIImageJPEGRepresentation(image, 0.5);//这里的0.5代表生成的图片质量
    
    //保存到本地沙盒中
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:mData forKey:@"aaaaaa"];
//    [defaults synchronize];
    
    //将所摄二进制视频转换成图片显示到屏幕上
    UIImage *img = [UIImage imageWithData:mData scale:0.1f];
    imgView.image = img ;

}

// 通过抽样缓存数据创建一个UIImage对象
-(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (!colorSpace) {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
     // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
     // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
     // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
     // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:0.2f orientation:UIImageOrientationRight];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    return image;
    
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
