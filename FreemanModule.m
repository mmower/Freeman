//
//  FreemanModule.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanModule.h"

#import "FreemanMenu.h"
#import "FreemanCatalog.h"
#import "FreemanRemoteProcess.h"

#import "NSArray+Freeman.h"

#define AUTO_INSERT	0

@interface FreemanModule (PrivateMethods)

// - (NSArray *)generateMenuHierarchy;
// - (NSString *)generateMenuPath;

@end


@implementation FreemanModule

@synthesize owner                    = _owner;
@synthesize catalog                  = _catalog;
@synthesize name                     = _name;
@synthesize scoreForLastAbbreviation = _scoreForLastAbbreviation;
// @synthesize path                 		= _path;
// @synthesize menuHierarchy            = _menuHierarchy;


- (id)initWithOwner:(id<FreemanModularObject>)owner catalog:(FreemanCatalog *)catalog name:(NSString *)name {
	if( ( self = [super init] ) ) {
		_owner                    = owner;
		_catalog                  = catalog;
		_name                     = name;
		_scoreForLastAbbreviation = 0.0;
		// _menuHierarchy            = nil;
		// _path                     = nil;
	}
	
	return self;
}


- (void)insertAt:(CGPoint)point inReaktorProcess:(FreemanRemoteProcess *)reaktorProcess {
	// Open the context menu
	[reaktorProcess sendRightMouseClick:point];
	
	// Navigate the menu hierarchy
	[reaktorProcess sendKeySequence:[self navigationSequence]];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"Freeman Module<%@> (%f)", [self name], [self scoreForLastAbbreviation]];
}


#pragma mark FreemanModularObject

- (NSArray *)contents {
	return [NSArray array];
}


- (NSUInteger)indexOfContent:(id<FreemanModularObject>)content {
	return NSNotFound;
}


- (BOOL)isModule {
	return YES;
}


- (void)addContent:(id<FreemanModularObject>)content {
	NSAssert( NO, @"Should never get here" );
}


- (NSArray *)allModules {
	return [NSArray array];
}


- (NSString *)navigationSequence {
	NSMutableString *sequence = [NSMutableString string];
	[sequence appendString:[[self owner] navigationSequence]];
	for( int i = 0; i < [[self owner] indexOfContent:self]; i++ ) {
		[sequence appendString:@"D"];
	}
	[sequence appendString:@"!"];
	return [sequence copy];
}


- (NSString *)menuPath {
	return [[self owner] path];
}


- (NSString *)path {
	return [[[self owner] path] stringByAppendingString:[NSString stringWithFormat:@" : %@", [self name]]];
}


@end
