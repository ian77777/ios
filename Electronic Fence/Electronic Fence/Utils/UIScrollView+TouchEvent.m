//
//  UIScrollView+TouchEvent.m
//  APNFD
//
//  Created by satyso on 14-2-21.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "UIScrollView+TouchEvent.h"

@implementation UIScrollView (TouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end
