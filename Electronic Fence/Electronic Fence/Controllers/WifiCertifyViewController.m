//
//  WifiCertifyViewController.m
//  Wifi
//
//  Created by yang.zy on 14-2-26.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "WifiCertifyViewController.h"
#import "WifiCertifyService.h"


@interface WifiCertifyViewController ()

@end

@implementation WifiCertifyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationBarProperty];

    _certifyView = [[WifiCertifyView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_certifyView];
    
    [self requestCertify];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithParam:(NSDictionary *)param
{
    self = [super init];
    if (self) {
        _detailInfos = param;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCertify) name:@"kReConnWifiCertify" object:nil];
    }
    return self;
}

- (void)requestCertify
{
    [self performSelector:@selector(wifiCertify) withObject:self afterDelay:2];
}

- (void)wifiCertify
{
    [[WifiCertifyService sharedInstance] requestCertificationWithParams:_detailInfos];
}


- (void)navigationBarProperty
{
    self.navigationItem.title = @"支付宝";
    self.navigationItem.leftBarButtonItem =
    [APBarButtonItem backBarButtonItemWithTitle:nil target:self action:@selector(back) ];
}



@end
