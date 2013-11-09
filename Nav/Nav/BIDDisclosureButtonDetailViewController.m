//
//  BIDDisclosureButtonDetailViewController.m
//  Nav
//
//  Created by yukai44444 on 13-11-8.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "BIDDisclosureButtonDetailViewController.h"

@interface BIDDisclosureButtonDetailViewController ()

@end

@implementation BIDDisclosureButtonDetailViewController

- (UILabel *)label {
    return (id)self.view;
}

- (void)loadView {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    self.view = label;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.label.text = self.message;
}

@end
