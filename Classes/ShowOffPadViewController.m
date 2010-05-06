//
//  ShowOffPadViewController.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import "ShowOffPadViewController.h"

@implementation ShowOffPadViewController

@synthesize webDisplayiPad;
@synthesize nextButton, prevButton, footerButton, notesArea;

- (void)viewDidLoad {
	NSString *urlAddress = @"http://localhost:9090";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webDisplayiPad loadRequest:requestObj];

	[super viewDidLoad];	
}

- (IBAction) doNextButton {
	NSString *output = [webDisplayiPad stringByEvaluatingJavaScriptFromString:@"nextStep()"];
	if (![output isEqualToString:@""]) {
		notesArea.text = output;
	}
}

- (IBAction) doPrevButton {
	NSString *output = [webDisplayiPad stringByEvaluatingJavaScriptFromString:@"prevStep()"];
	if (![output isEqualToString:@""]) {
		notesArea.text = output;
	}
}

- (IBAction) doFooterButton {
	[webDisplayiPad stringByEvaluatingJavaScriptFromString:@"toggleFooter()"];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		return YES;
	}
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
	return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
