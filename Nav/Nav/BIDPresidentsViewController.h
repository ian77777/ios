//
//  BIDPresidentsViewController.h
//  Nav
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "BIDSecondLevelViewController.h"
#import "BIDPresident.h"
#import "BIDPresidentDetailViewController.h"

@interface BIDPresidentsViewController : BIDSecondLevelViewController <BIDPresidentDetailViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *presidents;

@end
