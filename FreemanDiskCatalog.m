//
//  FreemanDiskCatalog.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanDiskCatalog.h"

#import "FreemanNavigationStack.h"

@interface FreemanDiskCatalog (PrivateMethods)

- (void)findFilesFromPath:(NSString *)path withFileType:(NSString *)fileType openMenu:(BOOL)openMenu;
- (void)iterateFiles:(NSArray *)files ofType:fileType fromPath:(NSString *)path;

@end


@implementation FreemanDiskCatalog


- (id)initWithName:(NSString *)name factoryPath:(NSString *)factoryPath userPath:(NSString *)userPath withFileType:(NSString *)fileType {
	if( ( self = [super initWithName:name] ) ) {
		[self openMenu:[NSDictionary dictionaryWithObject:[factoryPath lastPathComponent] forKey:@"name"]];
		[self findFilesFromPath:factoryPath withFileType:fileType openMenu:NO];
		if( userPath ) {
			[self findFilesFromPath:userPath withFileType:fileType openMenu:NO];
		}
		[self closeMenu];
	}
	
	return self;
}


- (void)findFilesFromPath:(NSString *)path withFileType:(NSString *)fileType openMenu:(BOOL)openMenu {
	NSError *error;
	
	if( openMenu ) {
		[self openMenu:[NSDictionary dictionaryWithObject:[path lastPathComponent] forKey:@"name"]];
	}
	
	[self iterateFiles:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error] ofType:fileType fromPath:path];
	
	if( openMenu ) {
		[self closeMenu];
	}
}


- (void)iterateFiles:(NSArray *)files ofType:fileType fromPath:(NSString *)path {
	// Because of the way macros and core-cells are presented we iterate twice through each folder
	// the first time to find all sub-folders and process them, the second time to add modules in
	// the current folder

	for( NSString *file in files ) {
		BOOL isDirectory;
		[[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",path,file] isDirectory:&isDirectory];
		if( isDirectory ) {
			[self findFilesFromPath:[NSString stringWithFormat:@"%@/%@",path,file] withFileType:fileType openMenu:YES];
		}		
	}
	
	for( NSString *file in files ) {
		BOOL isDirectory;
		[[NSFileManager defaultManager]  fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",path,file] isDirectory:&isDirectory];
		if( !isDirectory && [[file pathExtension] isEqualToString:fileType] ) {
			[self addModule:[NSDictionary dictionaryWithObject:[file stringByDeletingPathExtension] forKey:@"name"]];
		}
	}
}

@end
