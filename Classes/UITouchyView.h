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
	CGPoint startTouchPosition;
}

@property(assign, readwrite) ShowOffPadViewController *myView;
@property(assign, readwrite) CGPoint startTouchPosition;

- (void)setView:(ShowOffPadViewController *)theView;

@end
