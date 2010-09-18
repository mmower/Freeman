//
//  NSColor+Freeman.h
//  Freeman
//
//  Created by Matt Mower on 15/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Freeman)

+ (NSColor *)colorFromHexRGB:(NSString *)hexString;

-(NSString *)asHexString;

- (BOOL)isSameColorInRGB:(NSColor *)otherColor;

+ (NSColor *)colorAtLocation:(CGPoint)location;
+ (NSColor *)colorOfWindow:(CGWindowID)windowID atPoint:(CGPoint)point;

@end
