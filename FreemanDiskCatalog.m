//
//  FreemanDiskCatalog.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanDiskCatalog.h"

#import "FreemanMenu.h"
#import "FreemanModule.h"
#import "FreemanModuleDatabase.h"

@interface FreemanDiskCatalog (PrivateMethods)

- (void)loadModulesFrom:(NSString *)path withFileType:(NSString *)fileType into:(id<FreemanModularObject>)container;
- (NSArray *)foldersInPath:(NSString *)path;
- (NSArray *)filesInPath:(NSString *)path withFileType:(NSString *)fileType;

@end


@implementation FreemanDiskCatalog

- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name factoryPath:(NSString *)factoryPath userPath:(NSString *)userPath withFileType:(NSString *)fileType {
	if( ( self = [super initWithOwner:owner name:name] ) ) {
		_fileManager = [[NSFileManager alloc] init];
		
		[self loadModulesFrom:factoryPath withFileType:fileType into:self];
		if( userPath ) {
			[self loadModulesFrom:userPath withFileType:fileType into:self];
		}
		[self catalogLoaded];
	}
	
	return self;
}


- (void)loadModulesFrom:(NSString *)path withFileType:(NSString *)fileType into:(id<FreemanModularObject>)container {
	[[self foldersInPath:path] enumerateObjectsUsingBlock:^(id file,NSUInteger idx, BOOL *stop) {
		FreemanMenu *subMenu = [[FreemanMenu alloc] initWithOwner:container name:file];
		[self loadModulesFrom:[path stringByAppendingPathComponent:file] withFileType:fileType into:subMenu];
		if( [[subMenu allModules] count] > 0 ) {
			[container addContent:subMenu];
		} else {
			#ifdef DEBUG_FREEMAN
			NSLog( @"** Discarding empty submenu: %@", [subMenu name] );
			#endif
		}
		
	}];
	
	[[self filesInPath:path withFileType:fileType] enumerateObjectsUsingBlock:^(id file, NSUInteger idx, BOOL *stop) {
		FreemanModule *module = [[FreemanModule alloc] initWithOwner:container catalog:self name:[file stringByDeletingPathExtension]];
		[container addContent:module];
	}];
}


- (NSArray *)foldersInPath:(NSString *)path {
	NSPredicate *predicate = [NSPredicate predicateWithBlock:^(id file, NSDictionary *bindings) {
		BOOL exists, isDirectory;
		exists = [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory:&isDirectory];
		return (BOOL)(exists && isDirectory);
	}];
	
	return [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL] filteredArrayUsingPredicate:predicate];
}


- (NSArray *)filesInPath:(NSString *)path withFileType:(NSString *)fileType {
	NSPredicate *predicate = [NSPredicate predicateWithBlock:^(id file, NSDictionary *bindings) {
		BOOL exists, isDirectory;
		exists = [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory:&isDirectory];
		return (BOOL)([[file pathExtension] isEqualToString:fileType] && exists && !isDirectory);
	}];
	
	return [[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL] filteredArrayUsingPredicate:predicate] sortedArrayUsingComparator:^(id a,id b) {
		return (NSComparisonResult)[a compare:b];
	}];
}


@end
