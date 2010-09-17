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
- (NSURL *)reaktorFactoryContentPath;
- (NSURL *)reaktorUserContentPath;
- (NSDictionary *)reaktorAppPreferences;
- (NSDictionary *)reaktorUserPreferences;

@end


@implementation FreemanModuleDatabase

@synthesize contents = _contents;
@synthesize primary = _primary;

- (id)init {
	if( ( self = [super init] ) ) {
		_contents = [NSMutableArray array];
		_catalogs = [NSMutableArray array];
		_modules  = [NSMutableArray array];
		_primary  = YES;
	}
	
	return self;
}


- (id)initPrimaryModuleDatabase {
	if( ( self = [self init] ) ) {
		_primary = YES;
		
		NSURL *reaktorFactoryContentURL = [self reaktorFactoryContentPath];
		NSURL *reaktorUserContentURL = [self reaktorUserContentPath];
		
		[self addCatalog:[[FreemanXMLCatalog alloc] initWithOwner:self
                                                         name:@"Built-In Module"
                                                  catalogFile:[[NSBundle mainBundle] pathForResource:@"modules" ofType:@"xml"]]];

		[self addCatalog:[[FreemanDiskCatalog alloc] initWithOwner:self
                                                          name:@"Core Cell"
                                                   factoryPath:[[reaktorFactoryContentURL URLByAppendingPathComponent:@"Core Cells"] path]
                                                      userPath:[[reaktorUserContentURL URLByAppendingPathComponent:@"Core Cells"] path]
                                                  withFileType:@"rcc"]];

		[self addCatalog:[[FreemanDiskCatalog alloc] initWithOwner:self
                                                          name:@"Macro"
                                                   factoryPath:[[reaktorFactoryContentURL URLByAppendingPathComponent:@"Macros"] path]
                                                      userPath:[[reaktorUserContentURL URLByAppendingPathComponent:@"Macros"] path]
                                                  withFileType:@"mdl"]];
	}
	
	return self;
}


- (id)initCoreModuleDatabase {
	if( ( self = [self init] ) ) {
		_primary = NO;
		
		NSURL *reaktorFactoryContentURL = [self reaktorFactoryContentPath];
		NSURL *reaktorUserContentURL = [self reaktorUserContentPath];
		
		[self addCatalog:[[FreemanXMLCatalog alloc] initWithOwner:self
                                                         name:@"Built-In Module"
                                                  catalogFile:[[NSBundle mainBundle] pathForResource:@"coremodules" ofType:@"xml"]]];

		NSURL *expertMacrosURL = [[reaktorFactoryContentURL URLByAppendingPathComponent:@"Core Macros"] URLByAppendingPathComponent:@"Expert"];
		[self addCatalog:[[FreemanDiskCatalog alloc] initWithOwner:self
		                                                          name:@"Expert Macro"
		                                                   factoryPath:[expertMacrosURL path]
		                                                      userPath:nil
		                                                  withFileType:@"rcm"]];
		
		NSURL *standardMacrosURL = [[reaktorFactoryContentURL URLByAppendingPathComponent:@"Core Macros"] URLByAppendingPathComponent:@"Standard"];
		[self addCatalog:[[FreemanDiskCatalog alloc] initWithOwner:self
		                                                          name:@"Standard Macro"
		                                                   factoryPath:[standardMacrosURL path]
		                                                      userPath:nil
		                                                  withFileType:@"rcm"]];
		
		NSURL *userMacrosURL = [reaktorUserContentURL URLByAppendingPathComponent:@"Core Macros"];
		[self addCatalog:[[FreemanDiskCatalog alloc] initWithOwner:self
		                                                          name:@"User Macro"
		                                                   factoryPath:[userMacrosURL path]
		                                                      userPath:nil
		                                                  withFileType:@"rcm"]];
	}
	
	return self;
}


- (void)addCatalog:(FreemanCatalog *)catalog {
	[_catalogs addObject:catalog];
	[_contents addObject:catalog];
	[_modules addObjectsFromArray:[catalog allModules]];
	#ifdef DEBUG_FREEMAN
	[catalog list];
	#endif
}


