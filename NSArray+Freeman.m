//
//  NSArray+Freeman.m
//  Freeman
//
//  Created by Matt Mower on 13/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
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
	
	[pretty appendString:@"("];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if( idx > 0 ) {
			[pretty appendString:@","];
		}
		[pretty appendString:[obj description]];
	}];
	[pretty appendString:@")"];
	
	return pretty;
}

@end
