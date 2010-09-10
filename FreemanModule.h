//
//  FreemanModule.h
//  Freeman
//
//  Created by Matt Mower on 09/09/2010.
//  Copyright 2010 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FreemanModule : NSObject {
	NSString		*_name;
	float			_scoreForLastAbbreviation;
	NSString		*_navigationSequence;
	NSArray			*_menuHierarchy;
}

@property (assign) NSString *name;
@property (assign) float scoreForLastAbbreviation;
@property (assign) NSString *navigationSequence;
@property (assign) NSArray *menuHierarchy;

- (id)initWithName:(NSString *)name navigationSequence:(NSString *)navigationSequence menuHierarchy:(NSArray *)menuHierarchy;

@end
