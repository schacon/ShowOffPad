//
//  UITouchyView.m
//  ShowOffPad
//
//  Created by Scott Chacon on 5/10/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import "UITouchyView.h"
#import "ShowOffPadViewController.h"

@implementation UITouchyView

@synthesize myView;
@synthesize startTouchPosition;

- (void)setView:(ShowOffPadViewController *)theView {
	myView = theView;
}

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    8

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    // startTouchPosition is an instance variable
    startTouchPosition = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
	
    // To be a swipe, direction of touch must be horizontal and long enough.
    if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
        fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
    {
        // It appears to be a swipe.
        if (startTouchPosition.x < currentTouchPosition.x) {
			startTouchPosition = CGPointMake(0.0, 0.0);
			[myView doPrevButton];
        } else {
			startTouchPosition = CGPointMake(0.0, 0.0);
			[myView doNextButton];
		}
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    startTouchPosition = CGPointMake(0.0, 0.0);
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            NSLog(@"NEXTY");
			[myView doNextButton];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
