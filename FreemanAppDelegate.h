//
//  FreemanAppDelegate.h
//  Freeman
//
//  Created by Matt Mower on 08/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanOverlayManager;
@class FreemanRemoteProcess;
@class FreemanModuleDatabase;
@class FreemanModule;

@interface FreemanAppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow								*_window;
	NSMenu									*_statusMenu;
	NSStatusItem						*_statusItem;	
	FreemanOverlayManager		*_overlayManager;
	FreemanRemoteProcess		*_reaktorProcess;
	FreemanModuleDatabase		*_moduleDatabase;
	NSEvent									*_event;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) NSStatusItem *statusItem;
@property (assign) FreemanOverlayManager *overlayManager;
@property (assign) FreemanModuleDatabase *moduleDatabase;
@property (assign) FreemanRemoteProcess *reaktorProcess;

- (void)insertModule:(FreemanModule *)module;

- (void)activateReaktor;

- (IBAction)showAboutBox:(id)sender;

@end
