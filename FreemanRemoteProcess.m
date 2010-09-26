//
//  FreemanRemoteProcess.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanRemoteProcess.h"

#import "FreemanAppDelegate.h"
#import "FreemanKeyMapper.h"

#define CGKEYCODE_RETURN (36)
#define CGKEYCODE_LEFT (123)
#define CGKEYCODE_RIGHT (124)
#define CGKEYCODE_DOWN (125)
#define CGKEYCODE_UP (126)

#define KEY_ACTION_INSERT @"insert"
#define KEY_ACTION_INSERT_AGAIN @"insert_again"
#define KEY_ACTION_INSERT_CONST @"insert_const"


@interface FreemanRemoteProcess (PrivateMethods)

- (void)installEventTap;
- (CGEventRef)createKeyboardEvent:(CGKeyCode)keyCode keyDown:(BOOL)keyDown;
- (CGKeyCode)mapSpecifierToKeyCode:(NSString *)specifier;

- (void)sendMouseEvent:(CGEventType)mouseType forButton:(CGMouseButton)button atPoint:(CGPoint)clickPoint;

- (void)pressedInsertAt:(CGPoint)point;
- (void)pressedReInsertAt:(CGPoint)point;
- (void)pressedInsertConstAt:(CGPoint)point;


@end


CGEventRef EventTapCallback( CGEventTapProxy proxy, CGEventType type, CGEventRef ref, void *refcon ) {
	UniChar key;
	UniCharCount keyLength;
	FreemanRemoteProcess *remoteProcess = (FreemanRemoteProcess *)refcon;
	
	switch( type ) {
		case kCGEventMouseMoved:
			[remoteProcess setMousePosition:CGEventGetLocation( ref )];
			break;
			
		case kCGEventKeyDown:
			if( [remoteProcess inFavouriteChordSequence] ) {
				[remoteProcess setInFavouriteChordSequence:NO];
				int favourite = mapKeyCodeToFavouriteNumber( CGEventGetIntegerValueField( ref, kCGKeyboardEventKeycode ) );
				if( favourite > 0 ) {
					[remoteProcess performSelectorOnMainThread:@selector(doFavouriteAction:) withObject:[NSNumber numberWithInteger:favourite] waitUntilDone:NO];
				}
			} else if( CGEventGetFlags( ref ) & kCGEventFlagMaskControl ) {
				CGEventKeyboardGetUnicodeString( ref, 1, &keyLength, &key );
				switch( key ) {
					case 0x01:
						[remoteProcess performSelectorOnMainThread:@selector(doKeyAction:) withObject:KEY_ACTION_INSERT waitUntilDone:NO];
						return NULL;
					case 0x12:
						[remoteProcess performSelectorOnMainThread:@selector(doKeyAction:) withObject:KEY_ACTION_INSERT_AGAIN waitUntilDone:NO];
						return NULL;
					case 0x03:
						[remoteProcess performSelectorOnMainThread:@selector(doKeyAction:) withObject:KEY_ACTION_INSERT_CONST waitUntilDone:NO];
						return NULL;
					case 0x06:
						[remoteProcess setInFavouriteChordSequence:YES];
						return NULL;
				}
			}
		
			break;
	}
	
	return ref;
}


@implementation FreemanRemoteProcess

@synthesize delegate                 = _delegate;
@synthesize psn                      = _psn;
@synthesize mousePosition            = _mousePosition;
@synthesize inFavouriteChordSequence = _inFavouriteChordSequence;


+ (id)remoteProcessWithSerialNumber:(ProcessSerialNumber)psn {
	return [[FreemanRemoteProcess alloc] initWithProcessSerialNumber:psn];
}


- (id)initWithProcessSerialNumber:(ProcessSerialNumber)psn {
	if( ( self = [super init] ) ) {
		_eventSourceRef = CGEventSourceCreate( kCGEventSourceStateCombinedSessionState ); // kCGEventSourceStateHIDSystemState );
		_psn = psn;
		[self installEventTap];
	}
	
	return self;
}


