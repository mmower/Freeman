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


#define TRIGGER_ACTION (0x01)


OSStatus HotKeyHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData );
OSStatus AppSwitchHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData );


FreemanAppDelegate *gDelegate = nil;

@interface FreemanAppDelegate (PrivateMethods)

- (void)registerHotKeys;
- (void)registerAppSwitch;
- (void)respondToHotKey;
- (void)trigger;

@end


@implementation FreemanAppDelegate

@synthesize window = _window;
@synthesize statusMenu = _statusMenu;

@synthesize overlayManager = _overlayManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if( !AXAPIEnabled() ) {
		NSLog( @"Universal access must be enabled or GrapplingIron can't work!" );
	} else {
		gDelegate = self;
		_overlayManager = [[FreemanOverlayManager alloc] init];
		[self registerHotKeys];
		[self registerAppSwitch];
	}
}


- (void)awakeFromNib {
	_statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[_statusItem setMenu:_statusMenu];
	[_statusItem setTitle:@"Freeman"];
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
	} else {
		NSLog( @"No overlay!" );
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
	ProcessSerialNumber psn;
	NSString *processName;
	
	GetFrontProcess( &psn );
	CopyProcessName( &psn, (CFStringRef*)&processName );
	
	NSLog( @"Front process is now: %@", processName );
	[[gDelegate overlayManager] setEnabled:[processName isEqualToString:@"Reaktor 5"]];
	
	return noErr;
}



@end
