//
//  FreemanFieldEditor.h
//  Freeman
//
//  Created by Matt Mower on 11/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanOverlayManager;

@interface FreemanFieldEditor : NSTextView {
	FreemanOverlayManager		*_overlayManager;
	BOOL										_inQuickSelect;
}

@property (assign) FreemanOverlayManager *overlayManager;

@end
