//
//  NSArray+Freeman.m
//  Freeman
//
//  Created by Matt Mower on 13/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import "NSArray+Freeman.h"

@implementation NSArray (Freeman)

- (NSArray *)reverse {
	NSMutableArray *reversedArray = [NSMutableArray arrayWithCapacity:[self count]];
	
	for( id obj in self ) {
		[reversedArray insertObject:obj atIndex:0];
	}
	
	return [reversedArray copy];
}


- (NSString *)pretty {
	NSMutableString *pretty = [NSMutableString stringWithCapacity:128];
	
	// [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	// 	if( idx > 0 ) {
	// 		[pretty appendString:@","];
	// 	}
	// 	[pretty appendString:[obj description]];
	// }];
	
	[pretty appendString:@"("];
	for( int idx = 0; idx < [self count]; idx++ ) {
		if( idx > 0 ) {
			[pretty appendString:@","];
		}
		[pretty appendString:[[self objectAtIndex:idx] description]];
	}
	[pretty appendString:@")"];
	
	return pretty;
}

@end
