//
//  RootController.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/11/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootController : UITableViewController <UISplitViewControllerDelegate> {
	UISplitViewController *splitViewController;    
}

@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

@end
