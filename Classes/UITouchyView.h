//
//  UITouchyView.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/10/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShowOffPadViewController;

@interface UITouchyView : UIImageView {
	ShowOffPadViewController *myView;
	CGPoint lastPoint;
	BOOL maddenOn;
	BOOL mouseSwiped;
	UIColor *currentColor;
}

@property(assign, readwrite) ShowOffPadViewController *myView;
@property(assign, readwrite) CGPoint lastPoint;
@property(assign, readwrite) BOOL maddenOn;
@property(assign, readwrite) BOOL mouseSwiped;
@property (nonatomic, retain) UIColor *currentColor;

- (void)setView:(ShowOffPadViewController *)theView;
- (void)setMaddenOn;
- (void)setMaddenOff;

@end
