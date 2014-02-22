//
//  AAAboutViewController.m
//  Alipay About
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//
#import "AAAboutViewController.h"
#import "AAFeedbackViewController.h"

static NSString *CellIdentifier = @"Cell";

@interface AAAboutViewController ()
{
    UIImageView *logoView;
    UITableView *aboutList;
    UILabel *versionLabel;
}

@end

@implementation AAAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于";
        self.view.backgroundColor = [UIColor colorWithRed:0xf3/255.0f green:0xf3/255.0f blue:0xf3/255.0f alpha:1];
        self.tableCells = @[
                             @"检测新版本",
                             @"版本说明",
                             @"反馈",
                             @"去评分"
                             ];
        self.feedbackController = [[AAFeedbackViewController alloc] init];
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSInteger centerX = self.view.bounds.size.width / 2;
    
    //添加logo
    logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon7"]];
    logoView.center = CGPointMake(centerX, 20.0f + logoView.bounds.size.height/2);
    logoView.layer.cornerRadius = 9.0f;
    logoView.layer.masksToBounds = YES;
    logoView.layer.borderColor = [UIColor colorWithRed:0xcc/255.0f green:0xcc/255.0f blue:0xcc/255.0f alpha:0.5].CGColor;
    logoView.layer.borderWidth = 1.0f;
    
    [self.view addSubview:logoView];
    
    //添加版本号
    versionLabel = [[UILabel alloc] init];
    versionLabel.text = @"版本号：1.0.0";
    versionLabel.textColor = [UIColor colorWithRed:0x99/255.0f green:0x99/255.0f blue:0x99/255.0f alpha:1];
    versionLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    versionLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.8];
    versionLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    versionLabel.font = [UIFont systemFontOfSize:16.0f];
    versionLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [versionLabel sizeToFit];
    versionLabel.center = CGPointMake(centerX, logoView.frame.origin.y + logoView.frame.size.height + versionLabel.bounds.size.height / 2 + 5);
    [self.view addSubview:versionLabel];
    
    //添加table
    aboutList = [[UITableView alloc] initWithFrame:CGRectMake(0, versionLabel.frame.origin.y + 20, self.view.frame.size.width, 220) style:UITableViewStyleGrouped];
    aboutList.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0];
    aboutList.backgroundView = nil;
    aboutList.scrollEnabled = NO;
    aboutList.dataSource = self;
    aboutList.delegate = self;
    aboutList.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [aboutList registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:aboutList];
    
    // 添加底部版权信息
    UILabel *lblCopy = [[UILabel alloc] init];
    lblCopy.text = @"Copyright© 2004-2013 ALIPAY.COM. All Rights Reserved.";
    lblCopy.textColor = [UIColor colorWithRed:0xcc/255.0f green:0xcc/255.0f blue:0xcc/255.0f alpha:1];
    lblCopy.shadowColor = [UIColor colorWithWhite:1.0f alpha:1];
    lblCopy.shadowOffset = CGSizeMake(1.0f, 1.0f);
    lblCopy.font = [UIFont systemFontOfSize:11.0f];
    lblCopy.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    lblCopy.contentMode = UIViewContentModeBottomLeft;
    [lblCopy sizeToFit];
    lblCopy.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    lblCopy.center = CGPointMake(centerX, self.view.bounds.size.height - lblCopy.bounds.size.height/2 - 12.0f);
    [self.view addSubview:lblCopy];
    
    // 添加底部logo
    UIImageView *logoBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoBottom.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    logoBottom.center = CGPointMake(centerX, lblCopy.frame.origin.y - logoBottom.bounds.size.height/2 - 5.0f);
    [self.view addSubview:logoBottom];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = self.tableCells[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.tableCells[indexPath.row] isEqualToString:@"反馈"]) {
        NSString *character = self.tableCells[indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"点击事件"
                              message:[NSString stringWithFormat:@"你点击了“%@”行。", character]
                              delegate:nil
                              cancelButtonTitle:@"真好"
                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        self.feedbackController.title = @"反馈";
        [self.navigationController pushViewController:self.feedbackController
                                             animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
