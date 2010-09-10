//
//  FreemanResultsView.m
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanResultsView.h"

#import "FreemanOverlayManager.h"

@implementation FreemanResultsView

@synthesize overlayManager = _overlayManager;

- (void)keyDown:(NSEvent *)event {
	// Enter or Return select the current result
	if( [event keyCode] == 36 || [event keyCode] == 76 ) {
		[[self overlayManager] insertModule:self];
	} else {
		[super keyDown:event];
	}
}

@end
