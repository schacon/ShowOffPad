//
//  ShowOffPadViewController.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/5/10.
//  Copyright GitHub 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowOffPadViewController : UIViewController {
  IBOutlet UIWebView *webDisplayiPad;
  UIButton *nextButton;
  UIButton *prevButton;
  UILabel *notesArea;
}

@property(nonatomic,retain) UIWebView *webDisplayiPad;

@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UILabel  *notesArea;

- (IBAction)doNextButton;
- (IBAction)doPrevButton;

@end

