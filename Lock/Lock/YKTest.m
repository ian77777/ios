//
//  YKTest.m
//  Lock
//
//  Created by 凯子 on 14-5-8.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YKTest.h"

@implementation YKTest

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)method1
{
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 50)];
    label1.text = @"method1";
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:14];
    [self addSubview:label1];
}

- (void)method2
{
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 150, 50)];
    label2.text = @"method2";
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:14];
    [self addSubview:label2];
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
