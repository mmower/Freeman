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

- (id)initWithName:(NSString *)name {
	if( ( self = [super init] ) ) {
		_name = name;
		_scoreForLastAbbreviation = 0.0;
	}
	
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Freeman Module<%@> (%f)", [self name], [self scoreForLastAbbreviation]];
}

@end
