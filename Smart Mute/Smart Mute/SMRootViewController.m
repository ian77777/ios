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

@interface SMRootViewController ()

@property(nonatomic, strong) UIButton *muteLabel;

@end

@implementation SMRootViewController

- (id)init
{
    if (self = [super init]) {
        self.title = @"工作要静音";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.muteLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200.0, 50.0)];
    self.muteLabel.backgroundColor = [UIColor whiteColor];
    self.muteLabel.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.muteLabel.hidden = YES;
    [self.muteLabel.layer setBorderWidth:1.0];
    self.muteLabel.layer.cornerRadius = 10.0;
    self.muteLabel.layer.masksToBounds = YES;
    
    CGRect frame = self.muteLabel.frame;
    frame.origin.x = (kViewWidth - frame.size.width) / 2;
    frame.origin.y = (kViewHeight - frame.size.height) / 2;
    self.muteLabel.frame = frame;
    
    [self.view addSubview:self.muteLabel];
    
    [self setSoundStatus];
    
    // 设置右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
}

- (void)setMuteStatus
{
    self.muteLabel.hidden = NO;
    [self.muteLabel setTitle:@"已静音" forState:UIControlStateNormal];
    [self.muteLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.muteLabel.layer setBorderColor:[UIColor redColor].CGColor];
}

- (void)setSoundStatus
{
    self.muteLabel.hidden = NO;
    [self.muteLabel setTitle:@"已开启声音" forState:UIControlStateNormal];
    [self.muteLabel setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.muteLabel.layer setBorderColor:[UIColor greenColor].CGColor];
}

- (void)setting
{
    SMSettingViewController *settingVC = [[SMSettingViewController alloc] init];
}

@end
