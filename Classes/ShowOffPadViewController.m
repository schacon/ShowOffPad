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
#import <QuartzCore/QuartzCore.h>
#import "ShowOffPadAppDelegate.h"

@implementation ShowOffPadViewController

@synthesize webDisplayiPad, extDisplay;
@synthesize nextButton, prevButton, footerButton, notesArea, slideProgress, timeElapsed;
@synthesize slideProgressBar, timeProgress, totalTime, padStatus, touchyView;
@synthesize httpServer;
@synthesize maddenToggle;
@synthesize notesScrollView;
@synthesize blueSwatch;
@synthesize redSwatch;
@synthesize orangeSwatch;
@synthesize purpleSwatch;
@synthesize greenSwatch;
@synthesize yellowSwatch;
@synthesize swatchSelector;
@synthesize swatchHolder;
@synthesize swatchSelectorInside;

- (void)viewDidLoad {	
	[super viewDidLoad];
}

-(void)loadPresentation:(NSString *)directory {
	if (self.httpServer != nil) {
		[self.httpServer stopMongooseDaemon];
	}
	self.httpServer = [[[MongooseDaemon alloc] init] autorelease];
	[self.httpServer startMongooseDaemon:@"8085" documentRoot:directory];
	NSURL *url = [NSURL URLWithString:@"http://localhost:8085/index.html"];
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
	
	[self setupSwatches];
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

- (IBAction)closeAction {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Close presentation?" message:@"Clicking 'Yes' will stop the presentation" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
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

- (void)setupSwatches {
	self.swatchHolder.layer.cornerRadius = 8;
	self.swatchSelector.layer.cornerRadius = 6;
	self.swatchSelectorInside.layer.cornerRadius = 6;
	self.redSwatch.backgroundColor = [UIColor redColor];
	self.blueSwatch.backgroundColor = [UIColor blueColor];
	self.purpleSwatch.backgroundColor = [UIColor purpleColor];
	self.greenSwatch.backgroundColor = [UIColor greenColor];
	self.yellowSwatch.backgroundColor = [UIColor yellowColor];
	self.orangeSwatch.backgroundColor = [UIColor orangeColor];
	for (UIView *swatchView in [NSArray arrayWithObjects:self.redSwatch, self.blueSwatch, self.purpleSwatch, self.greenSwatch, self.yellowSwatch, self.orangeSwatch, nil]) {
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swatchSelected:)];
		[swatchView addGestureRecognizer:tapRecognizer];
		[tapRecognizer release];
		swatchView.layer.cornerRadius = 6;
	}
	[self setSwatchAsDefault:self.redSwatch];
}

-(void)swatchSelected:(UITapGestureRecognizer *)recognizer {
	[self setSwatchAsDefault:recognizer.view];
}

-(void)setSwatchAsDefault:(UIView *)view {
	self.touchyView.currentColor = view.backgroundColor;
	self.swatchSelector.frame = CGRectMake(view.frame.origin.x - 6, view.frame.origin.y - 6, self.swatchSelector.frame.size.width, self.swatchSelector.frame.size.height);
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

#pragma mark -
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		ShowOffPadAppDelegate *delegate = (ShowOffPadAppDelegate*)[[UIApplication sharedApplication] delegate];
		[delegate dismisPresentation];
	}
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
    [greenSwatch release];
    [blueSwatch release];
    [purpleSwatch release];
    [yellowSwatch release];
    [redSwatch release];
    [swatchHolder release];
    [orangeSwatch release];
    [swatchSelector release];
    [swatchSelectorInside release];
    [httpServer release];
    [super dealloc];
}

@end
