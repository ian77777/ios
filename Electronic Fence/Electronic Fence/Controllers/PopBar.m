//
//  PopBar.m
//  APNFD
//
//  Created by satyso on 14-2-20.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "PopBar.h"
#import "MarqueeLabel.h"

#define KMaxTitleLength   12
#define KMaxContentLength       36

#define KLogoRect CGRectMake(5, 0, 20, self.frame.size.height)
#define KTitleLabelRect CGRectMake(35, 0, 100, self.frame.size.height)
#define KContentRect CGRectMake(155, 0, 165, self.frame.size.height)

@interface PopBar ()

@property (nonatomic, strong) NSString*             logoPath;
@property (nonatomic, strong) MarqueeLabel*         titleLabel;
@property (nonatomic, strong) MarqueeLabel*         contentLabel;

@end

@implementation PopBar

- (instancetype)initWithFrame:(CGRect)frame logo:(NSString*)logoImagePath title:(NSString*)title content:(NSString*)content
{
    if (self = [super initWithFrame:frame])
    {
        {//logo
            UIImageView* logo = nil;
            self.logoPath = logoImagePath;
            logo = [[UIImageView alloc] initWithFrame:KLogoRect];
            [logo setImage:[UIImage imageNamed:logoImagePath]];
            [self addSubview:logo];
        }

        {//title
            self.titleLabel = [[MarqueeLabel alloc] initWithFrame:KTitleLabelRect rate:10 andFadeLength:10];
            self.titleLabel.userInteractionEnabled = NO;
            if (title.length > KMaxTitleLength)
            {
                self.titleLabel.text = [title substringToIndex:KMaxTitleLength];
            }
            else
            {
                self.titleLabel.text = title;
                self.titleLabel.labelize = YES;
            }
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.textColor = [UIColor whiteColor];
            [self.titleLabel sizeThatFits:self.titleLabel.frame.size];
            [self addSubview:self.titleLabel];
        }
        
        {//content
            self.contentLabel = [[MarqueeLabel alloc] initWithFrame:KContentRect rate:10 andFadeLength:10];
            self.contentLabel.userInteractionEnabled = NO;
            if (content.length > KMaxContentLength)
            {
                self.contentLabel.text = [content substringToIndex:KMaxContentLength];
            }
            else
            {
                self.contentLabel.text = content;
                self.contentLabel.labelize = YES;
            }
            
            self.contentLabel.backgroundColor = [UIColor clearColor];
            self.contentLabel.textColor = [UIColor whiteColor];
            [self addSubview:self.contentLabel];
        }
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSString*)title
{
    return self.titleLabel.text;
}

- (NSString*)content
{
    return self.contentLabel.text;
}

- (void)setLogo:(NSString*)logoImagePath title:(NSString*)title content:(NSString*)content
{
//    CATransition *animation = [CATransition animation];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.type = kCATransitionFade;
//    animation.duration = 0.75;
//    [self.titleLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
//    [self.contentLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];

    self.titleLabel.text = title;
    self.contentLabel.text = content;
}

@end
