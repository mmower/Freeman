//
//  NSString+FreemanRanking.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Cocoa/Cocoa.h>


@interface NSString (FreemanRanking)

- (float)scoreForAbbreviation:(NSString *)abbreviation;
- (float)scoreForAbbreviation:(NSString *)abbreviation hitMask:(NSMutableIndexSet *)mask;
- (float)scoreForAbbreviation:(NSString *)abbreviation inRange:(NSRange)searchRange fromRange:(NSRange)abbreviationRange hitMask:(NSMutableIndexSet *)mask;

- (NSString *)formatInGroupsOf:(NSUInteger)count;
	
@end
