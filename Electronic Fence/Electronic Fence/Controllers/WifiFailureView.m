//
//  WifiFailureView.m
//  Home
//
//  Created by yang.zy on 14-2-21.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "WifiFailureView.h"

static NSString * const FailureLabelText = @"网络连接失败";
static NSString * const DetailCauseLabelText = @"抱歉,貌似网络出了点问题";
static NSString * const OtherNetworkStyleText = @"其他上网方式";
static NSString * const ReConnText= @"重新连接";

@implementation WifiFailureView
@synthesize otherLinkUrl=_otherLinkUrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (WifiFailureView *)initWithFrame:(CGRect)frame otherNetworkUrl:(NSString *)otherNetworkUrl 
{
    WifiFailureView *failureView = [[WifiFailureView alloc] initWithFrame:frame];
    [failureView createSubViews];
    [failureView setOtherLinkUrl:otherNetworkUrl];
    return failureView;
}

- (void)createSubViews
{


    self.backgroundColor = [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:244.f/255.f alpha:1];
    
    CGRect imageFrame = CGRectMake((self.bounds.size.width-74)/2, (self.bounds.size.height-204)/2, 74, 74);
    UIImageView *failureImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [failureImageView setImage:[UIImage imageNamed:@"wifi-failure"]];
    [self addSubview:failureImageView];
    

    CGRect connectFrame = CGRectMake(0, CGRectGetMaxY(imageFrame)+20, self.bounds.size.width, 18);
    UILabel *connFailureLabel = [[UILabel alloc] initWithFrame:connectFrame];
    connFailureLabel.backgroundColor = [UIColor clearColor];
    connFailureLabel.textColor = [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1];
    connFailureLabel.text = FailureLabelText;
    connFailureLabel.textAlignment = NSTextAlignmentCenter;
    connFailureLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:connFailureLabel];
    
    CGRect promptFrame = CGRectMake(0, CGRectGetMaxY(connectFrame)+10, self.bounds.size.width, 13);
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:promptFrame];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textColor = [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1];
    promptLabel.text = DetailCauseLabelText;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:promptLabel];
    
    APButton *reconnButton = [APButton buttonWithType:APButtonTypeDefault title:ReConnText target:self action:@selector(buttonClickWithReconn)];
    reconnButton.frame = CGRectOffset(reconnButton.bounds, 10 , CGRectGetMaxY(promptFrame)+25);
    [reconnButton.layer setMasksToBounds:YES];
    [reconnButton.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [reconnButton setTitleColor:[UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:1] forState:UIControlStateNormal];
    reconnButton.backgroundColor = [UIColor colorWithRed:0.f/255.f green:127.f/255.f blue:245.f/255.f alpha:1];
    [self addSubview:reconnButton];
    
    CGSize textRealSize = [OtherNetworkStyleText sizeWithFont:[UIFont systemFontOfSize:13]];
    CGRect otherNetFrame = CGRectMake(self.bounds.size.width-10-100, self.bounds.size.height-15-20, textRealSize.width, 30);
    UIButton *otherNetButton = [[UIButton alloc] initWithFrame:otherNetFrame];
    [otherNetButton setTitle:OtherNetworkStyleText forState:UIControlStateNormal];
    otherNetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    otherNetButton.contentMode = UIViewContentModeBottom;
    otherNetButton.backgroundColor = [UIColor clearColor];
    [otherNetButton setTitleColor:[UIColor colorWithRGB:0x2861d7] forState:UIControlStateNormal];
    [otherNetButton setTitleColor:[[UIColor colorWithRGB:0x2861d7] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [otherNetButton addTarget:self action:@selector(openOtherNetwork) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:otherNetButton];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(otherNetFrame), CGRectGetMaxY(otherNetFrame)-7, otherNetFrame.size.width, 1)];
    line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    line.backgroundColor = [UIColor colorWithRGB:0x2861d7];
    [self addSubview:line];
}

- (void)openOtherNetwork
{
    NSLog(@"wifi打开其他上网地址:%@",_otherLinkUrl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_otherLinkUrl]];
}

- (void)buttonClickWithReconn
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kReConnWifiCertify" object:nil];
}

@end
