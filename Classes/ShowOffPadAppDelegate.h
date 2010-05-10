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

@interface ShowOffPadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIWindow *extWindow;
    ShowOffPadViewController *viewController;
    ShowOffPadPresentController *presentController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIWindow *extWindow;
@property (nonatomic, retain) IBOutlet ShowOffPadViewController *viewController;
@property (nonatomic, retain) IBOutlet ShowOffPadPresentController *presentController;

@end

