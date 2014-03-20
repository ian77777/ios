//
//  WifiCertifyViewController.h
//  Wifi
//
//  Created by yang.zy on 14-2-26.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "WifiCertifyView.h"


@interface WifiCertifyViewController : DTViewController

#pragma  mark - property

@property (nonatomic, strong) NSDictionary *detailInfos;
@property (nonatomic, strong) WifiCertifyView *certifyView;

#pragma  mark - public method

- (id)initWithParam:(NSDictionary *)param;

@end
