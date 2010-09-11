//
//  FreemanModuleDatabase.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanModuleDatabase.h"

#import "FreemanXMLCatalog.h"
#import "FreemanDiskCatalog.h"
#import "FreemanModule.h"

#import "NSString+FreemanRanking.h"


@interface FreemanModuleDatabase (PrivateMethods)

- (NSString *)catalogNavigationSequence;

@end


@implementation FreemanModuleDatabase


- (id)init {
	if( ( self = [super init] ) ) {
		_catalogs = [NSMutableArray array];
		_modules = [NSMutableArray array];
		[self addCatalog:[[FreemanXMLCatalog alloc] initWithName:@"Built-In Module"
		                                                 catalogFile:[[NSBundle mainBundle] pathForResource:@"modules" ofType:@"xml"]]];
		[self addCatalog:[[FreemanDiskCatalog alloc] initWithName:@"Core Cell"
                                                 fromRootPath:@"/Volumes/Corrino/NativeInstruments/Reaktor 5/Library/Core Cells"
                                                 withFileType:@"rcc"]];
		[self addCatalog:[[FreemanDiskCatalog alloc] initWithName:@"Macro"
                                                 fromRootPath:@"/Volumes/Corrino/NativeInstruments/Reaktor 5/Library/Macros"
                                                 withFileType:@"mdl"]];
	}
	
	return self;
}


- (void)addCatalog:(FreemanCatalog *)catalog {
	NSLog( @"Set catalog navigation sequence = %@", [self catalogNavigationSequence] );
	[catalog setNavigationSequence:[self catalogNavigationSequence]];
	[_catalogs addObject:catalog];
	[_modules addObjectsFromArray:[catalog modules]];
	[catalog list];
}


- (NSArray *)searchFor:(NSString *)query {
	[_modules enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj setScoreForLastAbbreviation:[[obj name] scoreForAbbreviation:query]];
	}];
	
	NSArray *possibleMatches = [_modules filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^(id obj, NSDictionary *bindings) {
		return (BOOL)([obj scoreForLastAbbreviation] > 0.0);
	}]];
	
	
	return [possibleMatches sortedArrayUsingComparator:^(id a, id b) {
		if( [a scoreForLastAbbreviation] > [b scoreForLastAbbreviation] ) {
			return (NSComparisonResult)NSOrderedAscending;
		} else if( [a scoreForLastAbbreviation] < [b scoreForLastAbbreviation] ) {
			return (NSComparisonResult)NSOrderedDescending;
		} else {
			return (NSComparisonResult)NSOrderedSame;
		}
	}];
}


- (NSString *)catalogNavigationSequence {
	NSMutableString *sequence = [NSMutableString stringWithCapacity:10];
	[sequence appendString:@"R"];
	for( int i = 0; i < [_catalogs count]; i++ ) {
		[sequence appendString:@"D"];
	}
	return [sequence copy];	
}

@end
