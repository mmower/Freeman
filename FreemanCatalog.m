//
//  FreemanCatalog.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanCatalog.h"

#import "FreemanModule.h"
#import "FreemanMenu.h"

#import "NSArray+Freeman.h"

@implementation FreemanCatalog

@synthesize name = _name;
@synthesize modules = _modules;
@synthesize menu = _menu;


- (id)initWithName:(NSString *)name {
	if( ( self = [super init] ) ) {
		_name            = name;
		_modules         = [NSMutableArray array];
		_menu						 = [[FreemanMenu alloc] initWithName:name];
	}
	
	return self;
}


- (void)catalogLoaded {
	_modules = [NSMutableArray array];
	[_modules addObjectsFromArray:[[self menu] allModules]];
}


- (void)list {
	NSLog( @"Catalog: %@", [self name] );
	[_modules enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
		NSLog( @"Module %@ %@", [obj name], [[obj menuHierarchy] pretty] );
		}];
}


@end
