//
//  FreemanMenu.m
//  Freeman
//
//  Created by Matt Mower on 12/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanMenu.h"

#import "FreemanModule.h"

#import "NSString+FreemanRanking.h"


@implementation FreemanMenu

@synthesize owner    = _owner;
@synthesize name     = _name;
@synthesize contents = _contents;
// @synthesize subMenus           = _subMenus;
// @synthesize modules            = _modules;
// @synthesize navigationSequence = _navigationSequence;


- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name {
	if( ( self = [super init] ) ) {
		_owner    = owner;
		_name     = name;
		_contents = [NSMutableArray array];
		// _subMenus           = [NSMutableArray array];
		// _modules            = [NSMutableArray array];
		// _navigationSequence = nil;
	}
	
	return self;
}


- (NSString *)description {
	return [self name];
}


// - (void)addSubMenu:(FreemanMenu *)menu {
// 	[menu setParent:self];
// 	[_subMenus addObject:menu];
// 	[_contents addObject:menu];
// }
// 
// 
// - (void)addModule:(FreemanModule *)module {
// 	[module setMenu:self];
// 	[_modules addObject:module];
// 	[_contents addObject:module];
// }


- (BOOL)isModule {
	return NO;
}


- (NSArray *)allModules {
	NSMutableArray *modules = [NSMutableArray array];
	[[self contents] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
		if( [obj isModule] ) {
			[modules addObject:obj];
		} else {
			[modules addObjectsFromArray:[obj allModules]];
		}
	}];
	return [modules copy];
}


- (NSString *)path {
	if( [self owner] ) {
		return [[[self owner] path] stringByAppendingString:[NSString stringWithFormat:@" : %@", [self name]]];
	} else {
		return [self name];
	}
}

- (NSString *)navigationSequence {
	NSMutableString *sequence = [NSMutableString string];
	[sequence appendString:[[self owner] navigationSequence]];
	
	// if( [[self name] isEqualToString:@"Effects"] ) {
	// 	NSLog( @"Menu: %@", [self name] );
	// 	NSLog( @"Owner: %@", [self owner] );
	// 	NSLog( @"Index: %d", [[self owner] indexOfContent:self] );
	// 	NSLog( @"Array: %@", [[[self owner] contents] subarrayWithRange:NSMakeRange(0,[[self owner] indexOfContent:self])] );
	// }
	
	for( int i = 0; i < [[self owner] indexOfContent:self]; i++ ) {
		[sequence appendString:@"D"];
	};
	[sequence appendString:@"R"];
	NSLog( @"Menu %@ navigation sequence: %@", [self name], [sequence formatInGroupsOf:4] );
	return [sequence copy];
}


// - (NSArray *)generateOwnerHierarchy {
// 	return [[[self owner] generateOwnerHierarchy] arrayByAddingObject:[self owner]];
// }


- (void)addContent:(id<FreemanModularObject>)content {
	[_contents addObject:content];
}


- (NSUInteger)indexOfContent:(id<FreemanModularObject>)content {
	return [_contents indexOfObject:content];
}

@end
