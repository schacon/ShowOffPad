//
//  RootController.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/11/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootController : UIViewController {
	UIBarButtonItem *newButton;
	UIView *mainView;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *newButton;
@property (nonatomic, retain) IBOutlet UIView *mainView;

@end
