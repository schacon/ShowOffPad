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

- (IBAction) doNextButton {
	NSLog(@"NEXT");
	NSString *output = [webDisplayiPad stringByEvaluatingJavaScriptFromString:@"nextStep()"];
	NSLog(@"OUT :%@", output);
	notesArea.text = output;
}

- (IBAction) doPrevButton {
	[webDisplayiPad stringByEvaluatingJavaScriptFromString:@"prevStep()"];
}

- (IBAction) doFooterButton {
	[webDisplayiPad stringByEvaluatingJavaScriptFromString:@"toggleFooter()"];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidLoad {
	NSString *urlAddress = @"http://localhost:9090";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	//webDisplayiPad.scalesPageToFit = TRUE;
	[webDisplayiPad loadRequest:requestObj];
	
	[super viewDidLoad];
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
