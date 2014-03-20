//
//  PopLoadingBar.m
//  APNFD
//
//  Created by satyso on 14-2-20.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "PopLoadingBar.h"

#define KPrelude    @"发现魔力场"
#define KLoadingText    @"服务读取中"

@interface PopLoadingBar ()

@property (nonatomic, strong) UIImageView*      logo;

@property (nonatomic, strong) UILabel*          title;

@property (nonatomic, strong) NSTimer*          preludeTimer;

@property (nonatomic, strong) NSTimer*          loadingTimer;

@property (nonatomic, assign) BOOL              preludeMark;

- (void)preludeTimerFired;

- (void)loadingTimerFired;

@end

@implementation PopLoadingBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, self.frame.size.height)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor whiteColor];
        [self addSubview:self.title];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)startLoading
{
    self.preludeTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(preludeTimerFired) userInfo:nil repeats:YES];
    [self.preludeTimer fire];
    self.preludeMark = NO;
}

- (void)endLoading
{
    [self.preludeTimer invalidate];
    [self.loadingTimer invalidate];
}

#pragma mark- private

- (void)preludeTimerFired
{
    if (self.title.text.length < KPrelude.length && self.preludeMark == NO)
    {
        self.title.text = [KPrelude substringToIndex:self.title.text.length + 1];
    }
    else
    {
        [self.preludeTimer invalidate];
        self.title.text = @"";
        self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadingTimerFired) userInfo:nil repeats:YES];
    }

}

- (void)loadingTimerFired
{
    if (self.title.text.length < KLoadingText.length)
    {
        self.title.text = [KLoadingText substringToIndex:self.title.text.length + 1];
    }
    else
    {
        int count = (self.title.text.length - KLoadingText.length) % 3 + 1;
        NSMutableString* tmpString = [NSMutableString stringWithFormat:@"%@", KLoadingText];
        for (int i = 0; i < count; i++)
        {
            [tmpString appendString:@"."];
        }
        self.title.text = tmpString;
    }
}

@end
