//
//  ShowOffPadPresentController.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/10/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowOffPadPresentController : UIViewController {
	IBOutlet UIWebView *mainView;
	IBOutlet UIImageView *overlay;
}

@property(assign, readwrite) UIWebView *mainView;
@property(assign, readwrite) UIImageView *overlay;

@end
