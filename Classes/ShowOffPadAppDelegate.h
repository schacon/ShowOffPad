//
//  ShowOffPadAppDelegate.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowOffPadViewController;
@class ShowOffPadPresentController;
@class RootController;

@interface ShowOffPadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIWindow *extWindow;
    RootController *rootController;
    ShowOffPadViewController *viewController;
    ShowOffPadPresentController *presentController;
	UISplitViewController *splitViewController;
}

-(void)setupExternalScreen;
-(void)screenDidConnect:(NSNotification *)notification;
-(void)screenDidDisconnect:(NSNotification *)notification;
- (void)showPresentation:(NSString *)directory;
- (void)dismisPresentation;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIWindow *extWindow;
@property (nonatomic, retain) ShowOffPadViewController *viewController;
@property (nonatomic, retain) ShowOffPadPresentController *presentController;
@property (nonatomic, retain) RootController *rootController;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

- (NSString *) ensurePresoPath;

@end

