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
}

@property(nonatomic,retain) UIWebView *mainView;

@end
