//
//  FreemanResultsView.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import "FreemanResultsView.h"

#import "FreemanOverlayManager.h"

#import "FreemanKeyCodes.h"


@implementation FreemanResultsView

@synthesize overlayManager = _overlayManager;

- (void)keyDown:(NSEvent *)event {
	// Enter or Return select the current result
	if( [event keyCode] == KEYCODE_ENTER || [event keyCode] == KEYCODE_RETURN ) {
		[[self overlayManager] insertModule:self];
	} else if( [event keyCode] == KEYCODE_ESCAPE ) {
		[[self overlayManager] closeAndActivateReaktor];
	} else {
		#ifdef DEBUG_FREEMAN
		NSLog( @"Key code = %d", [event keyCode] );
		#endif
		[super keyDown:event];
	}
}

@end
