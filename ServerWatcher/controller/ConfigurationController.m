//
//  ConfigurationController.m
//  ServerWatcher
//
//  Created by Ivan Kovalisko on 19.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationController.h"

#import "ServerConfiguration.h"

@implementation ConfigurationController

@synthesize serverConfiguration;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    editField_ = [[UITextField alloc] initWithFrame:CGRectMake(160, 11, 140, 21)];
    editField_.returnKeyType = UIReturnKeyDone;
    editField_.delegate = self;
    editField_.textAlignment = UITextAlignmentRight;
    editField_.borderStyle = UITextBorderStyleNone;
    //editField_.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = serverConfiguration.name;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", indexPath.section, indexPath.row];
    //NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.detailTextLabel.hidden = NO;
    
    switch (indexPath.row) {
        case 0: 
        {
            cell.textLabel.text = @"Host";
            
            if ([serverConfiguration.url length] == 0) {
                cell.detailTextLabel.text = @"http://localhost";
            } else {
                cell.detailTextLabel.text = serverConfiguration.url;
            }
            break;
        }
        case 1: 
        {
            cell.textLabel.text = @"Port";
            
            if ([serverConfiguration.port intValue] == 0) {
                cell.detailTextLabel.text = @"80";
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [serverConfiguration.port intValue]];
            }
            break;
        }
        case 2: 
        {
            cell.textLabel.text = @"Timeout (sec)";
            
            if ([serverConfiguration.timeout intValue] == 0) {
                cell.detailTextLabel.text = @"15";
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [serverConfiguration.timeout intValue]];
            }
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show previous edited cell
    UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:editField_.tag inSection:0]];
    previousCell.detailTextLabel.hidden = NO;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //editField_.frame = cell.detailTextLabel.frame;
    //NSLog(@"field frame: %@", editField_);
    editField_.text = cell.detailTextLabel.text;
    editField_.tag = indexPath.row;
    editField_.font = cell.detailTextLabel.font;
    editField_.textColor = cell.detailTextLabel.textColor;
    cell.detailTextLabel.hidden = YES;
    
    [cell addSubview:editField_];
    [editField_ becomeFirstResponder];
    
    switch (indexPath.row) {
        case 0: 
        {
            break;
        }
        case 1: 
        {
            
            break;
        }
        case 2: 
        {
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Text Field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField removeFromSuperview];
    [self.tableView reloadData];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
    
    switch (textField.tag) {
        case 0: 
        {
            serverConfiguration.url = textField.text;
            break;
        }
        case 1: 
        {
            serverConfiguration.port = [NSNumber numberWithInt: [textField.text intValue]];
            break;
        }
        case 2: 
        {
            serverConfiguration.timeout = [NSNumber numberWithInt: [textField.text intValue]];            
            break;
        }
        default:
            break;
    }
    
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(saveContext)];
    
    return YES;
}

#pragma mark - Keyboard events
- (void) keyboardWillHide:(id) sender {
    NSLog(@"keyboard will hide");
    [editField_ resignFirstResponder];
    [editField_ removeFromSuperview];
    [self.tableView reloadData];
}

@end
