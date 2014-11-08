//
//  ViewController.m
//  Smart Mute
//
//  Created by yukai44444 on 14-10-28.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#define kViewWidth self.view.frame.size.width
#define kViewHeight self.view.frame.size.height

#import "SMRootViewController.h"
#import "SMSettingViewController.h"
#import "SMCommonDefine.h"

@interface SMRootViewController ()

@property(nonatomic, strong) UIButton *muteLabel;

@end

@implementation SMRootViewController

- (id)init
{
    if (self = [super init]) {
        self.title = @"工作时间静音";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.muteLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200.0, 50.0)];
    self.muteLabel.backgroundColor = [UIColor whiteColor];
    self.muteLabel.titleLabel.font = [UIFont systemFontOfSize:20.0];
    self.muteLabel.hidden = YES;
//    [self.muteLabel.layer setBorderWidth:1.0];
//    self.muteLabel.layer.cornerRadius = 10.0;
    self.muteLabel.layer.masksToBounds = YES;
    
    CGRect frame = self.muteLabel.frame;
    frame.origin.x = (kViewWidth - frame.size.width) / 2;
    frame.origin.y = (kViewHeight - frame.size.height) / 2;
    self.muteLabel.frame = frame;
    
    [self.view addSubview:self.muteLabel];
    
    // 设置右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
}

- (void)setMuteStatus
{
    self.muteLabel.hidden = NO;
    [self.muteLabel setTitle:@"已静音" forState:UIControlStateNormal];
    [self.muteLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.muteLabel.layer setBorderColor:[UIColor redColor].CGColor];
}

- (void)setSoundStatus
{
    self.muteLabel.hidden = NO;
    [self.muteLabel setTitle:@"已开启声音" forState:UIControlStateNormal];
    [self.muteLabel setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    [self.muteLabel.layer setBorderColor:[UIColor greenColor].CGColor];
}

- (void)setting
{
    SMSettingViewController *settingVC = [[SMSettingViewController alloc] init];
    UINavigationController *modalNavController = [[UINavigationController alloc] initWithRootViewController:settingVC];
    modalNavController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController presentViewController:modalNavController animated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDate *startDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSMWorkStartTime];
    NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSMWorkEndTime];
    NSDate *nowDate = [NSDate date];
    unsigned units = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [myCal components:units fromDate:nowDate];
    NSInteger hour = [comp hour];
    NSInteger minute = [comp minute];
    NSDate *zeroDate = [NSDate dateWithTimeIntervalSince1970:0];
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:zeroDate];
    NSDate *newNowDate = [zeroDate dateByAddingTimeInterval:-timeOffset + hour*3600 + minute*60];
    
    if ([startDate compare:newNowDate] == NSOrderedAscending && [newNowDate compare:endDate] == NSOrderedAscending) {
        [self setMuteStatus];
    } else {
        [self setSoundStatus];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kSMWorkStartTime]) {
        [self setting];
    }
}

@end
