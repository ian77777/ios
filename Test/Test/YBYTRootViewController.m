//
//  YBYTRootViewController.m
//  Test
//
//  Created by yukai44444 on 14-7-8.
//  Copyright (c) 2014年 Bingye Yu. All rights reserved.
//

#import "YBYTRootViewController.h"
#import "YBYTSecondViewController.h"

@interface YBYTRootViewController ()

@end

@implementation YBYTRootViewController

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
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100.0, 100.0, 100.0)];
    [button setTitle:@"下一个VC" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    [self.view addSubview:button];
    [button addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushVC
{
    YBYTSecondViewController *secondViewController = [[YBYTSecondViewController alloc] init];
    [self.navigationController pushViewController:secondViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(postNo) withObject:nil afterDelay:3.0];
}

- (void)postNo
{
    NSLog(@"postNo");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"log" object:self userInfo:nil];
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

@end
