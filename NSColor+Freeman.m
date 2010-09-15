//
//  NSColor+Freeman.m
//  Freeman
//
//  Code courtesy of Apple
//	http://developer.apple.com/library/mac/#qa/qa2007/qa1576.html
//

#import "NSColor+Freeman.h"

@implementation NSColor (Freeman)

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

@end