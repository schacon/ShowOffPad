//
//  UITouchyView.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/10/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShowOffPadViewController;

@interface UITouchyView : UIView {
	ShowOffPadViewController *myView;
}

@property(assign, readwrite) ShowOffPadViewController *myView;

- (void)setView:(ShowOffPadViewController *)theView;

@end
