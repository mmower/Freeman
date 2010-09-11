//
//  FreemanNavigationStack.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanNavigationStack.h"

@implementation FreemanNavigationStack

@synthesize menuStack = _menuStack;
@synthesize sequenceStack = _sequenceStack;
@synthesize navigationSequence = _navigationSequence;
@synthesize currentMenuLength = _currentMenuLength;


- (id)init {
	if( ( self = [super init] ) ) {
		_menuStack          = [NSMutableArray array];
		_sequenceStack      = [NSMutableArray array];
		_currentMenuLength  = 0;
		_navigationSequence = [NSMutableString stringWithCapacity:20];
	}
	
	return self;
}


- (void)enterMenu:(NSString *)name {
	[_menuStack addObject:name];
	[_sequenceStack addObject:[_navigationSequence mutableCopy]];
	[_navigationSequence appendString:@"R"];
	NSLog( @"enterMenu(%@) navigationSequence=(%@)", name, _navigationSequence );
}

- (void)exitMenu {
	[_menuStack removeLastObject];
	_navigationSequence = [_sequenceStack objectAtIndex:([_sequenceStack count]-1)];
	[_navigationSequence appendString:@"D"];
	[_sequenceStack removeLastObject];	
	NSLog( @"exitMenu navigationSequence=(%@)", _navigationSequence );
}

- (void)addedModule {
	[_navigationSequence appendString:@"D"];
	NSLog( @"addedModule navigationSequence=(%@)", _navigationSequence );
}


@end
