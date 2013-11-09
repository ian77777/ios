//
//  BIDRowControllersViewController.h
//  Nav
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "BIDSecondLevelViewController.h"

@interface BIDRowControllersViewController : BIDSecondLevelViewController

@property (copy, nonatomic) NSArray *characters;

- (IBAction)tappedButton:(UIButton *)sender;

@end
