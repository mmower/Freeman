//
//  FreemanDiskCatalog.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Cocoa/Cocoa.h>

#import "FreemanCatalog.h"

@class FreemanModuleDatabase;

@interface FreemanDiskCatalog : FreemanCatalog {
	NSFileManager *_fileManager;

}

- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name factoryPath:(NSString *)factoryPath userPath:(NSString *)userPath withFileType:(NSString *)fileType;

@end
