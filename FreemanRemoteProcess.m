//
//  FreemanRemoteProcess.m
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanRemoteProcess.h"


@implementation FreemanRemoteProcess

@synthesize psn = _psn;

+ (id)remoteProcessWithSerialNumber:(ProcessSerialNumber)psn {
	return [[FreemanRemoteProcess alloc] initWithProcessSerialNumber:psn];
}


- (id)initWithProcessSerialNumber:(ProcessSerialNumber)psn {
	if( ( self = [super init] ) ) {
		_psn = psn;
	}
	
	return self;
}


- (void)rightMouseClick:(CGPoint)clickPoint {
	CGEventRef eventRef;
	
	eventRef = CGEventCreateMouseEvent( NULL, kCGEventRightMouseDown, clickPoint, kCGMouseButtonRight );
	NSAssert( eventRef != NULL, @"Failed to create kCGEventRightMouseDown" );
	CGEventPostToPSN( &_psn, eventRef );
	CFRelease( eventRef );
	
	eventRef = CGEventCreateMouseEvent( NULL, kCGEventRightMouseUp, clickPoint, kCGMouseButtonRight );
	NSAssert( eventRef != NULL, @"Failed to create kCGEventRightMouseUp" );
	CGEventPostToPSN( &_psn, eventRef );
	CFRelease( eventRef );	
}


@end
