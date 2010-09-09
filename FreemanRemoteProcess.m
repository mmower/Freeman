//
//  FreemanRemoteProcess.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanRemoteProcess.h"


#define CGKEYCODE_RIGHT (124)
#define CGKEYCODE_DOWN (125) //125
#define CGKEYCODE_UP (126)
#define CGKEYCODE_RETURN (36)


typedef CGEventRef (^EventRefGeneratingBlock)();

//CGEventTimestamp delayEventByMillis( CGEventTimestamp timeStamp, int millis ) {
//	return timeStamp + (millis * 1000000);
//}


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
		_eventSourceRef = CGEventSourceCreate( kCGEventSourceStateCombinedSessionState );
		_psn = psn;
	}
	
	return self;
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


- (void)sendKeySequence:(NSString *)keys {
	for( int i = 0; i < [keys length]; i++ ) {
		NSString *specifier = [keys substringWithRange:NSMakeRange(i, 1)];
		[self sendKeyStroke:[self mapSpecifierToKeyCode:specifier]];
		if( [specifier isEqualToString:@"R"] ) {
			usleep(125000);
		}
	}
}


- (void)sendRightKey {
	[self sendKeyStroke:CGKEYCODE_RIGHT];
}


- (void)sendDownKey {
	[self sendKeyStroke:CGKEYCODE_DOWN];
}


- (void)sendUpKey {
	[self sendKeyStroke:CGKEYCODE_UP];
}


- (void)sendReturnKey {
	[self sendKeyStroke:CGKEYCODE_RETURN];
}


- (CGKeyCode)mapSpecifierToKeyCode:(NSString *)specifier {
	if( [specifier isEqualToString:@"D"] ) {
		return CGKEYCODE_DOWN;
	} else if( [specifier isEqualToString:@"R" ] ) {
		return CGKEYCODE_RIGHT;
	} else if( [specifier isEqualToString:@"!" ] ) {
		return CGKEYCODE_RETURN;
	} else {
		NSAssert1( NO, @"Unknown specified %@ encountered", specifier );
	}
	
	return 0;
}


@end
