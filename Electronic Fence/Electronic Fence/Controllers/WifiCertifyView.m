//
//  WifiCertifyView.m
//  APNFDPanel
//
//  Created by yang.zy on 14-2-27.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "WifiCertifyView.h"
#import "SITEPROBEAuthProcessorFacade.h"
#import "SITEPROBEAuthProcessorReq.h"
#import "SITEPROBEAuthProcessorRsp.h"
#import "SITEPROBEAuthVerifyReq.h"
#import "SITEPROBEAuthVerifyRsp.h"
#import "WifiFailureView.h"


static const CGFloat StatusBarHeight = 20;

#define kNumberOfImages 5
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@implementation WifiCertifyView



#pragma mark - 界面设置

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        CGFloat firstSubViewY = 0.0f;
        CGFloat height = frame.size.height;
        if ( SYSTEMVERSION >= 7.0) {
            firstSubViewY = StatusBarHeight ;
            height -= firstSubViewY;
        }else{
            height += 65 ;
        }
        CGRect contentFrame = CGRectMake(0, firstSubViewY, frame.size.width , height);
        [self initContentView:contentFrame];
        [self initWifiStatusImageView];
        [self initPromptLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiCertifySuccess:) name:@"kWifiCertifySuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiCertifyFailure:) name:@"kWifiCertifyFailure" object:nil];
        
    }
    return  self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kWifiCertifySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kWifiCertifyFailure" object:nil];
    
}


- (void)initWifiStatusImageView
{
    self.wifiStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-145)/2, (self.frame.size.height-200)/2, 145, 105)];
    NSMutableArray *imageView = [[NSMutableArray alloc] init];
    for(NSUInteger i = 1; i <= kNumberOfImages; i++) {
        UIImage *anImage = [UIImage imageNamed:[NSString stringWithFormat:@"wifi-status%d", i]];
        if(anImage) {
            [imageView addObject:anImage];
        }
    }
    self.wifiStatusImageView.animationImages = imageView;
    self.wifiStatusImageView.animationDuration = 1.0;
    [self addSubview:self.wifiStatusImageView];
    [self.wifiStatusImageView startAnimating];
}


- (void)initPromptLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, self.wifiStatusImageView.frame.origin.y+self.wifiStatusImageView.frame.size.height+40, self.frame.size.width, 50)];
    self.titleLabel.text = @"WI-FI连接中";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    // 字体颜色 #999999
    self.titleLabel.textColor = [UIColor colorWithRed:99.f/255.f green:99.f/255.f blue:99.f/255.f alpha:1];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.contentMode = UIViewContentModeTop;
    [self addSubview:self.titleLabel];
    
}



- (void)initContentView:(CGRect)frame
{
    self.contentView = [[UIView alloc] initWithFrame:frame];
    // 背景颜色 #efeff4
    self.contentView.backgroundColor = [UIColor  colorWithRed:239.f/255.f green:239.f/255.f blue:244.f/255.f alpha:1];
    [self addSubview:self.contentView];
}


#pragma mark - 认证成功、失败处理

- (void)wifiCertifySuccess:(NSNotification *)notification
{
    NSString *targetUrl = [notification.userInfo objectForKey:@"targetUrl"];
    NSLog(@"wifi认证成功,跳转地址:%@",targetUrl);
    [self.wifiStatusImageView stopAnimating];
    [self.wifiStatusImageView setImage:[UIImage imageNamed:@"wifi-status5"]];
    [self.titleLabel setText:@"WI-FI连接成功"];
    [self performSelector:@selector(goTargetUrl:) withObject:targetUrl afterDelay:2];
}

- (void)wifiCertifyFailure:(NSNotification *)notification
{
    
    NSString *otherNetworkUrl = [notification.userInfo objectForKey:@"otherNetworkUrl"];
    NSLog(@"wifi认证失败,选择其他上网地址:%@",otherNetworkUrl);
    WifiFailureView *failureView = [[WifiFailureView alloc]  initWithFrame:self.bounds otherNetworkUrl:otherNetworkUrl];
    [self addSubview:failureView];
}

- (void)goTargetUrl:(NSString *)successUrl
{
    NSArray *array= [[[NSURL URLWithString:successUrl] query] componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:array.count];
    for (int i=0; i<array.count; i++) {
        NSString *keyValueString =  (NSString *) [array objectAtIndex:i];
        NSString *key = [keyValueString substringToIndex:[keyValueString rangeOfString:@"="].location];
        NSString *value =[ keyValueString substringFromIndex:[keyValueString rangeOfString:@"="].location+1] ;
        [dictionary setValue:value forKey:key];
    }
    [DTContextGet() startApplication:[dictionary objectForKey:@"appId"] params:dictionary animated:YES];
    
    
}



@end
