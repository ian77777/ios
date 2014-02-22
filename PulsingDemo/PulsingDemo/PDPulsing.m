//
//  PDPulsing.m
//  PulsingDemo
//
//  Created by 凯子 on 14-2-22.
//  Copyright (c) 2014年 凯子. All rights reserved.
//

#import "PDPulsing.h"


@interface PDPulsing ()
@property (nonatomic, strong) CAAnimationGroup *animationGroup;
@end


@implementation PDPulsing

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0;
        
        // default
        self.radius = 160;
        self.animationDuration = 2.1;
        self.backgroundColor = [[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1] CGColor];
        CGFloat diameter = self.radius * 2;
        self.bounds = CGRectMake(0, 0, diameter, diameter);
        self.cornerRadius = self.radius;
        
        [self setupAnimationGroup];
        [self addAnimation:self.animationGroup forKey:@"pulse"];
    }
    return self;
}

- (void)setupAnimationGroup {
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration;
    self.animationGroup.repeatCount = INFINITY;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = self.animationDuration;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = @[@0.45, @0.45, @0];
    opacityAnimation.keyTimes = @[@0, @0.2, @1];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    self.animationGroup.animations = animations;
}

@end