- (FreemanModule *)constModule {
	NSArray *result;
	if( _primary ) {
		result = [_modules filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^(id obj,NSDictionary *bindings) {
			return (BOOL)([[obj path] isEqualToString:@"Built-In Module : Math : Constant"]);
		}]];
		NSAssert( [result count] == 1, @"Could not find primary constant module!" );
	} else {
		result = [_modules filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^(id obj,NSDictionary *bindings) {
			return (BOOL)([[obj path] isEqualToString:@"Built-In Module : Const"]);
		}]];
		NSAssert( [result count] == 1, @"Could not find core constant module!" );
	}
	
	return [result objectAtIndex:0];
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


- (NSURL *)reaktorFactoryContentPath {
	NSDictionary *reaktorPreferences = [self reaktorAppPreferences];
	NSString *reaktorLibraryHFSPath = [reaktorPreferences objectForKey:@"SystemContentDir"];
	NSAssert( reaktorLibraryHFSPath, @"SystemContentDir could not be found in Reaktor preferences" );
	CFURLRef urlRef = CFURLCreateWithFileSystemPath( kCFAllocatorDefault, (CFStringRef)reaktorLibraryHFSPath, kCFURLHFSPathStyle, true );
	CFMakeCollectable( urlRef );
	return (NSURL *)urlRef;
}


- (NSURL *)reaktorUserContentPath {
	NSDictionary *reaktorPreferences = [self reaktorUserPreferences];
	NSString *reaktorLibraryHFSPath = [reaktorPreferences objectForKey:@"UserContentDir"];
	NSAssert( reaktorLibraryHFSPath, @"UserContentDir could not be found in Reaktor preferences" );
	CFURLRef urlRef = CFURLCreateWithFileSystemPath( kCFAllocatorDefault, (CFStringRef)reaktorLibraryHFSPath, kCFURLHFSPathStyle, true );
	CFMakeCollectable( urlRef );
	return (NSURL *)urlRef;
}



- (NSDictionary *)reaktorAppPreferences {
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


- (NSDictionary *)reaktorUserPreferences {
	BOOL isDirectory;
	
	NSString *libraryFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
	NSAssert1( [[NSFileManager defaultManager] fileExistsAtPath:libraryFolderPath isDirectory:&isDirectory], @"Library folder path does not exist at: %@", libraryFolderPath );
	NSAssert1( isDirectory, @"Library folder path at %@ is not a folder", libraryFolderPath );
	
	NSString *prefsFolderPath = [libraryFolderPath stringByAppendingPathComponent:@"Preferences"];
	NSAssert1( [[NSFileManager defaultManager] fileExistsAtPath:prefsFolderPath isDirectory:&isDirectory], @"Preferencs folder path does not exist at: %@", prefsFolderPath );
	NSAssert1( isDirectory, @"Preferences folder path at %@ is not a folder", prefsFolderPath );
	
	NSString *prefsFilePath = [prefsFolderPath stringByAppendingPathComponent:@"com.native-instruments.Reaktor5.5.plist"];
	NSAssert1( [[NSFileManager defaultManager] fileExistsAtPath:prefsFilePath isDirectory:&isDirectory], @"Preferences file does not exist at: %@", prefsFilePath );
	NSAssert1( !isDirectory, @"Preferences file at %@ is actually a folder!", prefsFilePath );
	
	return [NSDictionary dictionaryWithContentsOfFile:prefsFilePath];
	
}


#pragma mark FreemanModularObject

- (id<FreemanModularObject>)owner {
	return nil;
}


- (NSString *)name {
	return nil;
}


- (NSUInteger)indexOfContent:(id<FreemanModularObject>)content {
	return [[self contents] indexOfObject:content];
}


- (NSString *)path {
	return @"";
}


- (NSString *)navigationSequence {
	if( _primary ) {
		return @"R";
	} else {
		return @"";
	}
}


- (BOOL)isModule {
	return NO;
}


- (NSArray *)allModules {
	NSMutableArray *modules = [NSMutableArray array];
	[[self contents] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
		[modules addObjectsFromArray:[obj allModules]];
	}];
	return [modules copy];
}


- (void)addContent:(id<FreemanModularObject>)content {
	[[self contents] addObject:content];
}


@end
