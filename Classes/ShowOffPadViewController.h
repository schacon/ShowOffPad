//
//  ShowOffPadViewController.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITouchyView.h"

@class ShowOffPadPresentController;

@interface ShowOffPadViewController : UIViewController <UIWebViewDelegate> {
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
	UILabel   *padStatus;
	UISwitch  *maddenToggle;
	UIScrollView *notesScrollView;
	UIView *blueSwatch;
	UIView *redSwatch;
	UIView *orangeSwatch;
	UIView *purpleSwatch;
	UIView *greenSwatch;
	UIView *yellowSwatch;
	UIView *swatchSelector;
	UIView *swatchHolder;
	UIView *swatchSelectorInside;
	UITouchyView *touchyView;
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
@property (nonatomic, retain) IBOutlet UITouchyView  *touchyView;
@property (nonatomic, retain) IBOutlet UISwitch  *maddenToggle;
@property (nonatomic, retain) IBOutlet UIScrollView *notesScrollView;
@property (nonatomic, retain) IBOutlet UIView *blueSwatch;
@property (nonatomic, retain) IBOutlet UIView *redSwatch;
@property (nonatomic, retain) IBOutlet UIView *orangeSwatch;
@property (nonatomic, retain) IBOutlet UIView *purpleSwatch;
@property (nonatomic, retain) IBOutlet UIView *greenSwatch;
@property (nonatomic, retain) IBOutlet UIView *yellowSwatch;
@property (nonatomic, retain) IBOutlet UIView *swatchSelector;
@property (nonatomic, retain) IBOutlet UIView *swatchHolder;
@property (nonatomic, retain) IBOutlet UIView *swatchSelectorInside;

- (IBAction)doNextButton;
- (IBAction)doPrevButton;
- (IBAction)doFooterButton;
- (IBAction)closeAction;
- (IBAction)doResetTimer;
- (IBAction)doToggleMadden:(id) sender;

- (void)setScreenStatus;
- (void)mirrorMadden;
- (void)populateNotes;
- (void)setupSwatches;
-(void)setSwatchAsDefault:(UIView *)view;

- (NSString *) sendJs:(NSString *)command;

- (void) updateProgress;
- (void)updateCounter:(NSTimer *)theTimer;

@end

