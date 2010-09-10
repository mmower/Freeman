//
//  FreemanModule.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanModule.h"


@implementation FreemanModule

@synthesize name = _name;
@synthesize scoreForLastAbbreviation = _scoreForLastAbbreviation;
@synthesize navigationSequence = _navigationSequence;
@synthesize menuHierarchy = _menuHierarchy;

- (id)initWithName:(NSString *)name navigationSequence:(NSString *)navigationSequence menuHierarchy:(NSArray *)menuHierarchy {
	if( ( self = [super init] ) ) {
		_name = name;
		_scoreForLastAbbreviation = 0.0;
		_navigationSequence = navigationSequence;
		_menuHierarchy = menuHierarchy;
	}
	
	NSLog( @"%@", [self description] );
	
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Freeman Module<%@> (%f) (%@)", [self name], [self scoreForLastAbbreviation], [self navigationSequence]];
}

@end
