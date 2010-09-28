//
//  FreemanFavouritesManager.m
//  Freeman
//
//  Created by Matt Mower on 26/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanFavouritesManager.h"

#import "FreemanModuleDatabase.h"
#import "FreemanPreferences.h"

#import "NSScreen+Freeman.h"


@interface FreemanFavouritesManager (PrivateMethods)

- (void)updateFavouritesForModuleDatabase:(FreemanModuleDatabase *)moduleDatabase;

@end


@implementation FreemanFavouritesManager


@synthesize favourites = _favourites;


- (id)init {
	if( ( self = [self initWithWindowNibName:@"Favourites"] ) ) {
	}
	
	return self;
}


- (void)showForModuleDatabase:(FreemanModuleDatabase *)moduleDatabase atPoint:(CGPoint)point {
	[self updateFavouritesForModuleDatabase:moduleDatabase];
	
	CGPoint flipped = [[NSScreen mainScreen] flipPoint:point];
	NSPoint topLeft = NSMakePoint( flipped.x, flipped.y );
	
	[[self window] setFrameTopLeftPoint:topLeft];
	[[self window] setLevel:NSFloatingWindowLevel];
	[[self window] orderFront:self];
}


- (void)updateFavouritesForModuleDatabase:(FreemanModuleDatabase *)moduleDatabase {
	NSMutableArray *favourites = [NSMutableArray arrayWithCapacity:10];
	
	NSNumber *slot;
	NSString *path;
	FreemanModule *module;
	NSString *value;
	
	for( int n = 1; n <= 10; n++ ) {
		slot = [NSNumber numberWithInteger:(n % 10)];
		
		if( [moduleDatabase primary] ) {
			path = [FreemanPreferences primaryFavouriteInSlot:n];
		} else {
			path = [FreemanPreferences coreFavouriteInSlot:n];
		}
		
		if( path ) {
			module = [moduleDatabase moduleWithPath:path];
			if( module ) {
				value = [module name];
			} else {
				value = @"- missing -";
			}
		} else {
			value = @"- not assigned -";
		}
		
		NSDictionary *favourite = [NSDictionary dictionaryWithObjectsAndKeys:slot,@"slot",value,@"value",nil];
		NSLog( @"Favourites = %@", favourite );
		[favourites addObject:favourite];
	}
	[self setFavourites:favourites];
}


- (void)hide {
	[[self window] orderOut:self];
}


@end
