//
//  NSURL+Freeman.m
//  Freeman
//
//  Created by Matt Mower on 19/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "NSURL+Freeman.h"

@implementation NSURL (Freeman)

// This method is only available from 10.6 onwards so we add it for 10.5

- (NSURL *)URLByAppendingPathComponent:(NSString *)pathComponent {
	NSString *urlRep = [self absoluteString];
	
	if( ![urlRep hasSuffix:@"/"] ) {
		urlRep = [urlRep stringByAppendingString:@"/"];
	}
	
	if( [pathComponent hasPrefix:@"/"] ) {
		pathComponent = [pathComponent substringToIndex:([pathComponent length]-2)];
	}
	
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",urlRep,pathComponent]];
}

@end
