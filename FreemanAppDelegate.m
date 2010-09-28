//
//  FreemanAppDelegate.m
//  Freeman
//
//  Created by Matt Mower on 08/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FreemanAppDelegate.h"

#import <Carbon/Carbon.h>
#import <AppKit/NSAccessibility.h>
#import <ApplicationServices/ApplicationServices.h>

#import "FreemanOverlayManager.h"
#import "FreemanFavouritesManager.h"
#import "FreemanRemoteProcess.h"
#import "FreemanModuleDatabase.h"
#import "FreemanModule.h"
#import "FreemanPreferences.h"

#import "NSColor+Freeman.h"
#import "NSScreen+Freeman.h"


OSStatus AppSwitchHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData );


FreemanAppDelegate *gDelegate = nil;


@interface FreemanAppDelegate (PrivateMethods)

- (void)registerAppSwitch;
- (FreemanModuleDatabase *)moduleDatabaseAtPoint:(CGPoint)point;
- (FreemanModuleDatabase *)moduleDatabaseFromBackgroundColor:(NSColor *)backgroundColor;

@end


@implementation FreemanAppDelegate

@synthesize window = _window;
@synthesize statusMenu = _statusMenu;
@synthesize statusItem = _statusItem;
@synthesize image = _image;

@synthesize overlayManager = _overlayManager;
@synthesize favouritesManager = _favouritesManager;
@synthesize primaryModuleDatabase = _primaryModuleDatabase;
@synthesize coreModuleDatabase = _coreModuleDatabase;
@synthesize reaktorProcess = _reaktorProcess;


- (id)init {
	if( ( self = [super init] ) ) {
		_primaryModuleDatabase = [[FreemanModuleDatabase alloc] initPrimaryModuleDatabase];
		_coreModuleDatabase = [[FreemanModuleDatabase alloc] initCoreModuleDatabase];
		_favouritesManager = [[FreemanFavouritesManager alloc] init];
	}
	
	return self;
}


