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
@synthesize lastPoint;
@synthesize maddenOn, mouseSwiped;
@synthesize currentColor;

- (void)setView:(ShowOffPadViewController *)theView {
	myView = theView;
}

#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    8

- (void)setMaddenOn {
	maddenOn = TRUE;
}

- (void)setMaddenOff {
	maddenOn = FALSE;
	self.image = nil;
	[myView mirrorMadden];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	lastPoint = [touch locationInView:self];
	if (maddenOn) {
		mouseSwiped = NO;
		
		if ([touch tapCount] == 2) {
			self.image = nil;
			[myView mirrorMadden];
			return;
		}
		
	}

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];   
	CGPoint currentPoint = [touch locationInView:self];

	if (maddenOn) {
		mouseSwiped = YES;
		
		
		UIGraphicsBeginImageContext(self.frame.size);
		[self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
		CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [self.currentColor CGColor]);
		CGContextBeginPath(UIGraphicsGetCurrentContext());
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		self.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[myView mirrorMadden];
		
		lastPoint = currentPoint;
	} else {		
		// To be a swipe, direction of touch must be horizontal and long enough.
		if (fabsf(lastPoint.x - currentPoint.x) >= HORIZ_SWIPE_DRAG_MIN &&
			fabsf(lastPoint.y - currentPoint.y) <= VERT_SWIPE_DRAG_MAX)
		{
			// It appears to be a swipe.
			if (lastPoint.x < currentPoint.x) {
				lastPoint = CGPointMake(0.0, 0.0);
				[myView doPrevButton];
			} else {
				lastPoint = CGPointMake(0.0, 0.0);
				[myView doNextButton];
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (maddenOn) {
		UITouch *touch = [touches anyObject];
		
		if ([touch tapCount] == 2) {
			self.image = nil;
			[myView mirrorMadden];
			return;
		}
		
		if(!mouseSwiped) {
			UIGraphicsBeginImageContext(self.frame.size);
			[self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
			CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
			CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
			CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
			CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
			CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
			CGContextStrokePath(UIGraphicsGetCurrentContext());
			CGContextFlush(UIGraphicsGetCurrentContext());
			self.image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
			[myView mirrorMadden];
		}
	} else {
		lastPoint = CGPointMake(0.0, 0.0);
		for (UITouch *touch in touches) {
			if (touch.tapCount >= 2) {
				[myView doNextButton];
			}
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)dealloc {
    [myView release];
    [currentColor release];
	[super dealloc];
}

@end
