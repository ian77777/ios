//
//  WifiFailureView.h
//  Home
//
//  Created by yang.zy on 14-2-21.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiFailureView : UIView

@property (nonatomic, strong) NSString *otherLinkUrl;

/**
 *  初始化失败页面
 *
 *  @param frame 页面大小
 *  @param otherNetworkUrl 连接其他网络地址
 *  @return
 */
- (WifiFailureView *)initWithFrame:(CGRect)frame otherNetworkUrl:(NSString *)otherNetworkUrl;

@end
