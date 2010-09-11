//
//  FreemanModule.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanModule.h"

#import "FreemanCatalog.h"

@implementation FreemanModule

@synthesize name                     = _name;
@synthesize scoreForLastAbbreviation = _scoreForLastAbbreviation;
@synthesize navigationSequence       = _navigationSequence;
@synthesize menuHierarchy            = _menuHierarchy;
@synthesize menuPath                 = _menuPath;
@synthesize catalog                  = _catalog;


- (id)initWithName:(NSString *)name catalog:(FreemanCatalog *)catalog navigationSequence:(NSString *)navigationSequence menuHierarchy:(NSArray *)menuHierarchy {
	if( ( self = [super init] ) ) {
		_name                     = name;
		_catalog                  = catalog;
		_scoreForLastAbbreviation = 0.0;
		_navigationSequence       = navigationSequence;
		_menuHierarchy            = menuHierarchy;
		
		NSMutableString *menuPath = [NSMutableString stringWithCapacity:30];
		for( NSString *menu in menuHierarchy ) {
			if( [menuPath length] > 0 ) {
				[menuPath appendString:@" : "];
			}
			[menuPath appendString:menu];
		}
		_menuPath = [menuPath copy];
	}
	
	return self;
}


- (NSString *)description {
	return [NSString stringWithFormat:@"Freeman Module<%@> (%f) (%@)", [self name], [self scoreForLastAbbreviation], [self navigationSequence]];
}


- (NSString *)completeNavigationSequence {
	return [NSString stringWithFormat:@"%@%@!", [[self catalog] navigationSequence], [self navigationSequence]];
}


@end
