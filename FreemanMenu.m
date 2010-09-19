//
//  FreemanMenu.m
//  Freeman
//
//  Created by Matt Mower on 12/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanMenu.h"

#import "FreemanModule.h"

#import "NSArray+Freeman.h"
#import "NSString+FreemanRanking.h"


@implementation FreemanMenu

@synthesize owner    = _owner;
@synthesize name     = _name;
@synthesize contents = _contents;


- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name {
	if( ( self = [super init] ) ) {
		_owner    = owner;
		_name     = name;
		_contents = [NSMutableArray array];
	}
	
	return self;
}


- (NSString *)description {
	return [self name];
}


- (BOOL)isModule {
	return NO;
}


- (NSArray *)allModules {
	NSMutableArray *modules = [NSMutableArray array];
	for( FreemanModularObject *obj in [self contents] ) {
		if( [obj isModule] ) {
			[modules addObject:obj];
		} else {
			[modules addObjectsFromArray:[obj allModules]];
		}
	}
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
	
	for( int i = 0; i < [[self owner] indexOfContent:self]; i++ ) {
		[sequence appendString:@"D"];
	};
	[sequence appendString:@"R"];
	
	#ifdef DEBUG_FREEMAN
	NSLog( @"Menu %@ => %@", [self name], [sequence formatInGroupsOf:4] );
	#endif
	
	return [sequence copy];
}


- (void)addContent:(id<FreemanModularObject>)content {
	[_contents addObject:content];
}


- (NSUInteger)indexOfContent:(id<FreemanModularObject>)content {
	return [_contents indexOfObject:content];
}


- (BOOL)primary {
	return [[self owner] primary];
}


@end
