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
#import "FreemanRemoteProcess.h"
#import "FreemanModuleDatabase.h"
#import "FreemanModule.h"

#import "NSColor+Freeman.h"

// #define TRIGGER_ACTION (0x01)

#define STRUCTURE_BACKGROUND @"#454E58"
#define CORE_BACKGROUND @"#242A30"


OSStatus HotKeyHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData );
OSStatus AppSwitchHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData );


FreemanAppDelegate *gDelegate = nil;


@interface FreemanAppDelegate (PrivateMethods)

- (void)registerAppSwitch;
- (CGPoint)flipPoint:(CGPoint)point;
- (CGPoint)windowPointToScreenPoint:(CGPoint)point;
- (NSColor *)colorAtLocation:(CGPoint)location;
- (NSColor *)sampleWindow:(CGWindowID)windowID atPoint:(CGPoint)point;

@end


@implementation FreemanAppDelegate

@synthesize window = _window;
@synthesize statusMenu = _statusMenu;
@synthesize statusItem = _statusItem;
@synthesize image = _image;

@synthesize overlayManager = _overlayManager;
@synthesize primaryModuleDatabase = _primaryModuleDatabase;
@synthesize coreModuleDatabase = _coreModuleDatabase;
@synthesize reaktorProcess = _reaktorProcess;


- (id)init {
	if( ( self = [super init] ) ) {
		_primaryModuleDatabase = [[FreemanModuleDatabase alloc] initPrimaryModuleDatabase];
		_coreModuleDatabase = [[FreemanModuleDatabase alloc] initCoreModuleDatabase];
	}
	
	return self;
}


- (void)setReaktorProcess:(FreemanRemoteProcess *)reaktorProcess {
	_reaktorProcess = reaktorProcess;
	[_reaktorProcess setDelegate:self];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if( !AXAPIEnabled() ) {
		NSLog( @"Universal access must be enabled or GrapplingIron can't work!" );
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


- (CGPoint)windowPointToScreenPoint:(CGPoint)point {
	CGFloat ydepth = [[NSScreen mainScreen] frame].size.height;
	return CGPointMake(point.x, ydepth-point.y);
}


- (void)insertModule:(FreemanModule *)module {
	_lastInsertedModule = module;
	[module insertAt:_location inReaktorProcess:_reaktorProcess];
}


- (void)activateReaktor {
	[[self reaktorProcess] activate];
}


- (CGPoint)flipPoint:(CGPoint)point {
	NSScreen *screen = [NSScreen mainScreen];
	return CGPointMake( point.x, screen.frame.size.height - point.y );
}


- (void)triggerInsertModuleAtPoint:(CGPoint)point {
	_location = point;
	NSColor *color = [self colorAtLocation:[self flipPoint:_location]];
	if( [[color asHexString] isEqualToString:STRUCTURE_BACKGROUND] ) {
		[_overlayManager searchModules:[self primaryModuleDatabase]];	
	} else if( [[color asHexString] isEqualToString:CORE_BACKGROUND] ) {
		[_overlayManager searchModules:[self coreModuleDatabase]];
	} else {
		NSBeep();
	}
}


- (void)triggerReInsertModuleAtPoint:(CGPoint)point {
	NSLog( @"triggerReInsertModuleAtPoint: %@", [_lastInsertedModule name] );
	if( _lastInsertedModule ) {
		_location = point;
		NSColor *color = [self colorAtLocation:_location];
		if( [[color asHexString] isEqualToString:STRUCTURE_BACKGROUND] ) {
			[_overlayManager insertModule:_lastInsertedModule];	
		} else if( [[color asHexString] isEqualToString:CORE_BACKGROUND] ) {
			[_overlayManager insertModule:_lastInsertedModule];
		} else {
			NSBeep();
		}
	} else {
		NSBeep();
	}
}


- (NSColor *)colorAtLocation:(CGPoint)screenPoint {
	NSPoint windowPoint = NSMakePoint( screenPoint.x, screenPoint.y );
	NSInteger windowNumber = [NSWindow windowNumberAtPoint:windowPoint belowWindowWithWindowNumber:0];
	NSColor *color = [self sampleWindow:windowNumber atPoint:[self flipPoint:screenPoint]];
	NSLog( @"Window %d @ %.0f,%.0f = %d (%@)", windowNumber, screenPoint.x, screenPoint.y, windowNumber, [color asHexString] );
	NSLog( @"--------------------------------" );
	return color;
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


- (NSColor *)sampleWindow:(CGWindowID)windowID atPoint:(CGPoint)point {
	// CGRect windowBounds = [self getWindowBounds:windowID];
	// NSLog( @"Window is at %.0f,%.0f", windowBounds.origin.x, windowBounds.origin.y );
	// CGPoint samplePoint = CGPointMake( point.x - windowBounds.origin.x, point.y - windowBounds.origin.y );
	CGRect imageBounds = CGRectMake( point.x, point.y, 16, 16 );
	CGImageRef windowImage = CGWindowListCreateImage( imageBounds, kCGWindowListOptionIncludingWindow, windowID, kCGWindowImageDefault );
	
	
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:windowImage];
	[self setImage:[[NSImage alloc] initWithCGImage:windowImage size:NSMakeSize(16,16)]];
	NSColor *color = [rep colorAtX:0 y:0];
	CGImageRelease(windowImage);
	NSLog( @"Sampling %.0f,%.0f = %@", point.x, point.y, [color asHexString] );
	return color;
}


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
		[[gDelegate statusItem] setImage:[NSImage imageNamed:@"MenuActive.png"]];
		[[gDelegate overlayManager] setEnabled:YES];
	} else {
		[[gDelegate statusItem] setImage:[NSImage imageNamed:@"MenuNormal.png"]];
		[[gDelegate overlayManager] setEnabled:NO];
	}
	
	return noErr;
}


#pragma mark menubar apps

- (IBAction)showAboutBox:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	[NSApp orderFrontStandardAboutPanel:sender];
}

@end
