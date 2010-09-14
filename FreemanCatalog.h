//
//  FreemanCatalog.h
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanMenu;

@class FreemanNavigationStack;

@interface FreemanCatalog : NSObject {
	NSString								*_name;
	NSMutableArray					*_modules;
	FreemanMenu							*_menu;
}

@property (readonly) NSString *name;
@property (readonly) NSMutableArray *modules;

@property (assign) FreemanMenu *menu;

- (id)initWithName:(NSString *)name;

- (void)catalogLoaded;

- (void)list;

@end
