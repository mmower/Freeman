//
//  FreemanPreferences.m
//  Freeman
//
//  Created by Matt Mower on 20/09/2010.
//  Copyright 2010 Matt Mower. All rights reserved.
//  Released under the MIT license, see LICENSE file included with this source
//


#import "FreemanPreferences.h"

#import "FreemanModule.h"

#import "NSColor+Freeman.h"

NSString * const PrimaryStructureColorPrefKey = @"com.lucidmac.freeman.primary.structure.color";
NSString * const CoreStructureColorPrefKey    = @"com.lucidmac.freeman.core.structure.color";

NSString * const PrimaryFavouritesPrefKey     = @"com.lucidmac.freeman.favourites.primary.%d";
NSString * const CoreFavouritesPrefKey        = @"com.lucidmac.freeman.favourites.core.%d";


@implementation FreemanPreferences


+ (void)initialize {
  NSMutableDictionary *defaultPreferenceValues = [NSMutableDictionary dictionary];
	[defaultPreferenceValues setObject:PRIMARY_STRUCTURE_BACKGROUND forKey:PrimaryStructureColorPrefKey];
	[defaultPreferenceValues setObject:CORE_STRUCTURE_BACKGROUND forKey:CoreStructureColorPrefKey];
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferenceValues];
}


+ (NSColor *)primaryStructureColor {
	return [NSColor colorFromHexRGB:[[NSUserDefaults standardUserDefaults] objectForKey:PrimaryStructureColorPrefKey]];
}


+ (void)setPrimaryStructureColor:(NSColor *)color {
	[[NSUserDefaults standardUserDefaults] setObject:[color asHexString] forKey:PrimaryStructureColorPrefKey];
}


+ (NSColor *)coreStructureColor {
	return [NSColor colorFromHexRGB:[[NSUserDefaults standardUserDefaults] objectForKey:CoreStructureColorPrefKey]];
}


+ (void)setCoreStructureColor:(NSColor *)color {
	[[NSUserDefaults standardUserDefaults] setObject:[color asHexString] forKey:CoreStructureColorPrefKey];
}


+ (NSString *)primaryFavouriteInSlot:(NSInteger)slot {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:PrimaryFavouritesPrefKey,slot]];
}


+ (void)setPrimaryFavourite:(NSString *)modulePath inSlot:(NSInteger)slot {
	[[NSUserDefaults standardUserDefaults] setObject:modulePath forKey:[NSString stringWithFormat:PrimaryFavouritesPrefKey,slot]];
}


+ (NSString *)coreFavouriteInSlot:(NSInteger)slot {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:CoreFavouritesPrefKey,slot]];
}


+ (void)setCoreFavourite:(NSString *)modulePath inSlot:(NSInteger)slot {
	[[NSUserDefaults standardUserDefaults] setObject:modulePath forKey:[NSString stringWithFormat:CoreFavouritesPrefKey,slot]];
}


@end
