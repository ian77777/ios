//
//  BIDPresidentDetailViewController.m
//  Nav
//
//  Created by yukai44444 on 13-11-9.
//  Copyright (c) 2013年 yukai44444. All rights reserved.
//

#import "BIDPresidentDetailViewController.h"
#import "BIDPresident.h"

#define kNumberOfEditableRows 4
#define kNameRowIndex 0
#define kFromYearRowIndex 1
#define kToYearRowINdex 2
#define kPartyIndex 3

#define kLabelTag 2048
#define kTextFieldTag 4094

@implementation BIDPresidentDetailViewController {
    NSString *initialText;
    BOOL hasChanges;
}

- (void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    [self.view endEditing:YES];
    if (hasChanges) {
        [self.delegate presidentDetailViewController:self didUpdatePresident:self.president];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDone:(id)sender
{
    [sender resignFirstResponder];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.fieldLables = @[@"Name:", @"Frem:", @"To:", @"Party:"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return kNumberOfEditableRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 25)];
        lable.tag = kLabelTag;
        lable.textAlignment = NSTextAlignmentRight;
        lable.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:lable];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 200, 25)];
        textField.tag = kTextFieldTag;
        textField.clearsOnBeginEditing = NO;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
    }
    
    UILabel *label = (id)[cell viewWithTag:kLabelTag];
    label.text = self.fieldLables[indexPath.row];
    
    UITextField *textField = (id)[cell viewWithTag:kTextFieldTag];
    textField.superview.tag = indexPath.row;
    switch (indexPath.row) {
        case kNameRowIndex:
            textField.text = self.president.name;
            break;
        case kFromYearRowIndex:
            textField.text = self.president.fromYear;
            break;
        case kToYearRowINdex:
            textField.text = self.president.toYear;
            break;
        case kPartyIndex:
            textField.text = self.president.party;
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    initialText = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:initialText]) {
        hasChanges = YES;
        switch (textField.superview.tag) {
            case kNameRowIndex:
                self.president.name = textField.text;
                break;
            case kFromYearRowIndex:
                self.president.fromYear = textField.text;
                break;
            case kToYearRowINdex:
                self.president.toYear = textField.text;
                break;
            case kPartyIndex:
                self.president.party = textField.text;
            default:
                break;
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
