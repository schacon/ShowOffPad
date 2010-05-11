//
//  NewFormController.h
//  ShowOffPad
//
//  Created by Scott Chacon on 5/11/10.
//  Copyright 2010 GitHub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"

@interface NewFormController : UIViewController {
	UIButton *goButton;
	UITextField *presName;
	UITextField *presUrl;
	
	UILabel *importStatus;
	UIActivityIndicatorView *importActivity;
	UIProgressView *importProgress;
	
	ASINetworkQueue *networkQueue;
	
	NSUInteger assetCount;
	NSString *presBasePath;
}

@property (retain) ASINetworkQueue *networkQueue;
@property (assign, readwrite) NSUInteger assetCount;
@property (retain) NSString *presBasePath;

@property (nonatomic, retain) IBOutlet UIButton *goButton;
@property (nonatomic, retain) IBOutlet UITextField *presName;
@property (nonatomic, retain) IBOutlet UITextField *presUrl;
@property (nonatomic, retain) IBOutlet UILabel *importStatus;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *importActivity;
@property (nonatomic, retain) IBOutlet UIProgressView *importProgress;

- (IBAction)importPres:(id) sender;

@end
