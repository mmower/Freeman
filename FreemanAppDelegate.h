//
//  FreemanAppDelegate.h
//  Freeman
//
//  Created by Matt Mower on 08/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanOverlayManager;
@class FreemanFavouritesManager;
@class FreemanRemoteProcess;
@class FreemanModuleDatabase;
@class FreemanModule;

@interface FreemanAppDelegate : NSObject {
  NSWindow									*_window;
	NSMenu										*_statusMenu;
	NSStatusItem							*_statusItem;	
	FreemanOverlayManager			*_overlayManager;
	FreemanFavouritesManager	*_favouritesManager;
	FreemanRemoteProcess			*_reaktorProcess;
	FreemanModuleDatabase			*_primaryModuleDatabase;
	FreemanModuleDatabase			*_coreModuleDatabase;
	FreemanModule							*_lastInsertedPrimaryModule;
	FreemanModule							*_lastInsertedCoreModule;
	CGPoint										_location;
	
	NSImage									*_image;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) NSImage *image;
@property (assign) NSStatusItem *statusItem;
@property (assign) FreemanOverlayManager *overlayManager;
@property (assign) FreemanFavouritesManager *favouritesManager;
@property (assign) FreemanModuleDatabase *primaryModuleDatabase;
@property (assign) FreemanModuleDatabase *coreModuleDatabase;
@property (assign) FreemanRemoteProcess *reaktorProcess;

- (void)triggerInsertModuleAtPoint:(CGPoint)point;
- (void)triggerReInsertModuleAtPoint:(CGPoint)point;
- (void)triggerInsertConstModuleAtPoint:(CGPoint)point;

- (void)triggerSetPrimaryStructureColourFromPoint:(CGPoint)point;
- (void)triggerSetCoreStructureColourFromPoint:(CGPoint)point;

- (void)insertModule:(FreemanModule *)module;

- (void)setFavourite:(FreemanModule *)module inSlot:(NSInteger)slot;
- (void)triggerInsertFavourite:(NSInteger)favouriteNumber atPoint:(CGPoint)point;

- (void)showFavouritesAtPoint:(CGPoint)point;
- (void)hideFavourites;

- (void)activateReaktor;

- (IBAction)showAboutBox:(id)sender;

@end
