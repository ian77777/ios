//
//  ALPEFViewController.m
//  Electronic Fence
//
//  Created by yukai44444 on 14-2-27.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "ALPEFViewController.h"

@interface ALPEFViewController ()

@end

@implementation ALPEFViewController

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
    
    CGRect frame = self.view.frame;
    if([[UIDevice currentDevice].systemVersion compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)
    {
        frame.size.height -= 44;
    }
    
    self.view.frame = frame;
    
    UIImage *backgroudImg = nil;
    backgroudImg = [UIImage imageNamed:@"sky"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroudImg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