- (void)sendMouseEvent:(CGEventType)mouseType forButton:(CGMouseButton)button atPoint:(CGPoint)clickPoint {
	CGEventRef eventRef;
	
	eventRef = CGEventCreateMouseEvent( _eventSourceRef, mouseType, clickPoint, button );
	// Mask off any (keyboard) modifiers
	CGEventSetFlags( eventRef, 0 );
	CGEventPostToPSN( &_psn, eventRef );
	CFRelease( eventRef );

	eventRef = CGEventCreateMouseEvent( _eventSourceRef, mouseType, clickPoint, button );
	CGEventSetFlags( eventRef, 0 );
	CGEventPostToPSN( &_psn, eventRef );
	CFRelease( eventRef );
}


- (void)sendLeftMouseClick:(CGPoint)clickPoint {
	[self sendMouseEvent:kCGEventLeftMouseDown forButton:kCGMouseButtonLeft atPoint:clickPoint];
	[self sendMouseEvent:kCGEventLeftMouseUp forButton:kCGMouseButtonLeft atPoint:clickPoint];
}


- (void)sendRightMouseClick:(CGPoint)clickPoint {
	[self sendMouseEvent:kCGEventRightMouseDown forButton:kCGMouseButtonRight atPoint:clickPoint];
	[self sendMouseEvent:kCGEventRightMouseUp forButton:kCGMouseButtonRight atPoint:clickPoint];
}


- (CGEventRef)createKeyboardEvent:(CGKeyCode)keyCode keyDown:(BOOL)keyDown {
	CGEventRef ref = CGEventCreateKeyboardEvent( _eventSourceRef, keyCode, keyDown );
	if( keyCode == CGKEYCODE_RIGHT || keyCode == CGKEYCODE_DOWN ) {
		CGEventFlags flags = CGEventGetFlags( ref );
		flags = flags | kCGEventFlagMaskSecondaryFn | kCGEventFlagMaskNumericPad;
		CGEventSetFlags(ref, flags);
	}
	return ref;
}


- (void)sendKeyStroke:(CGKeyCode)keyCode {
	CGEventRef eventRef;
	
	eventRef = [self createKeyboardEvent:keyCode keyDown:YES];
	CGEventPostToPSN( &_psn, eventRef );
	CFRelease( eventRef );

	eventRef = [self createKeyboardEvent:keyCode keyDown:NO];
	CGEventPostToPSN( &_psn, eventRef );
	CFRelease( eventRef );
}


/*
 * The code using CGEventKeyboardSetUnicodeString() is probably the best philosophical
 * approach to the problem since it directly navigates the menus and will handle
 * language issues transparently. It's just a pity that it doesn't work when the
 * target application is Reaktor.
*/

