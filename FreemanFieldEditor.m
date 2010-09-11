//
//  FreemanFieldEditor.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanFieldEditor.h"

#import "FreemanOverlayManager.h"

@implementation FreemanFieldEditor

@synthesize overlayManager = _overlayManager;

- (void)keyDown:(NSEvent *)event {
	NSLog( @"keyCode = %03d OPT=%@", [event keyCode], ([event modifierFlags] & NSAlternateKeyMask) ? @"Y" : @"N" );
	
	NSString *chars = [event charactersIgnoringModifiers];
	NSLog( @"chars = %d", [chars integerValue] );
	
	[super keyDown:event];
}


// Swallow key-up events for the key-down events we are special processing
- (void)keyUp:(NSEvent *)event {
	[super keyUp:event];
}


// - (int)favouriteNumber:(NSString *)chars {
// }


@end
