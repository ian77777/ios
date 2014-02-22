//
//  PDViewController.m
//  PulsingDemo
//
//  Created by 凯子 on 14-2-22.
//  Copyright (c) 2014年 凯子. All rights reserved.
//

#import "PDViewController.h"
#import "PDPulsing.h"

@interface PDViewController ()
@property (nonatomic, strong) PDPulsing *pulsingLayer;
@end

@implementation PDViewController

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
    self.pulsingLayer = [PDPulsing layer];
    self.pulsingLayer.position = self.view.center;
    [self.view.layer addSublayer:self.pulsingLayer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
