//
//  ShowOffPadAppDelegate.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import "ShowOffPadAppDelegate.h"
#import "ShowOffPadViewController.h"
#import "ShowOffPadPresentController.h"
#import "NewFormController.h"
#import "RootController.h"

@implementation ShowOffPadAppDelegate

@synthesize window, extWindow;
@synthesize viewController, presentController, rootController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    	
	//Code to detect if an external display is connected to the iPad.
	NSLog(@"Number of screens: %d", [[UIScreen screens]count]);

	NSString *presoPath = [self ensurePresoPath];
	
	rootController = [[RootController alloc] 
						 initWithNibName:@"RootController" 
						 bundle:nil];
		
	presentController = [[ShowOffPadPresentController alloc] 
						 initWithNibName:@"ShowOffPadPresentController" 
						 bundle:nil];
	viewController.extDisplay = presentController;
	
	if([[UIScreen screens]count] > 1) //if there are more than 1 screens connected to the device
	{
		UIScreenMode *bestScreenMode;
		BOOL screenChoosen = FALSE;
		for(int i = 0; i < [[[[UIScreen screens] objectAtIndex:1] availableModes]count]; i++)
		{
			UIScreenMode *current = [[[[UIScreen screens]objectAtIndex:1]availableModes]objectAtIndex:i];
			if (!screenChoosen) {
				bestScreenMode = current;
			}
			if (current.size.width == 1024.0) {
				bestScreenMode = current;
			}
		}
		
		//Now we have the highest mode. Turn the external display to use that mode.
		UIScreen *external = [[UIScreen screens] objectAtIndex:1];
		external.currentMode = bestScreenMode;
		
		//Boom! Now the external display is set to the proper mode. We need to now set the screen of a new UIWindow to the external screen
		//extWindow = [[UIWindow alloc] init];
		extWindow = [[UIWindow alloc] initWithFrame:[external bounds]];

		[extWindow addSubview:presentController.view];
		[extWindow makeKeyAndVisible];
		
		extWindow.screen = external;
	}	
		
	// start the server	
	/*
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[ShowOffHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:presoPath]];
	[httpServer setPort:8082];
	
	NSError *error;
	if(![httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
	*/
	
    [window addSubview:rootController.view];
    [window makeKeyAndVisible];

	return YES;
}

- (NSString *) ensurePresoPath {
	NSArray *paths;
	NSString *presoPath = @"";
	
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	presoPath = [NSString stringWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"showoff"]];
	[presoPath retain];
	
	BOOL isDir;
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:presoPath isDirectory:&isDir] && isDir) {
		[fm createDirectoryAtPath:presoPath attributes:nil];
	}	
	return presoPath;
}	

- (void)dealloc {
    [viewController release];
    [presentController release];
    [window release];
    [extWindow release];
    [super dealloc];
}


@end
