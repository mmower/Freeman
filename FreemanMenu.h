//
//  FreemanMenu.h
//  Freeman
//
//  Created by Matt Mower on 12/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FreemanModularObject.h"

@class FreemanModule;

@interface FreemanMenu : NSObject <FreemanModularObject> {
	id<FreemanModularObject>	_owner;
	NSString				*_name;
	NSMutableArray	*_contents;
	// NSMutableArray	*_subMenus;
	// NSMutableArray	*_modules;
	// NSString				*_navigationSequence;
}

@property (assign) id<FreemanModularObject> owner;
@property (assign) NSString *name;
@property (readonly) NSMutableArray *contents;
// @property (readonly) NSMutableArray *subMenus;
// @property (readonly) NSMutableArray *modules;
// @property (assign) NSString *navigationSequence;

- (id)initWithOwner:(id<FreemanModularObject>)owner name:(NSString *)name;

// - (void)addSubMenu:(FreemanMenu *)menu;
// - (void)addModule:(FreemanModule *)module;

// - (NSString *)path;

// - (NSArray *)allModules;

@end
