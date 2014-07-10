//
//  NSColor+Freeman.h
//  Freeman
//
//  Created by Matt Mower on 15/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Cocoa/Cocoa.h>

@interface NSColor (Freeman)

+ (NSColor *)colorFromHexRGB:(NSString *)hexString;

-(NSString *)asHexString;

- (BOOL)isSameColorInRGB:(NSColor *)otherColor;

+ (NSColor *)colorAtLocation:(CGPoint)location;
+ (NSColor *)colorOfWindow:(CGWindowID)windowID atPoint:(CGPoint)point;

@end
