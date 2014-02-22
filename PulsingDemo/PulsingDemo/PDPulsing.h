//
//  PDPulsing.h
//  PulsingDemo
//
//  Created by 凯子 on 14-2-22.
//  Copyright (c) 2014年 凯子. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface PDPulsing : CALayer

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSTimeInterval pulseInterval;

@end
