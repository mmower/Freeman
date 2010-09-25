//
//  FreemanPreferences.h
//  Freeman
//
//  Created by Matt Mower on 20/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSString * const PrimaryFavouritesPrefKey;
extern NSString * const CoreFavouritesPrefKey;


@class FreemanModule;


@interface FreemanPreferences : NSObject {

}


// + (NSDictionary *)primaryFavourites;
// + (void)setPrimaryFavourites:(NSDictionary *)favourites;


+ (NSString *)primaryFavouriteInSlot:(NSInteger)slot;
+ (void)setPrimaryFavourite:(NSString *)modulePath inSlot:(NSInteger)slot;


// + (NSDictionary *)coreFavourites;
// + (void)setCoreFavourites:(NSDictionary *)favourites;


+ (NSString *)coreFavouriteInSlot:(NSInteger)slot;
+ (void)setCoreFavourite:(NSString *)modulePath inSlot:(NSInteger)slot;



@end
