//
//  YBYTSecondViewController.m
//  Test
//
//  Created by yukai44444 on 14-7-8.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YBYTSecondViewController.h"

@interface YBYTSecondViewController ()

@end

@implementation YBYTSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(log) name:@"log" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"log" object:self userInfo:nil];
}

- (void)log
{
    NSLog(@"recieved notification");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
