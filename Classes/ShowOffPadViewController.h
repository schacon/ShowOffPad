//
//  ShowOffPadViewController.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowOffPadPresentController;

@interface ShowOffPadViewController : UIViewController {
	IBOutlet UIWebView *webDisplayiPad;
	ShowOffPadPresentController *extDisplay;
	UIButton *nextButton;
	UIButton *prevButton;
	UIButton *footerButton;
	UILabel  *notesArea;
	UILabel  *slideProgress;
	UILabel  *timeElapsed;
	UITextField  *totalTime;
	UIProgressView *slideProgressBar;
	UIProgressView *timeProgress;
	UILabel  *padStatus;
	int counter;
	int basetime;
}

@property(nonatomic,retain) UIWebView *webDisplayiPad;
@property(nonatomic,retain) ShowOffPadPresentController *extDisplay;

@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *footerButton;
@property (nonatomic, retain) IBOutlet UILabel  *notesArea;
@property (nonatomic, retain) IBOutlet UILabel  *slideProgress;
@property (nonatomic, retain) IBOutlet UILabel  *timeElapsed;
@property (nonatomic, retain) IBOutlet UITextField  *totalTime;
@property (nonatomic, retain) IBOutlet UIProgressView  *slideProgressBar;
@property (nonatomic, retain) IBOutlet UIProgressView  *timeProgress;
@property (nonatomic, retain) IBOutlet UILabel  *padStatus;

- (IBAction)doNextButton;
- (IBAction)doPrevButton;
- (IBAction)doFooterButton;
- (IBAction)doResetTimer;

- (void)setScreenStatus;
- (NSString *) sendJs:(NSString *)command;

- (void) updateProgress;
- (void)updateCounter:(NSTimer *)theTimer;

@end

