//
//  FreemanDiskCatalog.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanDiskCatalog.h"

@interface FreemanDiskCatalog (PrivateMethods)

- (void)findFilesFromPath:(NSString *)path withFileType:(NSString *)fileType;

@end


@implementation FreemanDiskCatalog

- (id)initWithName:(NSString *)name fromRootPath:(NSString *)rootPath withFileType:(NSString *)fileType {
	if( ( self = [super initWithName:name] ) ) {
		[self findFilesFromPath:rootPath withFileType:fileType];
	}
	
	return self;
}


- (void)findFilesFromPath:(NSString *)path withFileType:(NSString *)fileType {
	NSError *error;
	
	[self openMenu:[NSDictionary dictionaryWithObject:[path lastPathComponent] forKey:@"name"]];
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	NSArray *files = [fileManager contentsOfDirectoryAtPath:path error:&error];
	for( NSString *file in files ) {
		BOOL isDirectory;
		
		[fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",path,file] isDirectory:&isDirectory];
		if( isDirectory ) {
			[self findFilesFromPath:[NSString stringWithFormat:@"%@/%@",path,file] withFileType:fileType];
		} else if( [[file pathExtension] isEqualToString:fileType] ) {
			[self addModule:[NSDictionary dictionaryWithObject:[file stringByDeletingPathExtension] forKey:@"name"]];
		}
		
		NSLog( @"%@", file );
	}
	
	[self closeMenu];
}

@end
