//
//  FreemanCatalog.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanCatalog.h"

@implementation FreemanCatalog

@synthesize name = _name;
@synthesize modules = _modules;

- (id)initWithName:(NSString *)name {
	if( ( self = [super init] ) ) {
		_name    = name;
		_modules = [NSMutableArray array];
	}
	
	return self;
}

@end
