//
//  FreemanOverlayManager.h
//  Freeman
//
//  Created by Matt Mower on 08/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Foundation/Foundation.h>

@class FreemanModuleDatabase;
@class FreemanResultsView;
@class FreemanSearchField;
@class FreemanFieldEditor;

@interface FreemanOverlayManager : NSWindowController {
	id										_delegate;
	BOOL									_enabled;
	
	NSString							*_searchString;
	NSArray								*_searchResults;
	
	FreemanModuleDatabase	*_moduleDatabase;
	
	FreemanSearchField		*_searchField;
	FreemanResultsView		*_resultsTable;
	FreemanFieldEditor		*_fieldEditor;
	
	NSThread							*_searchThread;
}

@property (assign) id delegate;
@property (assign) BOOL enabled;

@property (assign) FreemanModuleDatabase *moduleDatabase;
@property (assign) NSString *searchString;
@property (assign) NSArray *searchResults;

@property (assign) IBOutlet FreemanSearchField *searchField;
@property (assign) IBOutlet FreemanResultsView *resultsTable;

- (id)initWithDelegate:(id)delegate;

- (void)searchModules:(FreemanModuleDatabase *)moduleDatabase fromPoint:(CGPoint)point;
- (void)closeAndActivateReaktor;
- (void)setFavourite:(NSUInteger)favourite;

- (IBAction)insertModule:(id)sender;

@end
