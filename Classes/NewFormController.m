    //
//  NewFormController.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/11/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import "NewFormController.h"
#import "ASIHTTPRequest.h"

@implementation NewFormController

@synthesize goButton, presName, presUrl;
@synthesize importStatus, importActivity, importProgress;
@synthesize networkQueue, assetCount, presBasePath;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)importPres:(id) sender {
	importProgress.progress = 0.0;
	[importActivity startAnimating];

	importActivity.hidden = FALSE;
	importProgress.hidden = FALSE;
	importStatus.hidden = FALSE;
	
	NSString *uriBase = self.presUrl.text;
	NSString *assets = [uriBase stringByAppendingString:@"assets_needed"];
	NSURL *url = [NSURL URLWithString:assets];
		
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];

	NSError *error = [request error];
	if (!error) {
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

		NSString *pbPath = @"";
		pbPath = [NSString stringWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"showoff"]];
		NSString *presNameStr = presName.text;
		presBasePath = [pbPath stringByAppendingPathComponent:presNameStr];
		[presBasePath retain];
		
		NSString *response = [request responseString];
		NSArray *assetsNeeded = [response componentsSeparatedByString:@"\n"];
		NSLog(@"FU: %@", assetsNeeded);
		assetCount = [assetsNeeded count];
		
		// Stop anything already in the queue before removing it
		[[self networkQueue] cancelAllOperations];
		
		// Creating a new queue each time we use it means we don't have to worry about clearing delegates or resetting progress tracking
		[self setNetworkQueue:[ASINetworkQueue queue]];
		[[self networkQueue] setDelegate:self];
		[[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
		[[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
		[[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
			
		NSEnumerator *enumerator = [assetsNeeded objectEnumerator];
		NSString *anAsset;
		NSString *assetUrl;
		
		while (anAsset = [enumerator nextObject]) {
			assetUrl = [uriBase stringByAppendingString:anAsset];
			url = [NSURL URLWithString:assetUrl];
			ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
			[[self networkQueue] addOperation:request];
		}
		
		[[self networkQueue] go];
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *response = [request responseString];
	
	NSData* aData;
	aData = [response dataUsingEncoding: NSASCIIStringEncoding];
	
	NSString *base = [[request url] path];
	if ([base isEqualToString:@"/index"]) {
		base = @"/index.html";
	}
	NSString *filePath = [presBasePath stringByAppendingPathComponent:base];
	NSError *error;
	NSFileManager *fm = [NSFileManager defaultManager];
	
	NSString *dirPath = [filePath stringByDeletingLastPathComponent];
	[fm createDirectoryAtPath:dirPath withIntermediateDirectories:TRUE attributes:nil error:&error];
	[fm createFileAtPath:filePath contents:aData attributes:nil];

	NSLog(@"FU: %@", filePath);
	importStatus.text = [NSString stringWithFormat:@"Downloading %@", base];
	
	int reqCount = [[self networkQueue] requestsCount];
	float left = (int)assetCount - reqCount;
	float done = left / (float)assetCount;
	importProgress.progress = done;
	NSLog(@"FU: %5.2f", done);

	if ([[self networkQueue] requestsCount] == 0) {
		
		// Since this is a retained property, setting it to nil will release it
		// This is the safest way to handle releasing things - most of the time you only ever need to release in your accessors
		// And if you an Objective-C 2.0 property for the queue (as in this example) the accessor is generated automatically for you
		[self setNetworkQueue:nil]; 
	}
	
	//... Handle success
	NSLog(@"Request finished");
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil]; 
	}
	
	//... Handle failure
	NSLog(@"Request failed");
}


- (void)queueFinished:(ASINetworkQueue *)queue
{
	// You could release the queue here if you wanted
	if ([[self networkQueue] requestsCount] == 0) {
		[self setNetworkQueue:nil]; 
	}
	NSLog(@"Queue finished");
	
	[importActivity stopAnimating];
	importActivity.hidden = TRUE;
	importProgress.hidden = TRUE;
	importStatus.hidden = TRUE;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PresentationDownloaded" object:nil];
}

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[networkQueue release];
    [super dealloc];
}


@end
