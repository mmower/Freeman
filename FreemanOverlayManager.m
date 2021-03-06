//
//  FreemanOverlayManager.m
//  Freeman
//
//  Created by Matt Mower on 08/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import "FreemanOverlayManager.h"

#import "FreemanAppDelegate.h"
#import "FreemanModuleDatabase.h"
#import "FreemanModule.h"
#import "FreemanResultsView.h"
#import "FreemanSearchField.h"
#import "FreemanFieldEditor.h"

#import "NSScreen+Freeman.h"

@interface FreemanOverlayManager (PrivateMethods)

- (void)selectPreviousResult;
- (void)selectNextResult;
- (void)closeAndInsertModule:(FreemanModule *)module;
- (FreemanModule *)selectedModule;

@end


@implementation FreemanOverlayManager

@synthesize delegate = _delegate;
@synthesize enabled = _enabled;

@synthesize moduleDatabase = _moduleDatabase;

@synthesize searchString = _searchString;
@synthesize searchResults = _searchResults;

@synthesize searchField = _searchField;
@synthesize resultsTable = _resultsTable;

- (id)initWithDelegate:(id)delegate {
	if( ( self = [self initWithWindowNibName:@"Overlay"] ) ) {
		_delegate = delegate;
		_moduleDatabase = nil;
	}
	
	return self;
}


- (void)windowDidLoad {
	[self addObserver:self forKeyPath:@"searchString" options:NSKeyValueObservingOptionNew context:NULL];
	[[self resultsTable] setOverlayManager:self];
	[[self searchField] setDelegate:self];
	[[self searchField] setOverlayManager:self];
}


- (void)windowWillClose:(NSNotification *)notification {
	[[self delegate] activateReaktor];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if( [keyPath isEqualToString:@"searchString"] ) {
		if( _searchThread ) {
			#ifdef DEBUG_FREEMAN
			NSLog( @"Cancelling active search" );
			#endif
			[_searchThread cancel];
		}
		
		_searchThread = [[NSThread alloc] initWithTarget:self selector:@selector(search:) object:nil];
		#ifdef DEBUG_FREEMAN
		NSLog( @"Start new search for: %@", [self searchString] );
		#endif
		[_searchThread start];
	}
}


- (void)searchModules:(FreemanModuleDatabase *)moduleDatabase fromPoint:(CGPoint)point {
	[self setModuleDatabase:moduleDatabase];
	
	[self setSearchString:@""];
	[self setSearchResults:[NSArray array]];
	
	CGPoint flipped = [[NSScreen mainScreen] flipPoint:point];
	NSPoint topLeft = NSMakePoint( flipped.x, flipped.y );
	
	[[self window] setFrameTopLeftPoint:topLeft];
	[[self window] setLevel:NSFloatingWindowLevel];
	[[self window] makeKeyAndOrderFront:self];
	[[self window] makeFirstResponder:[self searchField]];
	[NSApp activateIgnoringOtherApps:YES];
}


- (void)closeAndActivateReaktor {
	[self close];
	// [[self delegate] activateReaktor];
}


- (void)updateSearchResults:(id)results {
	[self setSearchResults:results];
	if( [results count] > 0 ) {
		[[self resultsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
	}
}


- (void)search:(id)object {
	if( ![self searchString] || [[self searchString] isEqualToString:@""] ) {
		[self performSelectorOnMainThread:@selector(updateSearchResults:) withObject:[NSArray array] waitUntilDone:NO];
		return;
	} else {
		#ifdef DEBUG_FREEMAN
		NSLog( @"Search for %@", [self searchString] );
		#endif
		
		NSArray *results = [_moduleDatabase searchFor:[self searchString]];
		if( [results count] > 0 && ![[NSThread currentThread] isCancelled] ) {
			[self performSelectorOnMainThread:@selector(updateSearchResults:) withObject:results waitUntilDone:NO];
		}
	}
}


- (void)selectPreviousResult {
	int currentRow = [[self resultsTable] selectedRow];
	if( currentRow > 0 ) {
		[[self resultsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:(currentRow-1)] byExtendingSelection:NO];
		[[self resultsTable] scrollRowToVisible:(currentRow-1)];
	}
}


- (void)selectNextResult {
	int currentRow = [[self resultsTable] selectedRow];
	if( currentRow < ([[self searchResults] count]-1) ) {
		[[self resultsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:(currentRow+1)] byExtendingSelection:NO];
		[[self resultsTable] scrollRowToVisible:(currentRow+1)];
	}
}


- (void)setFavourite:(NSUInteger)favourite {
	int currentRow = [[self resultsTable] selectedRow];
	if( currentRow > -1 ) {
		[self close];
		[_delegate setFavourite:[self selectedModule] inSlot:favourite];
		[self closeAndInsertModule:[self selectedModule]];
	}
}


- (FreemanModule *)selectedModule {
	return [[self searchResults] objectAtIndex:[[self resultsTable] selectedRow]];
}


- (IBAction)insertModule:(id)sender {
	if( [[self resultsTable] selectedRow] != -1 ) {
		[self closeAndInsertModule:[self selectedModule]];
	}
}


- (void)closeAndInsertModule:(FreemanModule *)module {
	[self close];
	if( [_delegate respondsToSelector:@selector(insertModule:)] ) {
		[_delegate insertModule:module];
	}
}


#pragma mark NSTextField delegate

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
	if( commandSelector == @selector(moveUp:) ) {
		[self selectPreviousResult];
	} else if( commandSelector == @selector(moveDown:) ) {
		[self selectNextResult];
	} else if( commandSelector == @selector(insertNewline:) ) {
		[self insertModule:self];
	} else if( commandSelector == @selector(cancelOperation:) ) {
		[self closeAndActivateReaktor];
	} else {
		#ifdef DEBUG_FREEMAN
		NSLog( @"Unregistered selector: %@", NSStringFromSelector(commandSelector));
		#endif
		return NO;
	}
	return YES;
}


#pragma mark NSWindow delegate

- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)object {
	if( [object isKindOfClass:[NSTextField class]] ) {
		if( !_fieldEditor ) {
			_fieldEditor = [[FreemanFieldEditor alloc] init];
			[_fieldEditor setOverlayManager:self];
			[_fieldEditor setFieldEditor:YES];
		}
		return _fieldEditor;
	}
	return nil;
}


@end
