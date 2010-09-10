//
//  FreemanOverlayManager.m
//  Freeman
//
//  Created by Matt Mower on 08/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FreemanOverlayManager.h"

#import "FreemanAppDelegate.h"
#import "FreemanModuleDatabase.h"
#import "FreemanModule.h"


@implementation FreemanOverlayManager

@synthesize delegate = _delegate;
@synthesize enabled = _enabled;

@synthesize searchString = _searchString;
@synthesize searchResults = _searchResults;

@synthesize searchField = _searchField;
@synthesize insertButton = _insertButton;
@synthesize resultsTable = _resultsTable;

- (id)initWithDelegate:(id)delegate {
	if( ( self = [self initWithWindowNibName:@"Overlay"] ) ) {
		_delegate = delegate;
	}
	
	return self;
}


- (void)windowDidLoad {
	[self addObserver:self forKeyPath:@"searchString" options:NSKeyValueObservingOptionNew context:NULL];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if( [keyPath isEqualToString:@"searchString"] ) {
		if( _searchThread ) {
			NSLog( @"Cancelling active search" );
			[_searchThread cancel];
		}
		
		_searchThread = [[NSThread alloc] initWithTarget:self selector:@selector(search:) object:nil];
		NSLog( @"Start new search for: %@", [self searchString] );
		[_searchThread start];
	}
}


- (void)prompt {
	[self setSearchString:@""];
	[self setSearchResults:[NSArray array]];
	
	[[self window] center];
	[[self window] setLevel:NSFloatingWindowLevel];
	[[self window] makeKeyAndOrderFront:self];
	[[self window] makeFirstResponder:[self searchField]];
	[NSApp activateIgnoringOtherApps:YES];
}


- (void)search:(id)object {
	if( ![self searchString] || [[self searchString] isEqualToString:@""] ) {
		[self setSearchResults:[NSArray array]];
	} else {
		NSLog( @"Search for %@", [self searchString] );
		[self setSearchResults:[[[self delegate] moduleDatabase] searchFor:[self searchString]]];
	}
	NSLog( @"Result count = %d", [[self searchResults] count] );
	if( [[self searchResults] count] > 0 ) {
		NSLog( @"Ask to select result 0" );
		dispatch_async( dispatch_get_main_queue(), ^{
			NSLog( @"Select result 0" );
			[[self resultsTable] selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
		} );
	}
}


- (IBAction)insertModule:(id)sender {
	if( [[self resultsTable] selectedRow] != -1 ) {
		FreemanModule *module = [[self searchResults] objectAtIndex:[[self resultsTable] selectedRow]];
		NSLog( @"Insert a %@", [module name] );
//		if( [_delegate respondsToSelector:@selector(insertModule:)] ) {
//			[_delegate insertModule:[[self searchField] stringValue]];
//		}
	}
	
}



@end
