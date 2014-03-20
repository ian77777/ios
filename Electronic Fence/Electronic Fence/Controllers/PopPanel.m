//
//  PopPanel.m
//  APNFD
//
//  Created by satyso on 14-2-20.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "PopPanel.h"
#import "MarqueeLabel.h"

@interface PopPanel ()

@property (nonatomic, strong) NSString*             logoPath;
@property (nonatomic, strong) UIButton*             logoButton;
@property (nonatomic, strong) UILabel*              titleLabel;
@property (nonatomic, strong) UILabel*              contentLabel;

- (void)logoButtonTouch;

@end

@implementation PopPanel

- (instancetype)initWithFrame:(CGRect)frame logo:(NSString*)logoImagePath title:(NSString*)title content:(NSString*)content
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.logoPath = logoImagePath;
        
        self.logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.logoButton.frame = CGRectMake(150, 20, 30, 30);
        [self.logoButton setImage:[UIImage imageNamed:self.logoPath] forState:UIControlStateNormal];
        [self.logoButton addTarget:self action:@selector(logoButtonTouch) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.logoButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 120, 10)];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 130, 20)];
        self.contentLabel.text = content;
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel sizeToFit];
        [self addSubview:self.contentLabel];
        
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

- (void)setLogo:(NSString*)logoImagePath title:(NSString*)title content:(NSString*)content
{
    
}

- (NSString*)title
{
    return self.titleLabel.text;
}

-(NSString*)content
{
    return self.contentLabel.text;
}

#pragma mark- touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    if (CGRectContainsPoint(self.logoButton.frame, p) && [self respondsToSelector:@selector(logoButtonTouch)])
    {
        [self performSelector:@selector(logoButtonTouch)];
    }
}


#pragma mark- private

- (void)logoButtonTouch
{
    NSLog(@"%s",__FUNCTION__);
}

@end
