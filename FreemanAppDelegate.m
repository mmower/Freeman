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

- (void)registerHotKeys;
- (void)registerAppSwitch;
- (void)registerEvent:(NSEvent *)event;
- (void)respondToHotKey;
- (void)trigger;
- (NSColor *)sampleWindow:(CGWindowID)windowID atPoint:(CGPoint)point;

@end


@implementation FreemanAppDelegate


@synthesize window = _window;
@synthesize statusMenu = _statusMenu;
@synthesize statusItem = _statusItem;

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


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if( !AXAPIEnabled() ) {
		NSLog( @"Universal access must be enabled or GrapplingIron can't work!" );
	} else {
		gDelegate = self;
		_overlayManager = [[FreemanOverlayManager alloc] initWithDelegate:self];
		// [self registerHotKeys];
		[self registerAppSwitch];
		
		[NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskFromType(NSLeftMouseDown) handler:^(NSEvent *event) {
			[self registerEvent:event];
		}];
	}
}


- (void)awakeFromNib {
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[_statusItem setMenu:_statusMenu];
	[_statusItem setImage:[NSImage imageNamed:@"MenuNormal.png"]];
	// [_statusItem setTitle:@"R"];
	[_statusItem setHighlightMode:YES];
}


- (void)trigger {
}


#pragma mark Hotkey management

// - (void)registerHotKeys {
//     EventHotKeyID hotKeyID;
//     EventHotKeyRef hotKeyRef;
// 	
//     EventTypeSpec eventType;
//     eventType.eventClass=kEventClassKeyboard;
//     eventType.eventKind=kEventHotKeyPressed;
//     
//     InstallApplicationEventHandler( &HotKeyHandler, 1, &eventType, NULL, NULL );
//     
//     hotKeyID.signature = 'grp1';
//     hotKeyID.id = TRIGGER_ACTION;
//     RegisterEventHotKey( 34 /* i */, cmdKey+optionKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef );
// }


// OSStatus HotKeyHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData ) {
// #pragma unused(nextHandler)
// #pragma unused(theEvent)
// #pragma unused(userData)
//     
//     //Do something once the key is pressed 
//     
//     EventHotKeyID keyId;
//     GetEventParameter( theEvent,
// 					  kEventParamDirectObject,
// 					  typeEventHotKeyID,
// 					  NULL,
// 					  sizeof( keyId ),
// 					  NULL,
// 					  &keyId);
//     
//     switch( keyId.id ) {
//         case TRIGGER_ACTION:
// 			[gDelegate respondToHotKey];
//             break;
//     }
//     
//     return noErr;
// }


// - (void)respondToHotKey {
// 	[_overlayManager prompt];
// }


- (CGPoint)screenCoordinateForEvent:(NSEvent *)event {
	CGFloat ydepth = [[NSScreen mainScreen] frame].size.height;
	CGPoint clickPoint = CGPointMake([_event locationInWindow].x, ydepth-[_event locationInWindow].y);
	return clickPoint;
}


- (void)insertModule:(FreemanModule *)module {
	[module insertAt:[self screenCoordinateForEvent:_event] inReaktorProcess:_reaktorProcess];
}


- (void)activateReaktor {
	[[self reaktorProcess] activate];
}


#pragma mark mouse detection

- (void)registerEvent:(NSEvent *)event {
	if( [[self overlayManager] enabled] ) {
		if( [event modifierFlags] & NSAlternateKeyMask ) {
			_event = event;
			CGPoint screenPoint = [self screenCoordinateForEvent:event];
			NSPoint windowPoint = NSMakePoint( screenPoint.x, screenPoint.y );
			NSInteger windowNumber = [NSWindow windowNumberAtPoint:windowPoint belowWindowWithWindowNumber:0];
			NSColor *color = [self sampleWindow:windowNumber atPoint:screenPoint];
			NSLog( @"COLOR = %@", [color asHexString] );
			
			if( [[color asHexString] isEqualToString:STRUCTURE_BACKGROUND] ) {
				[_overlayManager searchModules:[self primaryModuleDatabase]];	
			} else if( [[color asHexString] isEqualToString:CORE_BACKGROUND] ) {
				[_overlayManager searchModules:[self coreModuleDatabase]];
			} else {
				NSBeep();
			}
		}
	}
}


-(NSColor *)sampleWindow:(CGWindowID)windowID atPoint:(CGPoint)point {
	CGRect imageBounds = CGRectMake( point.x, point.y, 1, 1 );
	CGImageRef windowImage = CGWindowListCreateImage( imageBounds, kCGWindowListOptionIncludingWindow, windowID, kCGWindowImageDefault );
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCGImage:windowImage];
	NSColor *color = [rep colorAtX:0 y:0];
	CGImageRelease(windowImage);
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
		[gDelegate setReaktorProcess:[FreemanRemoteProcess remoteProcessWithSerialNumber:psn]];
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
