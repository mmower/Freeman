//
//  FreemanMenu.m
//  Freeman
//
//  Created by Matt Mower on 12/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanMenu.h"

#import "FreemanModule.h"


@implementation FreemanMenu

@synthesize parent             = _parent;
@synthesize name               = _name;
@synthesize subMenus           = _subMenus;
@synthesize modules            = _modules;
@synthesize navigationSequence = _navigationSequence;


- (id)initWithName:(NSString *)name {
	if( ( self = [super init] ) ) {
		_parent             = nil;
		_name               = name;
		_subMenus           = [NSMutableArray array];
		_modules            = [NSMutableArray array];
		_navigationSequence = nil;
	}
	
	return self;
}


- (NSString *)description {
	return [self name];
}


- (void)addSubMenu:(FreemanMenu *)menu {
	[menu setParent:self];
	[_subMenus addObject:menu];
}


- (void)addModule:(FreemanModule *)module {
	[module setMenu:self];
	[_modules addObject:module];
}


- (NSArray *)allModules {
	NSMutableArray *modules = [NSMutableArray array];
	[modules addObjectsFromArray:[self modules]];
	for( FreemanMenu *subMenu in [self subMenus] ) {
		[modules addObjectsFromArray:[subMenu allModules]];
	}
	return modules;
}


- (NSString *)path {
	if( [self parent] ) {
		return [[[self parent] path] stringByAppendingString:[NSString stringWithFormat:@" : %@", [self name]]];
	} else {
		return [self name];
	}
}

@end
