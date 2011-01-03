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
	[self setupList];
	[[NSNotificationCenter defaultCenter] addObserverForName:@"PresentationDownloaded" 
													  object:nil 
													   queue:[NSOperationQueue mainQueue] 
												  usingBlock:^(NSNotification *notification) {
		[self setupList];
		[(UITableView *)self.view reloadData];
	}];
}

-(void) setupList {
	NSArray *paths;
	NSString *presoPath = @"";
	
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	presoPath = [NSString stringWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"showoff"]];
	
	NSLog(@"READ PROJECTS:%@", presoPath);
	
	BOOL isDir=NO;
	self.list = [NSMutableArray array];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:presoPath isDirectory:&isDir] && isDir) {
		NSEnumerator *e = [[fileManager contentsOfDirectoryAtPath:presoPath error:nil] objectEnumerator];
		NSString *thisDir;
		while ( (thisDir = [e nextObject]) ) {
			[self.list addObject:thisDir];
		}
	}
}

-(IBAction)addPresentation {
	NewFormController *newFormController = [[NewFormController alloc] initWithNibName:@"NewFormController" bundle:nil];
	NSArray *viewControllers = [NSArray arrayWithObjects:self.navigationController, newFormController, nil];
	self.splitViewController.viewControllers = viewControllers;
	[newFormController release];
}

-(IBAction)editPresentation {
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)] autorelease];
	[(UITableView *)self.view setEditing:YES animated:YES];
}

-(void)doneEditing {
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPresentation)] autorelease];
	[(UITableView *)self.view setEditing:NO animated:YES];
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

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;	
}

#pragma mark -
#pragma mark TableView Delete Support
- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	ShowOffPadAppDelegate *delegate = (ShowOffPadAppDelegate*)[[UIApplication sharedApplication] delegate];
	for (NSIndexPath *indexPath in indexPaths) {
		[delegate deletePresentation:[list objectAtIndex:indexPath.row]];
	}
	[self setupList];
	[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		[self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

#pragma mark -
#pragma mark Table view selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    	
    /*
     Create and configure a new detail view controller appropriate for the selection.
     */
    NSUInteger row = indexPath.row;
		
	ShowOffPadAppDelegate *delegate = (ShowOffPadAppDelegate*)[[UIApplication sharedApplication] delegate];
	[delegate showPresentation:[list objectAtIndex:indexPath.row-1]];
    		
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

@end

