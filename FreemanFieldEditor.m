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
	
	if( ([event modifierFlags] & NSAlternateKeyMask) && [event charactersIgnoringModifi] >= 18 && [event keyCode] <= 22 ) {
		NSBeep();
	} else {
		[super keyDown:event];
	}
}


// Swallow key-up events for the key-down events we are special processing
- (void)keyUp:(NSEvent *)event {
	if( !(([event modifierFlags] & NSAlternateKeyMask) && [event keyCode] >= 18 && [event keyCode] <= 22) ) {
		[super keyUp:event];
	}
}


end
