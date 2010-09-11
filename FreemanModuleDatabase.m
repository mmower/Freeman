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
- (NSURL *)reaktorLibraryPath;
- (NSDictionary *)reaktorPreferences;

@end


@implementation FreemanModuleDatabase


- (id)init {
	if( ( self = [super init] ) ) {
		_catalogs = [NSMutableArray array];
		_modules = [NSMutableArray array];
		
		NSURL *reaktorContentURL = [self reaktorLibraryPath];
		NSLog( @"Reaktor content should be at: %@", [reaktorContentURL absoluteString] );
		
		[self addCatalog:[[FreemanXMLCatalog alloc] initWithName:@"Built-In Module"
		                                                 catalogFile:[[NSBundle mainBundle] pathForResource:@"modules" ofType:@"xml"]]];
		[self addCatalog:[[FreemanDiskCatalog alloc] initWithName:@"Core Cell"
                                                 fromRootPath:[[reaktorContentURL URLByAppendingPathComponent:@"Core Cells"] path] // @"/Volumes/Corrino/NativeInstruments/Reaktor 5/Library/Core Cells"
                                                 withFileType:@"rcc"]];
		[self addCatalog:[[FreemanDiskCatalog alloc] initWithName:@"Macro"
		                                                 fromRootPath:[[reaktorContentURL URLByAppendingPathComponent:@"Macros"] path] // @"/Volumes/Corrino/NativeInstruments/Reaktor 5/Library/Macros"
		                                                 withFileType:@"mdl"]];

		// This was toll-free bridge from a CFURLRef so we're still responsible for it
		[reaktorContentURL release];
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


- (NSURL *)reaktorLibraryPath {
	NSDictionary *reaktorPreferences = [self reaktorPreferences];
	NSString *reaktorLibraryHFSPath = [reaktorPreferences objectForKey:@"SystemContentDir"];
	NSAssert( reaktorLibraryHFSPath, @"SystemContentDir could not be found in Reaktor preferences" );
	return (NSURL *)CFURLCreateWithFileSystemPath( kCFAllocatorDefault, (CFStringRef)reaktorLibraryHFSPath, kCFURLHFSPathStyle, true );
}


- (NSDictionary *)reaktorPreferences {
	BOOL isDirectory;

	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSLocalDomainMask, YES );
	NSAssert1( [paths count] == 1, @"Should have found one Library folder but found %d", [paths count] );
	
	NSString *libraryFolderPath = [paths objectAtIndex:0];
	NSAssert1( [[NSFileManager defaultManager] fileExistsAtPath:libraryFolderPath isDirectory:&isDirectory], @"Library folder path does not exist at: %@", libraryFolderPath );
	NSAssert1( isDirectory, @"Library folder path at %@ is not a folder", libraryFolderPath );
	
	NSString *prefsFolderPath = [libraryFolderPath stringByAppendingPathComponent:@"Preferences"];
	NSAssert1( [[NSFileManager defaultManager] fileExistsAtPath:prefsFolderPath isDirectory:&isDirectory], @"Preferencs folder path does not exist at: %@", prefsFolderPath );
	NSAssert1( isDirectory, @"Preferences folder path at %@ is not a folder", prefsFolderPath );
	
	NSString *prefsFilePath = [prefsFolderPath stringByAppendingPathComponent:@"com.native-instruments.Reaktor5.plist"];
	NSAssert1( [[NSFileManager defaultManager] fileExistsAtPath:prefsFilePath isDirectory:&isDirectory], @"Preferences file does not exist at: %@", prefsFilePath );
	NSAssert1( !isDirectory, @"Preferences file at %@ is actually a folder!", prefsFilePath );
	
	return [NSDictionary dictionaryWithContentsOfFile:prefsFilePath];
}


@end
