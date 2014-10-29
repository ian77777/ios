//
//  SMSettingViewController.m
//  Smart Mute
//
//  Created by yukai44444 on 14-10-28.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "SMSettingViewController.h"
#import "SMPickStyleTableViewCell.h"

@interface SMSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *settingTableView;
@end

@implementation SMSettingViewController

- (id)init
{
    if (self = [super init]) {
        self.title = @"设置";
        self.view.backgroundColor = [UIColor whiteColor];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [[SMPickStyleTableViewCell alloc] initWithType:kSMPickViewTypeStart];
    } else if (indexPath.section == 1) {
        cell = [[SMPickStyleTableViewCell alloc] initWithType:kSMPickViewTypeEnd];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"工作日";
        cell.detailTextLabel.text = @"周一";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

@end
