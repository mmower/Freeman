//
//  FreemanModule.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanModule.h"

#import "FreemanMenu.h"
#import "FreemanCatalog.h"
#import "FreemanRemoteProcess.h"

#import "NSArray+Freeman.h"

#define AUTO_INSERT	0

@interface FreemanModule (PrivateMethods)

- (NSArray *)generateMenuHierarchy;
- (NSString *)generateMenuPath;

@end


@implementation FreemanModule

@synthesize name                     = _name;
@synthesize scoreForLastAbbreviation = _scoreForLastAbbreviation;
@synthesize menu                     = _menu;
@synthesize menuPath                 = _menuPath;
@synthesize menuHierarchy            = _menuHierarchy;
@synthesize catalog                  = _catalog;


- (id)initWithName:(NSString *)name catalog:(FreemanCatalog *)catalog {
	if( ( self = [super init] ) ) {
		_name                     = name;
		_catalog                  = catalog;
		_scoreForLastAbbreviation = 0.0;
		_menu                     = nil;
		_menuHierarchy            = nil;
		_menuPath                 = nil;
	}
	
	return self;
}


- (void)setMenu:(FreemanMenu *)menu {
	_menu          = menu;
	_menuHierarchy = [self generateMenuHierarchy];
	_menuPath      = [self generateMenuPath];
}


- (void)insertAt:(CGPoint)point inReaktorProcess:(FreemanRemoteProcess *)reaktorProcess {
	// Open the context menu
	[reaktorProcess sendRightMouseClick:point];
	
	// Navigate the menu hierarchy
	
	NSArray *navigation = [[self menuHierarchy] arrayByAddingObject:self];
	NSLog( @"Navigate and select: %@", [navigation pretty] );
	[reaktorProcess navigateMenu:navigation];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"Freeman Module<%@> (%f)", [self name], [self scoreForLastAbbreviation]];
}


- (NSArray *)generateMenuHierarchy {
	NSMutableArray *menus = [NSMutableArray array];
	FreemanMenu *menu = _menu;
	while( menu != nil ) {
		[menus addObject:menu];
		menu = [menu parent];
	}
	return [menus reverse];
}


- (NSString *)generateMenuPath {
	NSMutableString *path = [NSMutableString stringWithCapacity:32];
	[[self menuHierarchy] enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop) {
		if( idx > 0 ) {
			[path appendString:@" : "];
		}
		[path appendString:[obj name]];
	}];
	return [path copy];
}

@end
