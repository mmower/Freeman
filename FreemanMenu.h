//
//  FreemanMenu.h
//  Freeman
//
//  Created by Matt Mower on 12/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanModule;

@interface FreemanMenu : NSObject {
	FreemanMenu			*_parent;
	NSString				*_name;
	NSMutableArray	*_subMenus;
	NSMutableArray	*_modules;
	NSString				*_navigationSequence;
}

@property (assign) FreemanMenu *parent;
@property (assign) NSString *name;
@property (readonly) NSMutableArray *subMenus;
@property (readonly) NSMutableArray *modules;
@property (assign) NSString *navigationSequence;

- (id)initWithName:(NSString *)name;

- (void)addSubMenu:(FreemanMenu *)menu;
- (void)addModule:(FreemanModule *)module;

- (NSString *)path;

- (NSArray *)allModules;

@end