// - (CGEventRef)createKeyboardEventForKey:(unichar)key keyDown:(BOOL)keyDown {
// 	CGEventRef ref = CGEventCreateKeyboardEvent( _eventSourceRef, 0, keyDown );
// 	CGEventKeyboardSetUnicodeString( ref, 1, &key );
// 	
// 	CGEventFlags flags = CGEventGetFlags( ref );
// 	// flags = 256;
// 	// CGEventSetFlags( ref, flags );
// 	NSLog( @"Flags" );
// 	if( flags & kCGEventFlagMaskAlphaShift ) {
// 		NSLog( @"NX_ALPHASHIFTMASK");
// 	}
// 	if( flags & kCGEventFlagMaskShift ) {
// 		NSLog( @"NX_SHIFTMASK");
// 	}
// 	if( flags & kCGEventFlagMaskControl ) {
// 		NSLog( @"NX_CONTROLMASK");
// 	}
// 	if( flags & kCGEventFlagMaskAlternate ) {
// 		NSLog( @"NX_ALTERNATEMASK");
// 	}
// 	if( flags & kCGEventFlagMaskCommand ) {
// 		NSLog( @"NX_COMMANDMASK");
// 	}
// 	if( flags & kCGEventFlagMaskHelp ) {
// 		NSLog( @"NX_HELPMASK");
// 	}
// 	if( flags & kCGEventFlagMaskSecondaryFn ) {
// 		NSLog( @"NX_SECONDARYFNMASK");
// 	}
// 	if( flags & kCGEventFlagMaskNumericPad ) {
// 		NSLog( @"NX_NUMERICPADMASK");
// 	}
// 	if( flags & kCGEventFlagMaskNonCoalesced ) {
// 		NSLog( @"NX_NONCOALSESCEDMASK");
// 	}
// 	
// 	return ref;
// }
// 
// 
// - (void)pressKey:(unichar)key {
// 	[self postEvent:^() { return [self createKeyboardEventForKey:key keyDown:YES]; }];
// 	[self postEvent:^() { return [self createKeyboardEventForKey:key keyDown:NO]; }];
// }
// 
// 
// - (void)sendString:(NSString *)string {
// 	// string = [string lowercaseString];
// 	// [self pressKey:[string characterAtIndex:0]];
// 	
// 	[self pressKey:'b'];
// 	// [self sendKeyStroke:11];
// 	
// 	// [self sendKeySequence:@"RD"];
// 	
// 	// for( int i = 0; i < [string length]; i++ ) {
// 	// 	unichar key = [string characterAtIndex:i];
// 	// 	NSLog( @"Press '%c'", key );
// 	// 	[self pressKey:key];
// 	// 	usleep(100000);
// 	// }
// }
// 
// 
// - (void)navigateMenu:(NSArray *)selections {
// 	[selections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
// 		NSLog( @"Send: [%@]", [obj name] );
// 		[self sendString:[obj name]];
// 		*stop = YES;
// 		// [self sendKeyStroke:CGKEYCODE_RETURN];
// 	}];
// }
// 

- (void)sendKeySequence:(NSString *)keys {
	#ifdef DEBUG_FREEMAN
	NSLog( @"sendKeySequence: %@", keys );
	#endif
	
	for( int i = 0; i < [keys length]; i++ ) {
		NSString *specifier = [keys substringWithRange:NSMakeRange(i, 1)];
		[self sendKeyStroke:[self mapSpecifierToKeyCode:specifier]];
		
		// This is a gross hack. For some reason if we send a cursor-down right after a cursor-right
		// (to open a submenu) then instead of moving the menu selection down one item, the selection
		// jumps to the bottom of the menu. This. is. not. good.
		// So we add a 125ms delay after opening the menu before allowing any other actions. On
		// my system at least this seems to work reliably but hard-coded delays are a sure indicator
		// of pain to come and I don't expect this one to be any different.
		if( [specifier isEqualToString:@"R"] ) {
			usleep(125000);
		}
	}
}


- (CGKeyCode)mapSpecifierToKeyCode:(NSString *)specifier {
	if( [specifier isEqualToString:@"D"] ) {
		return CGKEYCODE_DOWN;
	} else if( [specifier isEqualToString:@"U"] ) {
		return CGKEYCODE_UP;
	} else if( [specifier isEqualToString:@"L"] ) {
		return CGKEYCODE_LEFT;
	} else if( [specifier isEqualToString:@"R"] ) {
		return CGKEYCODE_RIGHT;
	} else if( [specifier isEqualToString:@"!"] ) {
		return CGKEYCODE_RETURN;
	} else {
		NSAssert1( NO, @"Unknown specified %@ encountered", specifier );
	}
	
	return 0;
}


#pragma mark Event tap management & responders

