    //
//  RootController.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/11/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import "RootController.h"
#import "NewFormController.h"
#import "ShowOffPadAppDelegate.h"

@implementation RootController

@synthesize splitViewController, list;

#pragma mark -
#pragma mark Initial configuration

- (void)viewDidLoad {
    [super viewDidLoad];
    // load available presentations
	NSArray *paths;
	NSString *presoPath = @"";
	
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	presoPath = [NSString stringWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"showoff"]];

	NSLog(@"READ PROJECTS:%@", presoPath);
	
	BOOL isDir=NO;
	[list release];
	list = [[NSMutableArray alloc] init];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:presoPath isDirectory:&isDir] && isDir) {
		NSEnumerator *e = [[fileManager contentsOfDirectoryAtPath:presoPath error:nil] objectEnumerator];
		NSString *thisDir;
		while ( (thisDir = [e nextObject]) ) {
			[list addObject:thisDir];
		}
	}
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		return YES;
	}
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
	return NO;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Two sections, one for each detail view controller.
    return [list count] + 1;
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
        cell.textLabel.text = @"Load New Presentation";
    }
    else {
		int theIndex = indexPath.row - 1;
        cell.textLabel.text = [list objectAtIndex:theIndex];
    }
	
    return cell;
}


#pragma mark -
#pragma mark Table view selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    	
    /*
     Create and configure a new detail view controller appropriate for the selection.
     */
    NSUInteger row = indexPath.row;
    
    if (row == 0) {
		/* We may one day want to show info on a preso, so we'll need to get back */
		
        NewFormController *newFormController = [[NewFormController alloc] initWithNibName:@"NewFormController" bundle:nil];
        NSArray *viewControllers = [NSArray arrayWithObjects:self.navigationController, newFormController, nil];
		self.splitViewController.viewControllers = viewControllers;
		[newFormController release];
	} else {
		/* For now just switch to the presentation */
		
		// Update the split view controller's view controllers array.
		//NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
		//splitViewController.viewControllers = viewControllers;
		//[viewControllers release];
		
		ShowOffPadAppDelegate *delegate = (ShowOffPadAppDelegate*)[[UIApplication sharedApplication] delegate];
		[delegate showPresentation:[list objectAtIndex:indexPath.row-1]];
	}
    		
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

@end

