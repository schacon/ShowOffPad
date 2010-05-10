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

@implementation ShowOffPadAppDelegate

@synthesize window, extWindow;
@synthesize viewController, presentController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    	
	//Code to detect if an external display is connected to the iPad.
	NSLog(@"Number of screens: %d", [[UIScreen screens]count]);
	
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
		
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	
	return YES;
}

- (void)dealloc {
    [viewController release];
    [presentController release];
    [window release];
    [extWindow release];
    [super dealloc];
}


@end
