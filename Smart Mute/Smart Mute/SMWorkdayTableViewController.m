//
//  workdayTableViewController.m
//  Smart Mute
//
//  Created by yukai44444 on 14/10/30.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "SMWorkdayTableViewController.h"
#import "SMCommonDefine.h"

@interface SMWorkdayTableViewController ()

@property (nonatomic, strong) NSArray *allDay;
@property (nonatomic, strong) NSMutableArray *selectedDay;

@end

static NSString *SMWorkdayTableViewControllerCell = @"SMWorkdayTableViewControllerCell";

@implementation SMWorkdayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作日";
    self.allDay = [NSArray arrayWithObjects:@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日", nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SMWorkdayTableViewControllerCell];
    
    // 取已经设定的工作日
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.selectedDay = [[NSMutableArray alloc] initWithArray:[userDefaults arrayForKey:kSMWorkday]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allDay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SMWorkdayTableViewControllerCell forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SMWorkdayTableViewControllerCell];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([self.selectedDay containsObject:[self.allDay objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = [self.allDay objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.selectedDay containsObject:cell.textLabel.text]) {
        [self.selectedDay removeObject:cell.textLabel.text];
    } else {
        [self.selectedDay addObject:cell.textLabel.text];
    }
    [tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.selectedDay forKey:kSMWorkday];
    [userDefaults synchronize];
}

@end
