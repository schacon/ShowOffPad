    //
//  ShowOffPadPresentController.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/10/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import "ShowOffPadPresentController.h"


@implementation ShowOffPadPresentController

@synthesize mainView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"Mofo Loaded");
	
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		return YES;
	}
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
