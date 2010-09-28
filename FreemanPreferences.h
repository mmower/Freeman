//
//  FreemanPreferences.h
//  Freeman
//
//  Created by Matt Mower on 20/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PRIMARY_STRUCTURE_BACKGROUND @"#454E58"
#define CORE_STRUCTURE_BACKGROUND @"#242A30"

extern NSString * const PrimaryStructureColourPrefKey;
extern NSString * const CoreStructureColourPrefKey;

extern NSString * const PrimaryFavouritesPrefKey;
extern NSString * const CoreFavouritesPrefKey;


@interface FreemanPreferences : NSObject {
}


+ (NSColor *)primaryStructureColor;
+ (void)setPrimaryStructureColor:(NSColor *)color;

+ (NSColor *)coreStructureColor;
+ (void)setCoreStructureColor:(NSColor *)color;


+ (NSString *)primaryFavouriteInSlot:(NSInteger)slot;
+ (void)setPrimaryFavourite:(NSString *)modulePath inSlot:(NSInteger)slot;

+ (NSString *)coreFavouriteInSlot:(NSInteger)slot;
+ (void)setCoreFavourite:(NSString *)modulePath inSlot:(NSInteger)slot;



@end
