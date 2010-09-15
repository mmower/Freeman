//
//  FreemanDiskCatalog.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FreemanCatalog.h"

@class FreemanModuleDatabase;

@interface FreemanDiskCatalog : FreemanCatalog {
	NSFileManager *_fileManager;

}

- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name factoryPath:(NSString *)factoryPath userPath:(NSString *)userPath withFileType:(NSString *)fileType;

@end
