//
//  ShowOffPadAppDelegate.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowOffPadViewController;

@interface ShowOffPadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ShowOffPadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ShowOffPadViewController *viewController;

@end

