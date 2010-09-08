//
//  FreemanAppDelegate.h
//  Freeman
//
//  Created by Matt Mower on 08/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanOverlayManager;

@interface FreemanAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow					*_window;
	
	FreemanOverlayManager		*_overlayManager;
}

@property (assign) IBOutlet NSWindow *window;

@end
