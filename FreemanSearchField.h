//
//  FreemanSearchField.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanOverlayManager;

@interface FreemanSearchField : NSTextField	{
	FreemanOverlayManager *_overlayManager;
}

@property (assign) FreemanOverlayManager *overlayManager;

@end
