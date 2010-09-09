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
@synthesize reaktorProcess = _reaktorProcess;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if( !AXAPIEnabled() ) {
		NSLog( @"Universal access must be enabled or GrapplingIron can't work!" );
	} else {
		gDelegate = self;
		_overlayManager = [[FreemanOverlayManager alloc] init];
		[self registerHotKeys];
		[self registerAppSwitch];
		
		[NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskFromType(NSLeftMouseDown) handler:^(NSEvent *event) {
			[self registerEvent:event];
		}];
	}
}


- (void)awakeFromNib {
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[_statusItem setMenu:_statusMenu];
	[_statusItem setTitle:@"R"];
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
	if( [_overlayManager enabled] ) {
		NSLog( @"Overlay!" );
		CGFloat ydepth = [[NSScreen mainScreen] frame].size.height;
		CGPoint clickPoint = CGPointMake([_event locationInWindow].x, ydepth-[_event locationInWindow].y);
		[_reaktorProcess sendRightMouseClick:clickPoint];
		[_reaktorProcess sendKeySequence:@"RRDR!"];
	} else {
		NSLog( @"No overlay!" );
	}
}


#pragma mark mouse detection

- (void)registerEvent:(NSEvent *)event {
	if( [[self overlayManager] enabled] ) {
		_event = event;
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
	NSLog( @"Front process is now: %@", processName );
	
	if( [processName isEqualToString:@"Reaktor 5"] ) {
		[gDelegate setReaktorProcess:[FreemanRemoteProcess remoteProcessWithSerialNumber:psn]];
		[[gDelegate statusItem] setTitle:@"R!"];
		[[gDelegate overlayManager] setEnabled:YES];
	} else {
		[[gDelegate statusItem] setTitle:@"R"];
		[[gDelegate overlayManager] setEnabled:NO];
	}
	
	return noErr;
}



@end
