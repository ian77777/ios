//
//  YYYScrollNotice.m
//  scrollNotice
//
//  Created by yukai44444 on 13-11-25.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "YYYScrollNotice.h"

@implementation YYYScrollNotice

- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgcolor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = bgcolor;
        
        NSString *a = nil;
        NSString *b = @"";
        if (a) {
            NSLog(@"是aaaaaa");
        } else {
            NSLog(@"不是aaaaaa");
        }
        if (b) {
            NSLog(@"是bbbbb");
        } else {
            NSLog(@"不是bbbbb");
        }
    }
    return self;
}

- (void)rollLabelTitle:(NSString *)title textcolor:(UIColor *)color font:(UIFont *)font middleSpace:(NSUInteger) tempspace
{

    self.space = tempspace;
    
    //文字大小，设置label的大小和uiscroll的大小
    CGSize size = [title sizeWithFont:font constrainedToSize:kConstrainedSize lineBreakMode:NSLineBreakByWordWrapping];
    
    self.contentSize = size;//滚动大小
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *templb1 = [[UILabel alloc] initWithFrame:frame];
    self.label1 = templb1;
    
    UILabel *templb2 = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width+self.space, frame.origin.y, size.width, size.height)];
    self.label2 = templb2;
    
    self.label1.text = title,self.label2.text = title;
    self.label1.font = font ,self.label2.font = font;
    self.label1.textColor = color, self.label2.textColor = color;
    self.label1.backgroundColor = [UIColor clearColor];
    self.label2.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.label1];
    [self addSubview:self.label2];
    
    [self animationOfScroll];
    
}

//滚动的动画，就是同时改变label1、label2的frame的x的值。
-(void)animationOfScroll
{
    CGPoint lb1Origin = self.label1.frame.origin;
    CGSize lb1Size = self.label1.frame.size;
    
    CGPoint lb2Origin = self.label2.frame.origin;
    CGSize lb2Size = self.label2.frame.size;

    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"position"];
    animate.duration = 2.0f;
    animate.repeatCount = INFINITY;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animate.toValue = [NSValue valueWithCGPoint:(CGPoint){lb1Origin.x -  lb1Size.width/2 - self.space, lb1Origin.y + lb1Size.height/2}];
    [self.label1.layer addAnimation:animate forKey:nil];
    
    CABasicAnimation *animate2 = [CABasicAnimation animationWithKeyPath:@"position"];
    animate2.duration = 2.0f;
    animate2.repeatCount = INFINITY;
    animate2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animate2.toValue = [NSValue valueWithCGPoint:(CGPoint){lb2Origin.x -  lb2Size.width/2 - self.space, lb2Origin.y + lb2Size.height/2}];
    [self.label2.layer addAnimation:animate2 forKey:nil];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
