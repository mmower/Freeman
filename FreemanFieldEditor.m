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

- (NSUInteger)quickSelect:(NSEvent *)event;
- (BOOL)optDown:(NSEvent *)event;

@end


@implementation FreemanFieldEditor

@synthesize overlayManager = _overlayManager;

- (void)keyDown:(NSEvent *)event {
	// NSLog( @"keyCode = %03d OPT=%@", [event keyCode], ([event modifierFlags] & NSAlternateKeyMask) ? @"Y" : @"N" );
	
	if( [self optDown:event] && ([self quickSelect:event] > 0) ) {
		dispatch_async( dispatch_get_main_queue(), ^{
			
			});
		[[self overlayManager] quickSelect:[self quickSelect:event]];
	} else {
		[super keyDown:event];
	}
}


// Swallow key-up events for the key-down events we are special processing
// - (void)keyUp:(NSEvent *)event {
// 	if( !( [self optDown:event] && ([self quickSelect:event] > 0) )) {
// 		[super keyUp:event];
// 	}
// }


- (NSUInteger)quickSelect:(NSEvent *)event {
	return [[event charactersIgnoringModifiers] integerValue];
}


- (BOOL)optDown:(NSEvent *)event {
	return ([event modifierFlags] & NSAlternateKeyMask) == NSAlternateKeyMask;
}


@end
