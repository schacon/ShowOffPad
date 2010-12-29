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
@synthesize splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
	//Code to detect if an external display is connected to the iPad.
	NSLog(@"Number of screens: %d", [[UIScreen screens]count]);

	NSString *presoPath = [self ensurePresoPath];
		
	viewController = [[ShowOffPadViewController alloc] 
					  initWithNibName:@"ShowOffPadViewController" 
					  bundle:nil];
	
	presentController = [[ShowOffPadPresentController alloc] 
						 initWithNibName:@"ShowOffPadPresentController" 
						 bundle:nil];
	viewController.extDisplay = presentController;

	[window addSubview:splitViewController.view];
	[window makeKeyAndVisible];
	[self setupExternalScreen];
	
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

	return YES;
}

- (void) showPresentation {
    
	CGRect contentRect = CGRectMake(0, 0, 1024, 748); 
	viewController.view.frame = contentRect; 
	[self.splitViewController.view addSubview:viewController.view];
    
	[self.splitViewController.view bringSubviewToFront:viewController.view];
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

-(void)setupExternalScreen {
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
		self.extWindow = [[[UIWindow alloc] initWithFrame:[external bounds]] autorelease];
		self.extWindow.screen = external;
        
		[self.extWindow addSubview:self.presentController.view];
		[self.extWindow makeKeyAndVisible];
	}
}

#pragma mark -
#pragma mark Screen Notifications
-(void)screenDidDisconnect:(NSNotification *)notification {
    self.extWindow = nil;
}

-(void)screenDidConnect:(NSNotification *)notification {
    [self setupExternalScreen];
}

- (void)dealloc {
    [viewController release];
    [presentController release];
    [window release];
    [extWindow release];
    [super dealloc];
}


@end
