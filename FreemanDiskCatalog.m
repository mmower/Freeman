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
#import "FreemanNavigationStack.h"

@interface FreemanDiskCatalog (PrivateMethods)

- (void)loadModulesFrom:(NSString *)path withFileType:(NSString *)fileType intoMenu:(FreemanMenu *)menu;

@end


@implementation FreemanDiskCatalog

- (id)initWithName:(NSString *)name factoryPath:(NSString *)factoryPath userPath:(NSString *)userPath withFileType:(NSString *)fileType {
	if( ( self = [super initWithName:name] ) ) {
		_fileManager = [[NSFileManager alloc] init];
		
		[self loadModulesFrom:factoryPath withFileType:fileType intoMenu:[self menu]];
		if( userPath ) {
			[self loadModulesFrom:userPath withFileType:fileType intoMenu:[self menu]];
		}
		[self catalogLoaded];
	}
	
	return self;
}


- (void)loadModulesFrom:(NSString *)path withFileType:(NSString *)fileType intoMenu:(FreemanMenu *)menu {
	BOOL isDirectory;
	for( NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL] ) {
		[[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory:&isDirectory];
		if( isDirectory ) {
			NSLog( @"Create new subMenu: %@", file );
			FreemanMenu *subMenu = [[FreemanMenu alloc] initWithName:file];
			[menu addSubMenu:subMenu];
			[self loadModulesFrom:[path stringByAppendingPathComponent:file] withFileType:fileType intoMenu:subMenu];
		} else if( [[file pathExtension] isEqualToString:fileType] ) {
			FreemanModule *module = [[FreemanModule alloc] initWithName:[file stringByDeletingPathExtension] catalog:self];
			[menu addModule:module];
		}
	}
}

@end
