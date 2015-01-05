//
//  YBYTRootViewController.m
//  Test
//
//  Created by yukai44444 on 14-7-8.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YBYTRootViewController.h"
#import "YBYTSecondViewController.h"
#import <H5Service/H5Service.h>

@interface YBYTRootViewController () <H5ServiceDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation YBYTRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    H5PSDController *vc = [[H5Service sharedService] createWebViewController:@{@"url":@"http://ux.alipay-inc.com/ftp/h5/toastTest.html", @"showTitleBar":@"NO", @"showToolBar":@"YES"} JSApis:nil withDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
