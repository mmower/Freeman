//
//  FreemanRemoteProcess.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreemanRemoteProcess : NSObject {
	id _delegate;
	CGEventSourceRef			_eventSourceRef;
	ProcessSerialNumber		_psn;
	CFMachPortRef					_tapMachPort;
}

@property (assign) id delegate;

@property (readonly) ProcessSerialNumber psn;

+ (id)remoteProcessWithSerialNumber:(ProcessSerialNumber)psn;

- (id)initWithProcessSerialNumber:(ProcessSerialNumber)psn;

- (void)suspendEventTap;
- (void)resumeEventTap;

- (void)activate;
- (void)sendRightMouseClick:(CGPoint)clickPoint;
- (void)sendKeyStroke:(CGKeyCode)keyCode;
- (void)sendKeySequence:(NSString *)keys;

@end
