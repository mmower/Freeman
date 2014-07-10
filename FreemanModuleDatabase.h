//
//  FreemanModuleDatabase.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Cocoa/Cocoa.h>

#import "FreemanModularObject.h"

@class FreemanCatalog;
@class FreemanModule;

@interface FreemanModuleDatabase : NSObject <FreemanModularObject> {
	NSMutableArray			*_contents;
	
	NSMutableArray			*_catalogs;
	NSMutableArray			*_modules;
	
	BOOL								_primary;
}

@property (readonly) NSMutableArray *contents;
@property (readonly) BOOL primary;

- (id)initPrimaryModuleDatabase;
- (id)initCoreModuleDatabase;

- (void)addCatalog:(FreemanCatalog *)catalog;

- (NSArray *)searchFor:(NSString *)query;
- (FreemanModule *)constModule;

- (FreemanModule *)moduleWithPath:(NSString *)path;

@end
