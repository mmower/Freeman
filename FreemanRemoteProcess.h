//
//  FreemanRemoteProcess.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FreemanRemoteProcess : NSObject {
	ProcessSerialNumber		_psn;

}

@property (readonly) ProcessSerialNumber psn;

+ (id)remoteProcessWithSerialNumber:(ProcessSerialNumber)psn;

- (id)initWithProcessSerialNumber:(ProcessSerialNumber)psn;

- (void)rightMouseClick:(CGPoint)clickPoint;

@end
