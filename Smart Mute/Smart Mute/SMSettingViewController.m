//
//  SMSettingViewController.m
//  Smart Mute
//
//  Created by yukai44444 on 14-10-28.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "SMSettingViewController.h"
#import "SMPickStyleTableViewCell.h"
#import "SMWorkdayTableViewController.h"
#import "SMCommonDefine.h"

@interface SMSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *settingTableView;
@property(nonatomic, strong)NSArray *oldWorkday;
@property(nonatomic, strong)NSUserDefaults *userDefaults;
@end

@implementation SMSettingViewController

- (id)init
{
    if (self = [super init]) {
        self.title = @"设置";
        self.view.backgroundColor = [UIColor whiteColor];
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        self.oldWorkday = [NSArray arrayWithArray:[self.userDefaults arrayForKey:kSMWorkday]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.settingTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.settingTableView.dataSource = self;
    self.settingTableView.delegate = self;
    [self.view addSubview:self.settingTableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
}

- (void)dismiss
{
    [self.userDefaults setObject:self.oldWorkday forKey:kSMWorkday];
    [self.userDefaults synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)save
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"开始工作时间";
    } else if (section == 1) {
        return @"结束工作时间";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 44.0;
    } else {
        return 216.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMPickStyleTableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [[SMPickStyleTableViewCell alloc] initWithType:kSMPickViewTypeStart withStyle:UITableViewCellStyleDefault];
        if ([self.userDefaults objectForKey:kSMWorkStartTime]) {
            [cell selectPickViewWithDate:[self.userDefaults objectForKey:kSMWorkStartTime]];
        } else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:1];
            [cell selectPickViewWithDate:date];
        }
    } else if (indexPath.section == 1) {
        cell = [[SMPickStyleTableViewCell alloc] initWithType:kSMPickViewTypeEnd withStyle:UITableViewCellStyleDefault];
        if ([self.userDefaults objectForKey:kSMWorkEndTime]) {
            [cell selectPickViewWithDate:[self.userDefaults objectForKey:kSMWorkEndTime]];
        } else {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:1];
            [cell selectPickViewWithDate:date];
        }
    } else {
        cell = [[SMPickStyleTableViewCell alloc] initWithType:kSMPickViewTypeNone withStyle:UITableViewCellStyleValue1];
        cell.textLabel.text = @"工作日";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = [[self.userDefaults arrayForKey:kSMWorkday] componentsJoinedByString:@" "];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        SMWorkdayTableViewController *workdayTableViewController = [[SMWorkdayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:workdayTableViewController animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.settingTableView reloadData];
}

@end
