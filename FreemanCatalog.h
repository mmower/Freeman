//
//  FreemanCatalog.h
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Cocoa/Cocoa.h>

#import "FreemanModularObject.h"

@class FreemanMenu;

@class FreemanNavigationStack;

@interface FreemanCatalog : NSObject <FreemanModularObject> {
	id<FreemanModularObject>	_owner;
	NSString									*_name;
	NSMutableArray						*_contents;
	NSMutableArray						*_modules;
}

@property (readonly) NSString *name;
@property (assign) id<FreemanModularObject> owner;
@property (readonly) NSMutableArray *contents;
@property (readonly) NSMutableArray *modules;

- (id)initWithOwner:(id)owner name:(NSString *)name;

- (void)catalogLoaded;

- (void)list;

@end
