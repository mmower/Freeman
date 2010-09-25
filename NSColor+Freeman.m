//
//  NSColor+Freeman.m
//  Freeman
//
//  Color to Hex code courtesy of Apple
//	http://developer.apple.com/library/mac/#qa/qa2007/qa1576.html
//
//	NSColor: Instantiate from Web-like Hex RRGGBB string
//	Original Source: <http://cocoa.karelia.com/Foundation_Categories/NSColor__Instantiat.m>
//	(See copyright notice at <http://cocoa.karelia.com>)
//

#import "CGSPrivate.h"

#import "NSColor+Freeman.h"

#import "NSScreen+Freeman.h"
#import "NSArray+Freeman.h"

OSStatus CGSFindWindowByGeometry(int cid, int zero, int one, int zero_again, CGPoint *screen_point, CGPoint *window_coords_out, int *wid_out, int *cid_out );

@implementation NSColor (Freeman)


+ (NSColor *)colorFromHexRGB:(NSString *)hexString {
	unsigned int redValue = 0, greenValue = 0, blueValue = 0;
	
	if( hexString ) {
		if( [hexString hasPrefix:@"#"] ) {
			hexString = [hexString substringFromIndex:1];
		}
		
		NSScanner *scanner;
		scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(0,2)]];
		[scanner scanHexInt:&redValue];
		scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(2,2)]];
		[scanner scanHexInt:&greenValue];
		scanner = [NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(4,2)]];
		[scanner scanHexInt:&blueValue];
	}
	
	return [NSColor colorWithCalibratedRed:(redValue / 255.0)
                                   green:(greenValue / 255.0)
                                    blue:(blueValue / 255.0)
                                   alpha:1.0];
}


- (BOOL)isSameColorInRGB:(NSColor *)otherColor {
	NSLog( @"Compare %@ and %@", [self asHexString], [otherColor asHexString] );
	
	return [[self asHexString] isEqualToString:[otherColor asHexString]];
	// CGFloat myRed, myGreen, myBlue, myAlpha;
	// [self getRed:&myRed green:&myGreen blue:&myBlue alpha:&myAlpha];
	// NSLog( @"Compare colours %@ and %@", )
	// 
	// CGFloat otherRed, otherGreen, otherBlue, otherAlpha;
	// [otherColor getRed:&otherRed green:&otherGreen blue:&otherBlue alpha:&otherAlpha];
	// 
	// return (fabs( myRed - otherRed ) < EPSILON) &&
	// 				(fabs( myGreen - otherGreen ) < EPSILON) &&
	// 				(fabs( myBlue - otherBlue ) < EPSILON) &&
	// 				(fabs( myAlpha - otherAlpha ) < EPSILON);
}


- (NSString *)asHexString {
  CGFloat redFloatValue, greenFloatValue, blueFloatValue;
  int redIntValue, greenIntValue, blueIntValue;
  NSString *redHexValue, *greenHexValue, *blueHexValue;

  //Convert the NSColor to the RGB color space before we can access its components
  NSColor *convertedColor=[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

  if(convertedColor) {
    // Get the red, green, and blue components of the color
    [convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];

    // Convert the components to numbers (unsigned decimal integer) between 0 and 255
    redIntValue=redFloatValue*255.99999f;
    greenIntValue=greenFloatValue*255.99999f;
    blueIntValue=blueFloatValue*255.99999f;

    // Convert the numbers to hex strings
    redHexValue=[NSString stringWithFormat:@"%02x", redIntValue];
    greenHexValue=[NSString stringWithFormat:@"%02x", greenIntValue];
    blueHexValue=[NSString stringWithFormat:@"%02x", blueIntValue];

    // Concatenate the red, green, and blue components' hex strings together with a "#"
    return [[NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue] uppercaseString];
  }
  return nil;
}


#pragma mark Window color sampling




+ (NSColor *)colorAtLocation:(CGPoint)screenPoint {
	// NSPoint windowPoint = NSMakePoint( screenPoint.x, screenPoint.y );
	
	CGPoint localWhere;
	int windowNumber, cid;
	CGSFindWindowByGeometry( _CGSDefaultConnection(), 0, 1, 0, &screenPoint, &localWhere, &windowNumber, &cid);
	
	// NSInteger windowNumber = [NSWindow windowNumberAtPoint:windowPoint belowWindowWithWindowNumber:0];
	NSColor *color = [self colorOfWindow:windowNumber atPoint:[[NSScreen mainScreen] flipPoint:screenPoint]];
	NSLog( @"Window %d @ %.0f,%.0f => (%@)", windowNumber, screenPoint.x, screenPoint.y, [color asHexString] );
	return color;
}


+ (NSColor *)colorOfWindow:(CGWindowID)windowID atPoint:(CGPoint)point {
	// CGRect windowBounds = [self getWindowBounds:windowID];
	// NSLog( @"Window is at %.0f,%.0f", windowBounds.origin.x, windowBounds.origin.y );
	// CGPoint samplePoint = CGPointMake( point.x - windowBounds.origin.x, point.y - windowBounds.origin.y );
	CGRect imageBounds = CGRectMake( point.x, point.y, 16, 16 );
	CGImageRef windowImage = CGWindowListCreateImage( imageBounds, kCGWindowListOptionIncludingWindow, windowID, kCGWindowImageDefault );
	
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:windowImage];
	// [self setImage:[[NSImage alloc] initWithCGImage:windowImage size:NSMakeSize(16,16)]];
	NSColor *color = [rep colorAtX:0 y:0];
	CGImageRelease(windowImage);
	NSLog( @"Sampling %.0f,%.0f = %@", point.x, point.y, [color asHexString] );
	return color;
}

@end