- (void)setReaktorProcess:(FreemanRemoteProcess *)reaktorProcess {
	_reaktorProcess = reaktorProcess;
	[_reaktorProcess setDelegate:self];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if( !AXAPIEnabled() ) {
		NSLog( @"Access for Assistive Devices is not enabled!" );
		NSAlert *alert = [NSAlert alertWithMessageText:@"Freeman cannot start"
                                     defaultButton:@"Exit"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Freeman requires access for assistive devices to be enabled in the universal access system preferences pane. Please enable this setting before starting Freeman again."];

		[alert runModal];
		[NSApp terminate:self];
	} else {
		gDelegate = self;
		_overlayManager = [[FreemanOverlayManager alloc] initWithDelegate:self];
		[self registerAppSwitch];
	}
}


- (void)awakeFromNib {
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[_statusItem setMenu:_statusMenu];
	[_statusItem setImage:[NSImage imageNamed:@"MenuNormal.png"]];
	[_statusItem setHighlightMode:YES];
}


- (void)insertModule:(FreemanModule *)module {
	if( [module primary] ) {
		_lastInsertedPrimaryModule = module;
	} else {
		_lastInsertedCoreModule = module;
	}
	
	[[self reaktorProcess] suspendEventTap];
	[module insertAt:_location inReaktorProcess:_reaktorProcess];
	[[self reaktorProcess] resumeEventTap];
}


- (void)activateReaktor {
	[[self reaktorProcess] activate];
	[[self reaktorProcess] resumeEventTap];
}


- (void)triggerInsertModuleAtPoint:(CGPoint)point {
	_location = point;
	FreemanModuleDatabase *moduleDatabase = [self moduleDatabaseAtPoint:_location];
	if( !moduleDatabase ) {
		NSBeep();
		return;
	}
	
	[[self reaktorProcess] suspendEventTap];
	[_overlayManager searchModules:moduleDatabase fromPoint:point];
}


- (void)triggerReInsertModuleAtPoint:(CGPoint)point {
	_location = point;
	FreemanModuleDatabase *moduleDatabase = [self moduleDatabaseAtPoint:_location];
	if( !moduleDatabase ) {
		NSBeep();
		return;
	}
	
	if( [moduleDatabase primary] && _lastInsertedPrimaryModule ) {
		[self insertModule:_lastInsertedPrimaryModule];
	} else if( _lastInsertedCoreModule ) {
		[self insertModule:_lastInsertedCoreModule];
	}
}


- (void)triggerInsertConstModuleAtPoint:(CGPoint)point {
	_location = point;
	FreemanModuleDatabase *moduleDatabase = [self moduleDatabaseAtPoint:_location];
	if( !moduleDatabase ) {
		NSBeep();
		return;
	}
	
	[self insertModule:[moduleDatabase constModule]];
}


- (FreemanModuleDatabase *)moduleDatabaseAtPoint:(CGPoint)point {
	return [self moduleDatabaseFromBackgroundColor:[NSColor colorAtLocation:[[NSScreen mainScreen] flipPoint:point]]];
}


- (FreemanModuleDatabase *)moduleDatabaseFromBackgroundColor:(NSColor *)backgroundColor {
	if( [backgroundColor isSameColorInRGB:[FreemanPreferences primaryStructureColor]] ) {
		return _primaryModuleDatabase;
	} else if( [backgroundColor isSameColorInRGB:[FreemanPreferences coreStructureColor]] ) {
		return _coreModuleDatabase;
	} else {
		return nil;
	}
}


- (void)showFavouritesAtPoint:(CGPoint)point {
	FreemanModuleDatabase *database = [self moduleDatabaseAtPoint:point];
	if( database ) {
		[_favouritesManager showForModuleDatabase:database atPoint:point];
	} else {
		[_favouritesManager hide];
	}
}


- (void)hideFavourites {
	[_favouritesManager hide];
}


- (void)setFavourite:(FreemanModule *)module inSlot:(NSInteger)slot {
	if( [module primary] ) {
		[FreemanPreferences setPrimaryFavourite:[module path] inSlot:slot];
	} else {
		[FreemanPreferences setCoreFavourite:[module path] inSlot:slot];
	}
}


- (void)triggerInsertFavourite:(NSInteger)favouriteNumber atPoint:(CGPoint)point {
	NSLog( @"Insert favourite at (%.0f,%.0f)", point.x, point.y );
	_location = point;
	FreemanModuleDatabase *moduleDatabase = [self moduleDatabaseFromBackgroundColor:[NSColor colorAtLocation:[[NSScreen mainScreen] flipPoint:_location]]];
	if( !moduleDatabase ) {
		NSBeep();
		return;
	}
	
	NSString *modulePath = nil;
	if( [moduleDatabase primary] ) {
		modulePath = [FreemanPreferences primaryFavouriteInSlot:favouriteNumber];
	} else {
		modulePath = [FreemanPreferences coreFavouriteInSlot:favouriteNumber];
	}
	
	if( !modulePath ) {
		NSBeep();
		return;
	}
	
	FreemanModule *module = [moduleDatabase moduleWithPath:modulePath];
	if( !module ) {
		NSBeep();
		return;
	}
	
	[self insertModule:module];
}


// - (NSDictionary *)windowInfo:(CGWindowID)windowID {
// 	CGWindowID *windowIDs = calloc( 1, sizeof(CGWindowID) );
// 	windowIDs[0] = windowID;
// 	NSArray *targetWindowNumbers = (NSArray *)CFArrayCreate( kCFAllocatorDefault, (const void**)windowIDs, 1, NULL );
// 	free( windowIDs );
// 	NSArray *windowInfo = (NSArray*)CGWindowListCreateDescriptionFromArray( (CFArrayRef)targetWindowNumbers );
// 	NSAssert( windowInfo && [windowInfo count] == 1, @"Cannot get info from window server" );
// 	return [windowInfo objectAtIndex:0];
// }
// 
// 
// - (CGRect)getWindowBounds:(CGWindowID)windowID {
// 	CGRect windowBounds;
// 	NSDictionary *windowInfo = [self windowInfo:windowID];
// 	CGRectMakeWithDictionaryRepresentation( (CFDictionaryRef)[windowInfo objectForKey:(NSString*)kCGWindowBounds], &windowBounds );
// 	return windowBounds;
// }





#pragma mark app switch handling


- (void)registerAppSwitch {
	EventTypeSpec spec = { kEventClassApplication, kEventAppFrontSwitched };
    
    OSStatus err = InstallApplicationEventHandler(NewEventHandlerUPP(AppSwitchHandler), 1, &spec, (void*)self, NULL);
    if( err ) {
        NSLog( @"Uh oh..." );
    }
}

OSStatus AppSwitchHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData ) {
	NSString *processName;
	ProcessSerialNumber psn;
	
	GetFrontProcess( &psn );
	CopyProcessName( &psn, (CFStringRef*)&processName );
	
	#ifdef DEBUG_FREEMAN
	NSLog( @"Front process is now: %@", processName );
	#endif
	
	if( ![processName isEqualToString:@"Freeman"] && [[[gDelegate overlayManager] window] isVisible] ) {
		[[gDelegate overlayManager] close];
	}
	
	if( [processName isEqualToString:@"Reaktor 5"] ) {
		if( ![gDelegate reaktorProcess] ) {
			[gDelegate setReaktorProcess:[FreemanRemoteProcess remoteProcessWithSerialNumber:psn]];
		}
		
		NSLog( @"Activating reatkor" );
		[[gDelegate reaktorProcess] resumeEventTap];
		[[gDelegate statusItem] setImage:[NSImage imageNamed:@"MenuActive.png"]];
		[[gDelegate overlayManager] setEnabled:YES];
	} else {
		[[gDelegate statusItem] setImage:[NSImage imageNamed:@"MenuNormal.png"]];
		[[gDelegate overlayManager] setEnabled:NO];
		[[gDelegate reaktorProcess] setInFavouriteChordSequence:NO];
	}
	
	return noErr;
}


#pragma mark menubar apps

- (IBAction)showAboutBox:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	[NSApp orderFrontStandardAboutPanel:sender];
}

@end
