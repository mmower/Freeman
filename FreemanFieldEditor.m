//
//  FreemanFieldEditor.m
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
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
	
	if( _inQuickSelect ) {
		_inQuickSelect = NO;
		int favourite = mapKeyCodeToFavouriteNumber( [event keyCode] );
		if( favourite > 0 ) {
			[[self overlayManager] setFavourite:favourite];
		}
	} else if( [event modifierFlags] & NSControlKeyMask && [event keyCode] == 0x03 ) {
		_inQuickSelect = YES;
	} else {
		_inQuickSelect = NO;
		[super keyDown:event];
	}
}


// Swallow key-up events for the key-down events we are special processing
// - (void)keyUp:(NSEvent *)event {
// 	[super keyUp:event];
// }


// - (BOOL)favouriteModifiers:(NSEvent *)event {
// 	return [event modifierFlags] & NSControlKeyMask && [event modifierFlags] & NSShiftKeyMask;
// }

@end
