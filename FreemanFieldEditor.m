//
//  FreemanFieldEditor.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanFieldEditor.h"

#import "FreemanOverlayManager.h"
#import "FreemanKeyMapper.h"

// #define DEBUG_FREEMAN 1

@interface FreemanFieldEditor (PrivateMethods)

- (BOOL)favouriteModifiers:(NSEvent *)event;

@end

@implementation FreemanFieldEditor

@synthesize overlayManager = _overlayManager;

- (void)keyDown:(NSEvent *)event {
	
	#ifdef DEBUG_FREEMAN
	NSLog( @"keyCode = %03d FAV=%@", [event keyCode], ([event modifierFlags] & NSShiftKeyMask && [event modifierFlags] & NSControlKeyMask) ? @"Y" : @"N" );
	#endif

	int favourite = mapKeyCodeToFavouriteNumber( [event keyCode] );
	
	if( ( [self favouriteModifiers:event] ) && ( favourite > 0 ) ) {
		[[self overlayManager] setFavourite:favourite];
	} else {
		[super keyDown:event];
	}
}


// Swallow key-up events for the key-down events we are special processing
- (void)keyUp:(NSEvent *)event {
	if( !( ( [self favouriteModifiers:event] ) && ( mapKeyCodeToFavouriteNumber( [event keyCode] ) > 0 ) ) ) {
		[super keyUp:event];
	}
}


- (BOOL)favouriteModifiers:(NSEvent *)event {
	return [event modifierFlags] & NSControlKeyMask && [event modifierFlags] & NSShiftKeyMask;
}


@end
