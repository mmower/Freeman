//
//  FreemanOverlayManager.h
//  Freeman
//
//  Created by Matt Mower on 08/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FreemanResultsView;

@interface FreemanOverlayManager : NSWindowController <NSTextFieldDelegate> {
	id									_delegate;
	BOOL								_enabled;
	
	NSString						*_searchString;
	NSArray							*_searchResults;
	
	NSTextField					*_searchField;
	FreemanResultsView	*_resultsTable;
	
	NSThread						*_searchThread;
}

@property (assign) id delegate;
@property (assign) BOOL enabled;

@property (assign) NSString *searchString;
@property (assign) NSArray *searchResults;

@property (assign) IBOutlet NSTextField *searchField;
@property (assign) IBOutlet FreemanResultsView *resultsTable;

- (id)initWithDelegate:(id)delegate;

- (void)prompt;
- (void)closeAndActivateReaktor;

- (IBAction)insertModule:(id)sender;

@end