- (void)installEventTap {
	// We may be called in response to a failed resume call
	if( _tapMachPort ) {
		CFRelease( _tapMachPort );
	}
	
	_tapMachPort = CGEventTapCreateForPSN( &_psn, kCGHeadInsertEventTap, kCGEventTapOptionDefault, CGEventMaskBit(kCGEventMouseMoved) | CGEventMaskBit(kCGEventKeyDown), EventTapCallback, (void*)self );
	if( !_tapMachPort ) {
		[[NSAlert alertWithMessageText:@"Freeman Event Tap Failure"
	                                   defaultButton:@"Exit"
	                                 alternateButton:nil
	                                     otherButton:nil
	                       informativeTextWithFormat:@"Freeman cannot establish the Quartz event tap and cannot run. Please report this error!"] runModal];
		[NSApp terminate:self];
	}
	CFRunLoopSourceRef runLoopSourceRef = CFMachPortCreateRunLoopSource( kCFAllocatorDefault, _tapMachPort, 0 );
	CFRunLoopAddSource( CFRunLoopGetCurrent(), runLoopSourceRef, kCFRunLoopDefaultMode );
}


- (void)suspendEventTap {
	if( !CGEventTapIsEnabled( _tapMachPort) ) {
		return;
	}
	
	CGEventTapEnable( _tapMachPort, false );
	if( CGEventTapIsEnabled( _tapMachPort ) ) {
		NSLog( @"** Error **: Freeman could not suspend event tap!" );
		[[NSAlert alertWithMessageText:@"Event Tap Failure"
                                     defaultButton:@"Exit"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Freeman cannot suspend the Quartz event tap. Please report this error!"] runModal];
		[NSApp terminate:self];
	}
	NSLog( @"Event tap suspended" );
}


- (void)resumeEventTap {
	if( CGEventTapIsEnabled( _tapMachPort) ) {
		return;
	}
	
	CGEventTapEnable( _tapMachPort, true );
	if( !CGEventTapIsEnabled( _tapMachPort ) ) {
		NSLog( @"X-Experimental: Event tap could not be resumed, start new event tap" );
		[self installEventTap];
		
		
		
		[[NSAlert alertWithMessageText:@"Event Tap Failure"
                                     defaultButton:@"Exit"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Freeman cannot re-enable the Quartz event tap. Please report this error."] runModal];
		[NSApp terminate:self];
	}
	NSLog( @"Event tap resumed" );
}


- (void)doKeyAction:(id)action {
	if( [action isEqualToString:KEY_ACTION_INSERT] || [action isEqualToString:KEY_ACTION_INSERT_AGAIN] || [action isEqualToString:KEY_ACTION_INSERT_CONST ] ) {
		if( [action isEqualToString:KEY_ACTION_INSERT] ) {
			[[self delegate] triggerInsertModuleAtPoint:[self mousePosition]];
		} else if( [action isEqualToString:KEY_ACTION_INSERT_AGAIN] ) {
			[[self delegate] triggerReInsertModuleAtPoint:[self mousePosition]];
		} else if( [action isEqualToString:KEY_ACTION_INSERT_CONST ] ) {
			[[self delegate] triggerInsertConstModuleAtPoint:[self mousePosition]];
		}
		[self offsetMousePositionByDX:-8 DY:-8];
	}
}


- (void)offsetMousePositionByDX:(CGFloat)dx DY:(CGFloat)dy {
	[self setMousePosition:CGPointMake( [self mousePosition].x + dx, [self mousePosition].y + dy )];
}


- (void)doFavouriteAction:(id)favourite {
	[[self delegate] triggerInsertFavourite:[favourite integerValue] atPoint:[self mousePosition]];
	[self offsetMousePositionByDX:-8 DY:-8];
}


- (void)pressedInsertAt:(CGPoint)point {
	[[self delegate] triggerInsertModuleAtPoint:point];
}


- (void)pressedReInsertAt:(CGPoint)point {
	[[self delegate] triggerReInsertModuleAtPoint:point];
}


- (void)pressedInsertConstAt:(CGPoint)point {
	[[self delegate] triggerInsertConstModuleAtPoint:point];
}


- (void)activate {
	SetFrontProcess( &_psn );
}


@end
