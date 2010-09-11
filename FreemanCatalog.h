//
//  FreemanCatalog.h
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanNavigationStack;

@interface FreemanCatalog : NSObject {
	NSString								*_name;
	NSMutableArray					*_modules;
	NSString								*_navigationSequence;
	
	FreemanNavigationStack	*_navigationStack;
}

@property (readonly) NSString *name;
@property (readonly) NSMutableArray *modules;
@property (assign) NSString *navigationSequence;

- (id)initWithName:(NSString *)name;

- (void)catalogLoaded;

- (void)openMenu:(NSDictionary *)attributes;
- (void)addModule:(NSDictionary *)attributes;
- (void)closeMenu;

- (void)list;

@end