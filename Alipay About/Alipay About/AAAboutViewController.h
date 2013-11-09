//
//  AAAboutViewController.h
//  Alipay About
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAFeedbackViewController;

@interface AAAboutViewController : UITableViewController

@property (copy, nonatomic) NSArray *tableCells;
@property (strong, nonatomic) AAFeedbackViewController *feedbackController;

@end
