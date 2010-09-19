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
	for( NSString *folder in [self foldersInPath:path] ) {
		FreemanMenu *subMenu = [[FreemanMenu alloc] initWithOwner:container name:folder];
		[self loadModulesFrom:[path stringByAppendingPathComponent:folder] withFileType:fileType into:subMenu];
		
		if( [[subMenu allModules] count] > 0 ) {
			[container addContent:subMenu];
		} else {
			#ifdef DEBUG_FREEMAN
			NSLog( @"** Discarding empty submenu: %@", [subMenu name] );
			#endif
		}
	}
	
	for( NSString *file in [self filesInPath:path withFileType:fileType] ) {
		FreemanModule *module = [[FreemanModule alloc] initWithOwner:container catalog:self name:[file stringByDeletingPathExtension]];
		[container addContent:module];
	}
}


- (NSArray *)foldersInPath:(NSString *)path {
	NSMutableArray *folders = [NSMutableArray array];
	
	for( NSString *entry in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL] ) {
		BOOL exists, isDirectory;
		exists = [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:entry] isDirectory:&isDirectory];
		if( exists && isDirectory ) {
			[folders addObject:entry];
		}
	}
	
	return folders;
}


- (NSArray *)filesInPath:(NSString *)path withFileType:(NSString *)fileType {
	
	NSMutableArray *files = [NSMutableArray array];
	
	for( NSString *entry in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL] ) {
		BOOL exists, isDirectory;
		exists = [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:entry] isDirectory:&isDirectory];
		if( exists && !isDirectory && [[entry pathExtension] isEqualToString:fileType] ) {
			[files addObject:entry];
		}
	}
	
	return [files sortedArrayUsingSelector:@selector(compare:)];
}


@end
