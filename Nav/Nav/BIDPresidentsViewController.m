//
//  BIDPresidentsViewController.m
//  Nav
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "BIDPresidentsViewController.h"
#import "BIDPresident.h"
#import "BIDPresidentDetailViewController.h"

static NSString *CellIdentifier = @"Cell";

@implementation BIDPresidentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Detail Edit";
        self.rowImage = [UIImage imageNamed:@"detailEditIcon.png"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Presidents" ofType:@"plist"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.presidents = [unarchiver decodeObjectForKey:@"Presidents"];
        [unarchiver finishDecoding];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.presidents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    BIDPresident *president = self.presidents[indexPath.row];
    cell.textLabel.text = president.name;
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIDPresident *president = self.presidents[indexPath.row];
    BIDPresidentDetailViewController *controller =
    [[BIDPresidentDetailViewController alloc] init];
    controller.president = president;
    controller.delegate = self;
    controller.row = indexPath.row;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - President Detail View Delegate Methods

- (void)presidentDetailViewController:(BIDPresidentDetailViewController *)controller
                   didUpdatePresident:(BIDPresident *)president
{
    [self.presidents replaceObjectAtIndex:controller.row withObject:president];
    [self.tableView reloadData];
}

@end
