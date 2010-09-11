//
//  FreemanCatalog.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanCatalog.h"

#import "FreemanModule.h"
#import "FreemanNavigationStack.h"


@implementation FreemanCatalog

@synthesize name = _name;
@synthesize modules = _modules;
@synthesize navigationSequence = _navigationSequence;

- (id)initWithName:(NSString *)name {
	if( ( self = [super init] ) ) {
		_name            = name;
		_modules         = [NSMutableArray array];
		_navigationStack = [[FreemanNavigationStack alloc] init];
	}
	
	return self;
}


- (void)catalogLoaded {
	_navigationStack = nil;
}


- (void)openMenu:(NSDictionary *)attributes {
	[_navigationStack enterMenu:[attributes objectForKey:@"name"]];
}


- (void)addModule:(NSDictionary *)attributes {
	[_modules addObject:[[FreemanModule alloc] initWithName:[attributes objectForKey:@"name"]
                                                  catalog:self
                                       navigationSequence:[[_navigationStack navigationSequence] copy]
                                            menuHierarchy:[[_navigationStack menuStack] copy]]];
	[_navigationStack addedModule];
}


- (void)closeMenu {
	[_navigationStack exitMenu];
}

- (void)list {
	NSLog( @"Catalog: %@", [self name] );
	NSLog( @" ns = %@", [self navigationSequence] );
	[_modules enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
		NSLog( @"Module %@ Sequence %@ / %@", [obj name], [obj navigationSequence], [obj completeNavigationSequence] );
		
		}];
}


@end
