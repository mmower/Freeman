//
//  FreemanCatalog.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanCatalog.h"

#import "FreemanModule.h"
#import "FreemanMenu.h"

#import "NSArray+Freeman.h"
#import "NSString+FreemanRanking.h"

@implementation FreemanCatalog

@synthesize name = _name;
@synthesize owner = _owner;
@synthesize contents = _contents;
@synthesize modules = _modules;


- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name {
	if( ( self = [super init] ) ) {
		_owner    = owner;
		_name     = name;
		_contents = [NSMutableArray array];
		_modules  = [NSMutableArray array];
	}
	
	return self;
}


- (void)catalogLoaded {
	_modules = [NSMutableArray array];
	
	[_contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[_modules addObjectsFromArray:[obj allModules]];
	}];
}


- (void)list {
	NSLog( @"Catalog: %@", [self name] );
	[_modules enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
		// NSLog( @"Module %@ %@", [obj name], [[obj navigationSequence] formatInGroupsOf:4] );
		}];
}


#pragma mark FreemanModularObject

- (NSUInteger)indexOfContent:(id<FreemanModularObject>)content {
	return [_contents indexOfObject:content];
}


// - (NSArray *)generateOwnerHierarchy {
// 	return [[[self owner] generateOwnerHierarchy] arrayByAddingObject:[self owner]];
// }


- (NSString *)path {
	return [self name];
}

- (BOOL)isModule {
	return NO;
}


- (NSString *)navigationSequence {
	NSMutableString *sequence = [NSMutableString string];
	[sequence appendString:[[self owner] navigationSequence]];
	for( int i = 0; i < [[self owner] indexOfContent:self]; i++ ) {
		[sequence appendString:@"D"];
	};
	[sequence appendString:@"R"];
	// NSLog( @"Catalog %@ navigation sequence: %@", [self name], sequence );
	return [sequence copy];
}


- (void)addContent:(id<FreemanModularObject>)content {
	if( [content isModule] ) {
		NSLog( @"Adding module: %@", [content name] );
	}
	[_contents addObject:content];
}


- (NSArray *)allModules {
	NSLog( @"FreemanCatalog -allModules" );
	NSMutableArray *modules = [NSMutableArray array];
	[[self contents] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
		if( [obj isModule] ) {
			NSLog( @"AllModule: %@", [obj name] );
			[modules addObject:obj];
		} else {
			[modules addObjectsFromArray:[obj allModules]];
		}
	}];
	return [modules copy];
}


@end
