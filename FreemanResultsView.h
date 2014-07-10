//
//  FreemanResultsView.h
//  Freeman
//
//  Created by Matt Mower on 10/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import <Foundation/Foundation.h>

@class FreemanOverlayManager;

@interface FreemanResultsView : NSTableView {
	FreemanOverlayManager *_overlayManager;
}

@property (assign) FreemanOverlayManager *overlayManager;

@end
