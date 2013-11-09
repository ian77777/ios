//
//  BIDPresidentDetailViewController.h
//  Nav
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BIDPresident;
@protocol BIDPresidentDetailViewControllerDelegate;

@interface BIDPresidentDetailViewController : UITableViewController <UITextFieldDelegate>

@property (copy, nonatomic) BIDPresident *president;
@property (weak, nonatomic) id<BIDPresidentDetailViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger row;

@property (strong, nonatomic) NSArray *fieldLables;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;

@end

@protocol BIDPresidentDetailViewControllerDelegate <NSObject>

- (void)presidentDetailViewController:(BIDPresidentDetailViewController *)controller didUpdatePresident:(BIDPresident *)president;

@end
