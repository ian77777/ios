//
//  BIDViewController.m
//  Hello World
//
//  Created by yukai44444 on 13-10-30.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "BIDViewController.h"

@interface BIDViewController ()

@end

@implementation BIDViewController

@synthesize statusLabel;

- (IBAction)buttonPress:(UIButton *)sender {
    NSString *title = [ sender titleForState:UIControlStateNormal];
    NSString *plainText = [NSString stringWithFormat:@"%@ button pressed.", title];
    NSMutableAttributedString *styledText = [[NSMutableAttributedString alloc]
                                             initWithString:plainText];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:statusLabel.font.pointSize]};
    
    NSRange nameRange = [plainText rangeOfString:title];
    
    [styledText setAttributes:attributes range:nameRange];
    
    statusLabel.attributedText = styledText;
}
@end
