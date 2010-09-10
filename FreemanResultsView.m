//
//  FreemanResultsView.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanResultsView.h"

#import "FreemanOverlayManager.h"

#define KEYCODE_ENTER (36)
#define KEYCODE_RETURN (76)
#define KEYCODE_ESCAPE (53)

@implementation FreemanResultsView

@synthesize overlayManager = _overlayManager;

- (void)keyDown:(NSEvent *)event {
	// Enter or Return select the current result
	if( [event keyCode] == KEYCODE_ENTER || [event keyCode] == KEYCODE_RETURN ) {
		[[self overlayManager] insertModule:self];
	} else if( [event keyCode] == KEYCODE_ESCAPE ) {
		[[self overlayManager] closeAndActivateReaktor];
	} else {
		// NSLog( @"Key code = %d", [event keyCode] );
		[super keyDown:event];
	}
}

@end
