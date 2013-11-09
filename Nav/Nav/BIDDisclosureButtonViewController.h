//
//  BIDDisclosureButtonViewController.h
//  Nav
//
//  Created by yukai44444 on 13-11-8.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "BIDSecondLevelViewController.h"
@class BIDDisclosureButtonDetailViewController;

@interface BIDDisclosureButtonViewController : BIDSecondLevelViewController

@property (copy, nonatomic) NSArray *movies;
@property (strong, nonatomic) BIDDisclosureButtonDetailViewController *detailController;

@end
