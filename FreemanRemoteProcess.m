//
//  FreemanRemoteProcess.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanRemoteProcess.h"

#define CGKEYCODE_RETURN (36)
#define CGKEYCODE_LEFT (123)
#define CGKEYCODE_RIGHT (124)
#define CGKEYCODE_DOWN (125)
#define CGKEYCODE_UP (126)


typedef CGEventRef (^EventRefGeneratingBlock)();


@interface FreemanRemoteProcess (PrivateMethods)

- (void)postEvent:(EventRefGeneratingBlock)block;
- (CGEventRef)createKeyboardEvent:(CGKeyCode)keyCode keyDown:(BOOL)keyDown;
- (CGKeyCode)mapSpecifierToKeyCode:(NSString *)specifier;

@end


@implementation FreemanRemoteProcess

@synthesize psn = _psn;


+ (id)remoteProcessWithSerialNumber:(ProcessSerialNumber)psn {
	return [[FreemanRemoteProcess alloc] initWithProcessSerialNumber:psn];
}


- (id)initWithProcessSerialNumber:(ProcessSerialNumber)psn {
	if( ( self = [super init] ) ) {
		_eventSourceRef = CGEventSourceCreate( kCGEventSourceStateCombinedSessionState ); // kCGEventSourceStateHIDSystemState );
		_psn = psn;
	}
	
	return self;
}


- (void)activate {
	SetFrontProcess( &_psn );
}


- (void)postEvent:(EventRefGeneratingBlock)block {
	CGEventRef eventRef = block();
	NSAssert( eventRef, @"Failed to create event" );
	CGEventPostToPSN( &_psn, eventRef );
	CFRelease( eventRef );
}


- (void)sendRightMouseClick:(CGPoint)clickPoint {
	[self postEvent:^() { return CGEventCreateMouseEvent( _eventSourceRef, kCGEventRightMouseDown, clickPoint, kCGMouseButtonRight ); }];
	[self postEvent:^() { return CGEventCreateMouseEvent( _eventSourceRef, kCGEventRightMouseUp, clickPoint, kCGMouseButtonRight ); }];
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
	[self postEvent:^() { return [self createKeyboardEvent:keyCode keyDown:YES]; }];
	[self postEvent:^() { return [self createKeyboardEvent:keyCode keyDown:NO]; }];
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


@end
