//
//  FreemanRemoteProcess.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Foundation/Foundation.h>

@interface FreemanRemoteProcess : NSObject {
	id										_delegate;
	CGEventSourceRef			_eventSourceRef;
	ProcessSerialNumber		_psn;
	CFMachPortRef					_tapMachPort;
	
	
	CGPoint								_mousePosition;
	BOOL									_inFavouriteChordSequence;
}

@property (assign) id delegate;
@property (readonly) ProcessSerialNumber psn;
@property (assign) CGPoint mousePosition;
@property (assign) BOOL inFavouriteChordSequence;

+ (id)remoteProcessWithSerialNumber:(ProcessSerialNumber)psn;

- (id)initWithProcessSerialNumber:(ProcessSerialNumber)psn;

- (void)suspendEventTap;
- (void)resumeEventTap;

- (void)activate;
- (void)sendLeftMouseClick:(CGPoint)clickPoint;
- (void)sendRightMouseClick:(CGPoint)clickPoint;
- (void)sendKeySequence:(NSString *)keys;

- (void)offsetMousePositionByDX:(CGFloat)dx DY:(CGFloat)dy;

@end
