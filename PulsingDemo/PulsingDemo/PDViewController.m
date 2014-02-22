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
@property (nonatomic, strong) PDPulsing *pulsingLayer2;
@property (nonatomic, strong) PDPulsing *pulsingLayer3;
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
    
    NSURL *imageUrl = [NSURL URLWithString:@"https://i.alipayobjects.com/e/201402/28CxGXg6dh.png"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = CGRectMake(130, 200, 100, 100);
    imageview.center = self.view.center;
    [imageview.layer setCornerRadius:50];
    [imageview setClipsToBounds:YES];
    [self.view addSubview:imageview];
    
    self.pulsingLayer = [PDPulsing layer];
    self.pulsingLayer.position = self.view.center;
    [self.view.layer insertSublayer:self.pulsingLayer below:imageview.layer];
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.7);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        self.pulsingLayer2 = [PDPulsing layer];
        self.pulsingLayer2.position = self.view.center;
        [self.view.layer insertSublayer:self.pulsingLayer2 below:imageview.layer];
    });
    
    dispatch_time_t delay2 = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1.4);
    dispatch_after(delay2, dispatch_get_main_queue(), ^(void){
        self.pulsingLayer3 = [PDPulsing layer];
        self.pulsingLayer3.position = self.view.center;
        [self.view.layer insertSublayer:self.pulsingLayer3 below:imageview.layer];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
