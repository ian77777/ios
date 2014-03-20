//
//  PopPanel.h
//  APNFD
//
//  Created by satyso on 14-2-20.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarqueeLabel;

@interface PopPanel : UIView

- (instancetype)initWithFrame:(CGRect)frame logo:(NSString*)logoImagePath title:(NSString*)title content:(NSString*)content;

- (void)setLogo:(NSString*)logoImagePath title:(NSString*)title content:(NSString*)content;

@property (nonatomic, strong, readonly) NSString*                                   logoPath;
@property (nonatomic, strong, readonly, getter = title) NSString*                   title;
@property (nonatomic, strong, readonly, getter = content) NSString*                 content;

@end
