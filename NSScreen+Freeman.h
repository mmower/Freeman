//
//  NSScreen+Freeman.h
//  Freeman
//
//  Created by Matt Mower on 18/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Cocoa/Cocoa.h>


@interface NSScreen (Freeman)

- (CGPoint)flipPoint:(CGPoint)point;
- (CGPoint)windowPointToScreenPoint:(CGPoint)point;

@end
