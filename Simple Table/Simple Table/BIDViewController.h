//
//  BIDViewController.h
//  Simple Table
//
//  Created by yukai44444 on 13-11-7.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *dwarves;

@end
