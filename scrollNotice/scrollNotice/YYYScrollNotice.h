//
//  YYYScrollNotice.h
//  scrollNotice
//
//  Created by yukai44444 on 13-11-25.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kConstrainedSize CGSizeMake(10000,40)//字体最大

@interface YYYScrollNotice : UIScrollView


//rollLabelTitle方式中的两个label及他们的frame
@property (nonatomic) UILabel *label1;
@property (nonatomic) UILabel *label2;
//两个label中间的距离
@property (nonatomic,assign) NSUInteger space;

- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgcolor;

//文字相继出现
- (void)rollLabelTitle:(NSString *)title textcolor:(UIColor *)color font:(UIFont *)font middleSpace:(NSUInteger) tempspace;

@end
