//
//  FreemanModuleDatabase.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FreemanModularObject.h"

@class FreemanCatalog;

@interface FreemanModuleDatabase : NSObject <FreemanModularObject> {
	NSMutableArray			*_contents;
	
	NSMutableArray			*_catalogs;
	NSMutableArray			*_modules;
	
	BOOL								_primary;
}

@property (readonly) NSMutableArray *contents;

- (id)initPrimaryModuleDatabase;
- (id)initCoreModuleDatabase;

- (void)addCatalog:(FreemanCatalog *)catalog;

- (NSArray *)searchFor:(NSString *)query;

@end
