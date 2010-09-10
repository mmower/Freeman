//
//  FreemanResultsView.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FreemanOverlayManager;

@interface FreemanResultsView : NSTableView {
	FreemanOverlayManager *_overlayManager;
}

@property (assign) FreemanOverlayManager *overlayManager;

@end
