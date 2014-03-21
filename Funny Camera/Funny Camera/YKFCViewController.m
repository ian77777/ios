//
//  YKFCViewController.m
//  Funny Camera
//
//  Created by yukai44444 on 14-3-20.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YKFCViewController.h"
#import "Accelerate/Accelerate.h"

@interface YKFCViewController ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *button;

@end

@implementation YKFCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(150, 60, 100, 50)];
    [self.button setTitle:@"请选择图片" forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor redColor]];
    [self.button addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.button];

}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self transformImage:image];
    
    
}

- (void)transformImage:(UIImage *)image
{
    
    
    CGSize size = CGSizeMake(1280, 1280 * image.size.height / image.size.width);
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 100, 100 * scaledImage.size.height / scaledImage.size.width)];
    [self.imageView setImage:scaledImage];
    [self.view addSubview:self.imageView];
    
    
    CGImageRef img = scaledImage.CGImage;
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
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, 350)];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont fontWithName:@"menlo" size:9.0 * self.view.frame.size.width / imgWidth];
    textView.backgroundColor = [UIColor whiteColor];
    textView.delegate = self;
    textView.text = result;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview:textView];
    
    NSString *cacheFile = [self validFilePath];
    NSData *cacheData =  [result dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:cacheFile contents:cacheData attributes:nil];
    
    UITextView *textView2 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350)];
    textView2.textColor = [UIColor blackColor];
    textView2.font = [UIFont fontWithName:@"menlo" size:9.0 * self.view.frame.size.width / imgWidth];
    textView2.backgroundColor = [UIColor whiteColor];
    textView2.delegate = self;
    textView2.text = result;
    textView2.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    //创建一个layer用来承载UITextView
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 350);
    [layer addSublayer:textView2.layer];
    
    //用renderInContext方法，把这个layer转成图片
    UIGraphicsBeginImageContext(layer.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image2, nil, nil, nil);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储照片成功"
                                                    message:@"您已将照片存储于图片库中，打开照片程序即可查看。"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (NSString *)cacheFolderPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheFilePath = [documentPath stringByAppendingPathComponent:@"folder"];
    return cacheFilePath;
}

- (NSString *)validFilePath{
    NSString *cacheFilePath = [self cacheFolderPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:cacheFilePath withIntermediateDirectories:YES attributes:Nil error:nil];
    cacheFilePath = [cacheFilePath stringByAppendingPathComponent:@"txt"];
    return cacheFilePath;
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}
- (void)chooseImage {
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}
@end
