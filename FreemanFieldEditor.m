//
//  FreemanFieldEditor.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanFieldEditor.h"

#import "FreemanOverlayManager.h"

@interface FreemanFieldEditor (PrivateMethods)

// - (NSUInteger)quickSelect:(NSEvent *)event;
// - (BOOL)optDown:(NSEvent *)event;

@end

@implementation FreemanFieldEditor

@synthesize overlayManager = _overlayManager;

- (void)keyDown:(NSEvent *)event {
	#ifdef DEBUG_FREEMAN
	NSLog( @"keyCode = %03d OPT=%@", [event keyCode], ([event modifierFlags] & NSAlternateKeyMask) ? @"Y" : @"N" );
	#endif
	[super keyDown:event];
	
	// if( [self optDown:event] && ([self quickSelect:event] > 0) ) {
	// 	// Swallow opt+quickselect key
	// } else {
	// 	[super keyDown:event];
	// }
}


// Swallow key-up events for the key-down events we are special processing
- (void)keyUp:(NSEvent *)event {
	[super keyUp:event];
	// if( ( [self optDown:event] && ([self quickSelect:event] > 0) )) {
	// 	NSLog( @"Dispatching quick-select" );
	// 	dispatch_async( dispatch_get_main_queue(), ^{
	// 		[[self overlayManager] quickSelect:[self quickSelect:event]];
	// 		});
	// } else {
	// 	[super keyUp:event];
	// }
}


// - (NSUInteger)quickSelect:(NSEvent *)event {
// 	return [[event charactersIgnoringModifiers] integerValue];
// }
// 
// 
// - (BOOL)optDown:(NSEvent *)event {
// 	return ([event modifierFlags] & NSAlternateKeyMask) == NSAlternateKeyMask;
// }


@end
