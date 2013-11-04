//
//  BIDViewController.h
//  Hello World
//
//  Created by yukai44444 on 13-10-30.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)buttonPress:(UIButton *)sender;

@end
