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

#define TRIGGER_ACTION (0x01)


OSStatus HotKeyHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData );
OSStatus AppSwitchHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData );


FreemanAppDelegate *gDelegate = nil;


@interface FreemanAppDelegate (PrivateMethods)

- (void)registerHotKeys;
- (void)registerAppSwitch;
- (void)registerEvent:(NSEvent *)event;
- (void)respondToHotKey;
- (void)trigger;

@end


@implementation FreemanAppDelegate


@synthesize window = _window;
@synthesize statusMenu = _statusMenu;
@synthesize statusItem = _statusItem;

@synthesize overlayManager = _overlayManager;
@synthesize moduleDatabase = _moduleDatabase;
@synthesize reaktorProcess = _reaktorProcess;


- (id)init {
	if( ( self = [super init] ) ) {
		_moduleDatabase = [[FreemanModuleDatabase alloc] init];
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

- (void)registerHotKeys {
    EventHotKeyID hotKeyID;
    EventHotKeyRef hotKeyRef;
	
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    
    InstallApplicationEventHandler( &HotKeyHandler, 1, &eventType, NULL, NULL );
    
    hotKeyID.signature = 'grp1';
    hotKeyID.id = TRIGGER_ACTION;
    RegisterEventHotKey( 34 /* i */, cmdKey+optionKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef );
}


OSStatus HotKeyHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData ) {
#pragma unused(nextHandler)
#pragma unused(theEvent)
#pragma unused(userData)
    
    //Do something once the key is pressed 
    
    EventHotKeyID keyId;
    GetEventParameter( theEvent,
					  kEventParamDirectObject,
					  typeEventHotKeyID,
					  NULL,
					  sizeof( keyId ),
					  NULL,
					  &keyId);
    
    switch( keyId.id ) {
        case TRIGGER_ACTION:
			[gDelegate respondToHotKey];
            break;
    }
    
    return noErr;
}


- (void)respondToHotKey {
	[_overlayManager prompt];
}


- (void)insertModule:(FreemanModule *)module {
	CGFloat ydepth = [[NSScreen mainScreen] frame].size.height;
	CGPoint clickPoint = CGPointMake([_event locationInWindow].x, ydepth-[_event locationInWindow].y);
	[module insertAt:clickPoint inReaktorProcess:_reaktorProcess];
	// 
	// [_reaktorProcess sendRightMouseClick:clickPoint];
	// [_reaktorProcess sendKeySequence:[module completeNavigationSequence]];
}


- (void)activateReaktor {
	[[self reaktorProcess] activate];
}


#pragma mark mouse detection

- (void)registerEvent:(NSEvent *)event {
	if( [[self overlayManager] enabled] ) {
		if( [event modifierFlags] & NSAlternateKeyMask ) {
			_event = event;
			[_overlayManager prompt];
		}
	}
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
