//
//  FreemanFavouritesManager.h
//  Freeman
//
//  Created by Matt Mower on 26/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FreemanModuleDatabase;

@interface FreemanFavouritesManager : NSWindowController {
	NSArray		*_favourites;
}

@property (assign) NSArray *favourites;

- (void)showForModuleDatabase:(FreemanModuleDatabase *)moduleDatabase atPoint:(CGPoint)point;
- (void)hide;


@end
