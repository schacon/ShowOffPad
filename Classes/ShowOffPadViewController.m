//
//  ShowOffPadViewController.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import "ShowOffPadViewController.h"

@implementation ShowOffPadViewController

@synthesize webDisplayiPad, extDisplay;
@synthesize nextButton, prevButton, footerButton, notesArea, slideProgress, timeElapsed;
@synthesize slideProgressBar, timeProgress, totalTime, padStatus;

- (void)viewDidLoad {
	//NSString *urlAddress = @"http://localhost:9090";
	NSString *urlAddress = @"http://showofftest.heroku.com/";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webDisplayiPad loadRequest:requestObj];
	[extDisplay loadRequest:requestObj];

	counter = 0;
	basetime = 0;

	[NSTimer scheduledTimerWithTimeInterval:1.0f
									 target:self
								   selector:@selector(updateCounter:)
								   userInfo:nil
									repeats:YES];
	[super viewDidLoad];
}

- (void)updateCounter:(NSTimer *)theTimer {
	counter += 1;
	float elapsed = (float)(counter - basetime);
	float total = [totalTime.text floatValue];
	NSString *s = [[NSString alloc] initWithFormat:@"%2.0f", elapsed];
	timeElapsed.text = s;
	[s release];
	float currProgress = elapsed / total;
	timeProgress.progress = currProgress;
}

- (IBAction) doNextButton {
	NSString *output = [webDisplayiPad stringByEvaluatingJavaScriptFromString:@"nextStep()"];
	if (output && ![output isEqualToString:@""]) {
		notesArea.text = output;
	}
	[self updateProgress];
}

- (IBAction) doPrevButton {
	NSString *output = [webDisplayiPad stringByEvaluatingJavaScriptFromString:@"prevStep()"];
	if (![output isEqualToString:@""]) {
		notesArea.text = output;
	}
	[self updateProgress];
}

- (void) updateProgress {
	NSString *progress = [webDisplayiPad stringByEvaluatingJavaScriptFromString:@"getSlideProgress()"];
	if(progress && (![progress isEqualToString:@""])) {
		slideProgress.text = progress;
		NSArray *currentTotal = [progress componentsSeparatedByString:@"/"];
		float currSlide = [[currentTotal objectAtIndex:0] floatValue];
		float totSlides = [[currentTotal objectAtIndex:1] floatValue];
		float currProgress = currSlide / totSlides;
		slideProgressBar.progress = currProgress;
	}
}

- (IBAction) doFooterButton {
	[webDisplayiPad stringByEvaluatingJavaScriptFromString:@"toggleFooter()"];
}

- (IBAction) doResetTimer {
	basetime = counter;
	timeElapsed.text = @"0";
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
