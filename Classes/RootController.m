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

@synthesize newButton, mainView;

- (void)viewDidLoad {
	NewFormController *newForm = [[NewFormController alloc] 
								  initWithNibName:@"NewFormController" 
								  bundle:nil];
	[self.mainView addSubview:newForm.view];
	
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	presoPath = [NSString stringWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"showoff"]];
	[presoPath retain];

	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}


@end
