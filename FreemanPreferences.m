//
//  FreemanPreferences.m
//  Freeman
//
//  Created by Matt Mower on 20/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import "FreemanPreferences.h"

#import "FreemanModule.h"


NSString * const PrimaryFavouritesPrefKey = @"com.lucidmac.freeman.favourites.primary.%d";
NSString * const CoreFavouritesPrefKey    = @"com.lucidmac.freeman.favourites.core.%d";


@implementation FreemanPreferences


+ (void)initialize {
  NSMutableDictionary *defaultPreferenceValues = [NSMutableDictionary dictionary];
  // [defaultPreferenceValues setObject:[NSDictionary dictionary] forKey:PrimaryFavouritesPrefKey];
  // [defaultPreferenceValues setObject:[NSDictionary dictionary] forKey:CoreFavouritesPrefKey];
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferenceValues];
}


// + (NSDictionary *)primaryFavourites {
// 	return [[NSUserDefaults standardUserDefaults] objectForKey:PrimaryFavouritesPrefKey];
// }


// + (void)setPrimaryFavourites:(NSDictionary *)favourites {
// 	[[NSUserDefaults standardUserDefaults] setObject:favourites forKey:PrimaryFavouritesPrefKey];
// }


+ (NSString *)primaryFavouriteInSlot:(NSInteger)slot {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:PrimaryFavouritesPrefKey,slot]];
}


+ (void)setPrimaryFavourite:(NSString *)modulePath inSlot:(NSInteger)slot {
	[[NSUserDefaults standardUserDefaults] setObject:modulePath forKey:[NSString stringWithFormat:PrimaryFavouritesPrefKey,slot]];
	// 
	// 
	// NSMutableDictionary *tempFavourites = [NSMutableDictionary dictionaryWithDictionary:[self primaryFavourites]];
	// [tempFavourites setObject:[module path] forKey:[NSNumber numberWithInteger:slot]];
	// [self setPrimaryFavourites:tempFavourites];
}


// + (NSDictionary *)coreFavourites {
// 	return [[NSUserDefaults standardUserDefaults] objectForKey:CoreFavouritesPrefKey];
// }
// 
// 
// + (void)setCoreFavourites:(NSDictionary *)favourites {
// 	[[NSUserDefaults standardUserDefaults] setObject:favourites forKey:CoreFavouritesPrefKey];
// }


+ (NSString *)coreFavouriteInSlot:(NSInteger)slot {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:CoreFavouritesPrefKey,slot]];
}


+ (void)setCoreFavourite:(NSString *)modulePath inSlot:(NSInteger)slot {
	[[NSUserDefaults standardUserDefaults] setObject:modulePath forKey:[NSString stringWithFormat:CoreFavouritesPrefKey,slot]];
	// NSMutableDictionary *tempFavourites = [NSMutableDictionary dictionaryWithDictionary:[self coreFavourites]];
	// [tempFavourites setObject:[module path] forKey:[NSNumber numberWithInteger:slot]];
	// [self setCoreFavourites:tempFavourites];
}


@end
