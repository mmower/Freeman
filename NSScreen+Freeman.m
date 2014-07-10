//
//  NSScreen+Freeman.m
//  Freeman
//
//  Created by Matt Mower on 18/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import "NSScreen+Freeman.h"


@implementation NSScreen (Freeman)


- (CGPoint)flipPoint:(CGPoint)point {
	return CGPointMake( point.x, [self frame].size.height - point.y );
}


- (CGPoint)windowPointToScreenPoint:(CGPoint)point {
	CGFloat ydepth = [self frame].size.height;
	return CGPointMake(point.x, ydepth-point.y);
}


@end
