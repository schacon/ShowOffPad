    //
//  RootController.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/11/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import "RootController.h"
#import "NewFormController.h"

@implementation RootController

@synthesize splitViewController;


#pragma mark -
#pragma mark Initial configuration

- (void)viewDidLoad {
    
    [super viewDidLoad];
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Two sections, one for each detail view controller.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RootViewControllerCellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set appropriate labels for the cells.
    if (indexPath.row == 0) {
        cell.textLabel.text = @"First Detail View Controller";
    }
    else {
        cell.textLabel.text = @"Second Detail View Controller";
    }
	
    return cell;
}


#pragma mark -
#pragma mark Table view selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     Create and configure a new detail view controller appropriate for the selection.
     */
    NSUInteger row = indexPath.row;
    
    UIViewController *detailViewController = nil;
	
    if (row == 0) {
        NewFormController *newFormController = [[NewFormController alloc] initWithNibName:@"NewFormController" bundle:nil];
        detailViewController = newFormController;
    }
		
    // Update the split view controller's view controllers array.
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
    splitViewController.viewControllers = viewControllers;
    [viewControllers release];
    		
    [detailViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

@end

