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

- (FreemanMenu *)menuFromPath:(NSString *)path withFileType:(NSString *)fileType;

@end


@implementation FreemanDiskCatalog

- (id)initWithName:(NSString *)name factoryPath:(NSString *)factoryPath userPath:(NSString *)userPath withFileType:(NSString *)fileType {
	if( ( self = [super initWithName:name] ) ) {
		[self setFactoryMenu:[self menuFromPath:factoryPath withFileType:fileType]];
		if( userPath ) {
			[self setUserMenu:[self menuFromPath:userPath withFileType:fileType]];
		}
		[self catalogLoaded];
	}
	
	return self;
}


- (FreemanMenu *)menuFromPath:(NSString *)path withFileType:(NSString *)fileType {
	FreemanMenu *menu = [[FreemanMenu alloc] initWithName:[path lastPathComponent]];
	
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	
	for( NSString *file in files ) {
		BOOL isDirectory;
		[[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",path,file] isDirectory:&isDirectory];
		if( isDirectory ) {
			[menu addSubMenu:[self menuFromPath:[path stringByAppendingPathComponent:file] withFileType:fileType]];
		}
	}
	
	for( NSString *file in files ) {
		BOOL isDirectory;
		[[NSFileManager defaultManager]  fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",path,file] isDirectory:&isDirectory];
		if( !isDirectory && [[file pathExtension] isEqualToString:fileType] ) {
			[menu addModule:[[FreemanModule alloc] initWithName:[file stringByDeletingPathExtension]]];
		}
	}
	
	return menu;
}

@end
