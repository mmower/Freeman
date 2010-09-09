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
	NSMenu						*_statusMenu;
	NSStatusItem				*_statusItem;	
	FreemanOverlayManager		*_overlayManager;
	ProcessSerialNumber			_reaktorPSN;
	NSEvent						*_event;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) FreemanOverlayManager *overlayManager;
@property (assign) ProcessSerialNumber reaktorPSN;

@end
