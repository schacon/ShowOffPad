//
//  ShowOffPadViewController.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import "ShowOffPadViewController.h"
#import "ShowOffPadPresentController.h"
#import "UITouchyView.h"

@implementation ShowOffPadViewController

@synthesize webDisplayiPad, extDisplay;
@synthesize nextButton, prevButton, footerButton, notesArea, slideProgress, timeElapsed;
@synthesize slideProgressBar, timeProgress, totalTime, padStatus, touchyView;
@synthesize maddenToggle;
@synthesize notesScrollView;

- (void)viewDidLoad {	
	//NSString *urlAddress = @"http://localhost:9090";
	NSString *urlAddress = @"http://showofftest.heroku.com/";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webDisplayiPad loadRequest:requestObj];
	[extDisplay.mainView loadRequest:requestObj];

	counter = 0;
	basetime = 0;

	[touchyView setView:self];
	 
	[NSTimer scheduledTimerWithTimeInterval:60.0f
									 target:self
								   selector:@selector(updateCounter:)
								   userInfo:nil
									repeats:YES];
	[self setScreenStatus];
	
	[super viewDidLoad];
}

- (void)setScreenStatus {
	NSString *screenStatus = @"";
	if([[UIScreen screens]count] > 1) //if there are more than 1 screens connected to the device
	{
		for(int i = 0; i < [[[[UIScreen screens] objectAtIndex:1] availableModes]count]; i++)
		{
			UIScreenMode *current = [[[[UIScreen screens]objectAtIndex:1]availableModes]objectAtIndex:i];
			if (current.size.width == 1024.0) {
				screenStatus = [screenStatus stringByAppendingFormat:@"* %5.0f,%5.0f\n", current.size.width, current.size.height];
			} else {
				screenStatus = [screenStatus stringByAppendingFormat:@"  %5.0f,%5.0f\n", current.size.width, current.size.height];
			}
		}
	}
	
	padStatus.text = screenStatus;
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
	[self sendJs:@"nextStep()"];
	[self populateNotes];
	[self updateProgress];
}

- (void)populateNotes {
	NSString *output = [self.webDisplayiPad stringByEvaluatingJavaScriptFromString:@"getCurrentNotes()"];
	if (output) {
		self.notesArea.text = output;
	}
	CGSize notesSize = [self.notesArea.text sizeWithFont:self.notesArea.font constrainedToSize:CGSizeMake(self.notesScrollView.frame.size.width, 10000)];
	float notesX = 0;
	float notesY = 0;
	if (notesSize.height < self.notesScrollView.frame.size.height) {
		notesY = (self.notesScrollView.frame.size.height - notesSize.height)/2;
		notesX = (self.notesScrollView.frame.size.width - notesSize.width)/2;
	}
	self.notesArea.frame = CGRectMake(notesX, notesY, notesSize.width, notesSize.height);
	self.notesScrollView.contentSize = notesSize;
}

- (NSString *) sendJs:(NSString *)command {
	[extDisplay.mainView stringByEvaluatingJavaScriptFromString:command];
	return [webDisplayiPad stringByEvaluatingJavaScriptFromString:command];
}

- (void) mirrorMadden {
	extDisplay.overlay.image = touchyView.image;
}

- (IBAction) doPrevButton {
	[self sendJs:@"prevStep()"];
	[self populateNotes];
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
	[self sendJs:@"toggleFooter()"];
}

- (IBAction) doResetTimer {
	basetime = counter;
	timeElapsed.text = @"0";
}

- (IBAction) doToggleMadden:(id) sender {
	if (maddenToggle.on) {
		[touchyView setMaddenOn];
	} else {
		[touchyView setMaddenOff];
	}
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

#pragma mark -
#pragma mark Web View Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self populateNotes];
}

- (void)dealloc {
    [prevButton release];
    [padStatus release];
    [touchyView release];
    [timeProgress release];
    [footerButton release];
    [timeElapsed release];
    [extDisplay release];
    [slideProgress release];
    [slideProgressBar release];
    [webDisplayiPad release];
    [nextButton release];
    [totalTime release];
    [notesArea release];
    [maddenToggle release];
    [notesScrollView release];
    [super dealloc];
}

@end
